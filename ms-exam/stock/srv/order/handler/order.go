package handler

import (
	"context"
	"fmt"
	"github.com/buf1024/monthproj/ms-exam/stock/lib/util"
	"github.com/buf1024/monthproj/ms-exam/stock/srv/order/model"
	"github.com/micro/go-micro/client"
	"github.com/micro/go-micro/util/log"

	acct "github.com/buf1024/monthproj/ms-exam/stock/srv/acct/proto/acct"
	order "github.com/buf1024/monthproj/ms-exam/stock/srv/order/proto/order"
)
var (
	acctService acct.AcctService
)

func Init() {
	log.Info("初始化客户端")
	acctService = acct.NewAcctService("com.toyent.srv.acct", client.DefaultClient)
}

type Order struct{}

func (e *Order) QueryOrder(ctx context.Context, req *order.QueryOrderRequest, rsp *order.QueryOrderResponse) error {
	log.Logf("Order.QueryOrder 请求: %v", req)
	if !util.SaveSid("order:queryholdorder:sid:" + req.Sid, req.UserId) {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("order:queryholdorder:sid:" + req.Sid)
		log.Logf("Order.QueryOrder 应答: %v", rsp)
	}()

	rsp.Sid = req.Sid

	orders, err := model.QueryOrder(req.UserId, req.StockId, req.OrderId)
	if err != nil {
		log.Logf("查询单据信息异常: %v", err)
		rsp.Status = "FAILED"
		rsp.Message = err.Error()
		return nil
	}
	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"
	rsp.Order = orders

	return nil
}
func (e *Order) Order(ctx context.Context, req *order.OrderRequest, rsp *order.OrderResponse) error {
	log.Logf("Order.Order 请求: %v", req)
	if !util.SaveSid("order:order:sid:" + req.Sid, req.UserId) {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("order:order:sid:" + req.Sid)
		log.Logf("Order.Order 应答: %v", rsp)
	}()
	rsp.Sid = req.Sid
	var orderId int64
	var err error
	if req.OrderType == 0 {
		orderId, err = model.InsertSellOrder(req)
		if err != nil {
			log.Logf("插入卖单信息异常: %v", err)
			rsp.Status = "FAILED"
			rsp.Message = err.Error()
			return nil
		}
	} else {
		acctReq := &acct.QueryRequest{Sid: req.Sid, UserId: req.UserId}

		log.Logf("调用账户服务查询余额请求: %v", acctReq)
		acctRsp, err := acctService.Query(ctx, acctReq)
		if err != nil {
			log.Logf("调用账户服务查询余额异常: %v", err)
			rsp.Status = "FAILED"
			rsp.Message = err.Error()
			return nil
		}
		log.Logf("调用账户服务查询余额应答: %v", acctRsp)
		if acctRsp.Status != "SUCCESS" {
			rsp.Status = "FAILED"
			rsp.Message = acctRsp.Message
			return nil
		}
		price := req.OrderPrice * (float64)(req.OrderNumber)
		if price > acctRsp.Balance{
			log.Logf("余额不足: %v, 单据: %v", acctRsp.Balance, price)
			rsp.Status = "FAILED"
			rsp.Message = fmt.Sprintf("余额不足: %v, 单据: %v", acctRsp.Balance, price)
			return nil
		}
		// 此处处理不行
		chgReq := &acct.ChangeRequest{Sid: req.Sid, UserId: req.UserId, Amount: -price}
		log.Logf("调用账户服务变更(冻结)余额请求: %v", chgReq)
		chgRsp, err := acctService.Change(ctx, chgReq)
		if err != nil {
			log.Logf("调用账户服务变更(冻结)余额异常: %v", err)
			rsp.Status = "FAILED"
			rsp.Message = err.Error()
			return nil
		}
		log.Logf("调用账户服务变更(冻结)余额应答: %v", chgRsp)
		if chgRsp.Status != "SUCCESS" {
			rsp.Status = "FAILED"
			rsp.Message = acctRsp.Message
			return nil
		}
		orderId, err = model.InsertBuyOrder(req)
		if err != nil {
			log.Logf("插入买单信息异常: %v", err)
			rsp.Status = "FAILED"
			rsp.Message = err.Error()

			chgReq.Amount = -chgReq.Amount
			for i:=0; i<3; i++ {
				log.Logf("调用账户服务冲正余额请求: %v", chgReq)
				chgRsp, err := acctService.Change(ctx, chgReq)
				if err != nil {
					log.Logf("调用账户服务冲正余额异常: %v", err)
					continue
				}
				log.Logf("调用账户服务冲正余额应答: %v", chgRsp)
				break
			}

			return nil
		}
	}

	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"
	rsp.OrderId = orderId

	return nil
}
func (e *Order) QueryHold(ctx context.Context, req *order.QueryHoldRequest, rsp *order.QueryHoldResponse) error {
	log.Logf("Order.QueryHold 请求: %v", req)
	if !util.SaveSid("order:queryhold:sid:" + req.Sid, req.UserId) {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("order:queryhold:sid:" + req.Sid)
		log.Logf("Order.QueryHold 应答: %v", rsp)
	}()
	rsp.Sid = req.Sid

	holds, err := model.QueryHold(req.UserId, req.StockId)
	if err != nil {
		log.Logf("查询持仓信息异常: %v", err)
		rsp.Status = "FAILED"
		rsp.Message = err.Error()
		return nil
	}
	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"
	rsp.HoldOrder = holds

	return nil
}

func (e *Order) Cancel(ctx context.Context, req *order.CancelRequest, rsp *order.CancelResponse) error {
	log.Logf("Order.Cancel 请求: %v", req)
	if !util.SaveSid("order:cancel:sid:" + req.Sid, fmt.Sprintf("%d", req.OrderId)) {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("order:cancel:sid:" + req.Sid)
		log.Logf("Order.Cancel 应答: %v", rsp)
	}()

	rsp.Sid = req.Sid

	dealNum, undealNum, status, err := model.CancelOrder(req.UserId, req.OrderId)
	if err != nil {
		log.Logf("查询单据信息异常: %v", err)
		rsp.Status = "FAILED"
		rsp.Message = err.Error()
		return nil
	}
	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"
	rsp.OrderStatus = int32(status)
	rsp.DealNumber = int32(dealNum)
	rsp.UndealNumber = int32(undealNum)

	return nil
}