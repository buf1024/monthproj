package handler

import (
	"context"
	"github.com/buf1024/monthproj/ms-exam/stock/lib/util"
	"github.com/buf1024/monthproj/ms-exam/stock/srv/order-deal/model"
	"github.com/google/uuid"
	"github.com/micro/go-micro/client"

	"fmt"
	"time"

	"github.com/micro/go-micro/util/log"

	acct "github.com/buf1024/monthproj/ms-exam/stock/srv/acct/proto/acct"
	stock "github.com/buf1024/monthproj/ms-exam/stock/srv/stock/proto/stock"
)

var (
	stockService stock.StockService
	acctService acct.AcctService
)

func Init() {
	log.Info("初始化客户端")
	stockService = stock.NewStockService("com.toyent.srv.stock", client.DefaultClient)
	acctService = acct.NewAcctService("com.toyent.srv.acct", client.DefaultClient)
}

func HandleOrder() {
	log.Logf("启动撮合")
	stockChan := make(chan string)
	go deliverStock(stockChan)
	go dayRollStock()
	for {
		stockReq := &stock.QueryRequest{Sid: uuid.New().String()}
		stockRsp, err := stockService.Query(context.Background(), stockReq)
		if err != nil {
			log.Logf("查询股票信息异常: %v", err)
			time.Sleep(time.Second * 10)
			continue
		}
		if stockRsp.Status != "SUCCESS" {
			log.Logf("查询股票信息异常")
			time.Sleep(time.Second * 10)
			continue
		}
		for _, s := range stockRsp.Stock {
			stockChan <- s.StockId
		}
		time.Sleep(time.Minute)
	}
}

func deliverStock(stockChan <- chan string)  {
	log.Logf("分发stockid启动")
	stockMap := make(map[string]bool)
	for {
		select {
		case stockId, ok := <- stockChan:
			if !ok {
				log.Logf("chan 关闭了")
				break
			}
			_, ok = stockMap[stockId]
			if !ok {
				stockMap[stockId] = true
				go handleStock(stockId)
			}
		}
	}
}
func dayRollStock() {
	var lastCheck *time.Time
	for {
		now := time.Now()
		now = time.Date(now.Year(), now.Month(), now.Day(), 0, 0, 0, 0, now.Location())
		if lastCheck == nil {
			 lastCheck = &now
		}
		if now.Unix() > lastCheck.Unix() {
			lastCheck = &now

			now0 := fmt.Sprintf("%04d-%02d-%02d 00:00:00", now.Year(), now.Month(), now.Day())

			if err := model.DelExpireOrder(now0); err != nil {
				log.Logf("删除过期订单异常: %v", err)
			}
			openReq := &stock.OpenTradeRequest{
				Sid: uuid.New().String(),
			}
			log.Logf("重新开市请求: %v", openReq)
			openRsp, err := stockService.OpenTrade(context.TODO(), openReq)
			if err != nil {
				log.Logf("重新开市异常: %v", err)
			} else {
				log.Logf("重新开市应答: %v", openRsp)
			}
		}
		time.Sleep(time.Second * 30)
	}
}
func handleStock(stockId string)  {
	log.Logf("开始处理单据撮合, stockid=%v", stockId)
	for  {
		buyOrder, buyKey, err := util.GetOrderQueue("buy", stockId)
		if err != nil {
			log.Logf("获取订单队列异常: %v", err)
			time.Sleep(time.Second * 10)
			continue
		}
		if buyOrder == nil {
			time.Sleep(time.Second * 10)
			continue
		}
		valid, err := model.CheckOrder(buyOrder)
		if err != nil {
			log.Logf("检查单据异常: %v", err)
			time.Sleep(time.Second * 10)
			continue
		}
		if !valid {
			err = util.DelOrder(buyKey)
			if err != nil {
				log.Logf("删除撤销的单据队列异常: %v", err)
				time.Sleep(time.Second * 10)
				continue
			}
		}
		sellOrder, sellKey, err := util.GetOrderQueue("sell", stockId)
		if err != nil {
			log.Logf("获取订单队列异常: %v", err)
			time.Sleep(time.Second * 10)
			continue
		}
		if sellOrder == nil {
			time.Sleep(time.Second * 10)
			continue
		}
		valid, err = model.CheckOrder(sellOrder)
		if err != nil {
			log.Logf("检查单据异常: %v", err)
			time.Sleep(time.Second * 10)
			continue
		}
		if !valid {
			err = util.DelOrder(sellKey)
			if err != nil {
				log.Logf("删除撤销的单据队列异常: %v", err)
				time.Sleep(time.Second * 10)
				continue
			}
		}

		if buyOrder.OrderPrice >= sellOrder.OrderPrice {
			log.Logf("买单: %v 卖单: %v 撮合成交， 成交单价: %v", buyOrder.OrderId, sellOrder.OrderId, buyOrder.OrderPrice)
			dealNum, err := model.DealOrder(acctService, sellOrder, buyOrder)
			if err != nil {
				log.Logf("撮合插数据库异常: ", err)
				time.Sleep(time.Second * 10)
				continue
			}
			err = util.DealOrderQuery(sellKey, buyKey, dealNum)
			if err != nil {
				log.Logf("删除成交单队列失败: %v", err)
				time.Sleep(time.Second * 10)
				continue
			}
			priceReq := &stock.PriceRequest{
				Sid: uuid.New().String(),
				StockId: buyOrder.StockId,
				Price: buyOrder.OrderPrice,
			}
			priceRsp, err := stockService.Price(context.Background(), priceReq)
			if err != nil || priceRsp.Status != "SUCCESS"{
				log.Logf("生成价格异常")
				time.Sleep(time.Second * 10)
				continue
			}
		}
		log.Logf("假睡...")
		time.Sleep(time.Second * 10)
	}

}