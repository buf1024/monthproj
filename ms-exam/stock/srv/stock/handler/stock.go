package handler

import (
	"context"
	"fmt"
	"github.com/buf1024/monthproj/ms-exam/stock/srv/stock/model"

	"github.com/buf1024/monthproj/ms-exam/stock/lib/util"
	"github.com/micro/go-micro/util/log"

	stock "github.com/buf1024/monthproj/ms-exam/stock/srv/stock/proto/stock"
)

type Stock struct{}

func (e *Stock) Query(ctx context.Context, req *stock.QueryRequest, rsp *stock.QueryResponse) error {
	log.Logf("Stock.Query 请求: %v", req)
	if !util.SaveSid("stock:query:sid:" + req.Sid, req.StockId) {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("stock:query:sid:" + req.Sid)
		log.Logf("Stock.Query 应答: %v", rsp)
	}()

	rsp.Sid = req.Sid

	stocks, err := model.QueryStock(req.StockId)
	if err != nil {
		log.Logf("查询stockId=%v 异常: %v", req.StockId, err)
		rsp.Status = "FAILED"
		rsp.Message = err.Error()
		return  err
	}

	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"
	rsp.Stock = stocks

	return nil
}

func (e *Stock) Price(ctx context.Context, req *stock.PriceRequest, rsp *stock.PriceResponse) error {
	log.Logf("Stock.Price 请求: %v", req)
	if !util.SaveSid("stock:price:sid:" + req.Sid, req.StockId) {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("stock:price:sid:" + req.Sid)
		log.Logf("Stock.Price 应答: %v", rsp)
	}()

	rsp.Sid = req.Sid

	err := model.InsertQuot(req.StockId, req.Price)
	if err != nil {
		log.Logf("行情价格stockId=%v 异常: %v", req.StockId, err)
		rsp.Status = "FAILED"
		rsp.Message = err.Error()
		return  err
	}

	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"

	return nil
}
func (e *Stock) Quot(ctx context.Context, req *stock.QuotRequest, rsp *stock.QuotResponse) error {
	log.Logf("Stock.Quot 请求: %v", req)
	if !util.SaveSid("stock:quot:sid:" + req.Sid, req.StockId) {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("stock:quot:sid:" + req.Sid)
		log.Logf("Stock.Quot 应答: %v", rsp)
	}()

	rsp.Sid = req.Sid


	quotPrice, err := model.GetQuot(req.StockId, req.BeginTime, req.EndTime)
	if err != nil {
		log.Logf("查询stockId=%v 异常: %v", req.StockId, err)
		rsp.Status = "FAILED"
		rsp.Message = err.Error()
		return  err
	}

	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"

	quot := stock.Quot{}
	quot.StockId = req.StockId
	quot.Price = quotPrice

	rsp.Quot = &quot
	return nil
}


func (e *Stock) OpenTrade(ctx context.Context, req *stock.OpenTradeRequest, rsp *stock.OpenTradeResponse) error {
	log.Logf("Stock.OpenTrade 请求: %v", req)
	if !util.SaveSid("stock:opentrade:sid:" + req.Sid, "opentrade") {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("stock:opentrade:sid:" + req.Sid)
		log.Logf("Stock.OpenTrade 应答: %v", rsp)
	}()

	rsp.Sid = req.Sid

	err := model.OpenTrade()
	if err != nil {
		log.Logf("开市异常: %v",  err)
		rsp.Status = "FAILED"
		rsp.Message = err.Error()
		return  err
	}

	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"

	return nil
}