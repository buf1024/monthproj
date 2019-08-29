package handler

import (
	"context"
	"encoding/json"
	order "github.com/buf1024/monthproj/ms-exam/stock/srv/order/proto/order"
	"github.com/micro/go-micro/client"
	"github.com/micro/go-micro/util/log"
	"net/http"
)

var (
	orderService order.OrderService
)

func Init() {
	log.Info("初始化客户端")
	orderService = order.NewOrderService("com.toyent.srv.order", client.DefaultClient)
}

func OrderOrder(w http.ResponseWriter, r *http.Request) {
	orderReq := order.OrderRequest{}
	if err := json.NewDecoder(r.Body).Decode(&orderReq); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("下单请求: %v", orderReq.String())

	orderRsp := &order.OrderResponse{
		Sid: orderReq.Sid,
	}

	defer func() {
		log.Logf("查询应答: %v", orderRsp.String())
	}()

	log.Logf("调用订单服务请求: %v", orderReq)
	orderRsp, err := orderService.Order(context.TODO(), &orderReq)
	if err != nil {
		log.Logf("调用订单服务异常: %v", err)
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("调用订单服务应答: %v", orderRsp)
	if orderRsp.Status == "FAILED" {
		w.WriteHeader(http.StatusOK)
		if err := json.NewEncoder(w).Encode(orderRsp); err != nil {
			http.Error(w, err.Error(), 500)
		}
		return
	}
	orderRsp.Status = "SUCCESS"
	orderRsp.Message = "SUCCESS"
	if err := json.NewEncoder(w).Encode(orderRsp); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
}
func OrderQuery(w http.ResponseWriter, r *http.Request) {
	queryReq := order.QueryOrderRequest{}
	if err := json.NewDecoder(r.Body).Decode(&queryReq); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("查询请求: %v", queryReq.String())

	queryRsp := &order.QueryOrderResponse{
		Sid: queryReq.Sid,
	}

	defer func() {
		log.Logf("查询应答: %v", queryRsp.String())
	}()

	log.Logf("调用订单服务请求: %v", queryReq)
	queryRsp, err := orderService.QueryOrder(context.TODO(), &queryReq)
	if err != nil {
		log.Logf("调用订单服务异常: %v", err)
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("调用订单服务应答: %v", queryRsp)
	if queryRsp.Status == "FAILED" {
		w.WriteHeader(http.StatusOK)
		if err := json.NewEncoder(w).Encode(queryRsp); err != nil {
			http.Error(w, err.Error(), 500)
		}
		return
	}
	queryRsp.Status = "SUCCESS"
	queryRsp.Message = "SUCCESS"
	if err := json.NewEncoder(w).Encode(queryRsp); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
}
func OrderQueryHold(w http.ResponseWriter, r *http.Request) {
	queryReq := order.QueryHoldRequest{}
	if err := json.NewDecoder(r.Body).Decode(&queryReq); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("查询持仓请求: %v", queryReq.String())

	queryRsp := &order.QueryHoldResponse{
		Sid: queryReq.Sid,
	}

	defer func() {
		log.Logf("查询持仓应答: %v", queryRsp.String())
	}()

	log.Logf("调用订单服务请求: %v", queryReq)
	queryRsp, err := orderService.QueryHold(context.TODO(), &queryReq)
	if err != nil {
		log.Logf("调用订单服务异常: %v", err)
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("调用订单服务应答: %v", queryRsp)
	if queryRsp.Status == "FAILED" {
		w.WriteHeader(http.StatusOK)
		if err := json.NewEncoder(w).Encode(queryRsp); err != nil {
			http.Error(w, err.Error(), 500)
		}
		return
	}
	queryRsp.Status = "SUCCESS"
	queryRsp.Message = "SUCCESS"
	if err := json.NewEncoder(w).Encode(queryRsp); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
}
func OrderCancel(w http.ResponseWriter, r *http.Request) {
	cancelReq := order.CancelRequest{}
	if err := json.NewDecoder(r.Body).Decode(&cancelReq); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("取消订单请求: %v", cancelReq.String())

	cancelRsp := &order.CancelResponse{
		Sid: cancelReq.Sid,
	}

	defer func() {
		log.Logf("取消订单应答: %v", cancelRsp.String())
	}()

	log.Logf("调用订单服务请求: %v", cancelReq)
	cancelRsp, err := orderService.Cancel(context.TODO(), &cancelReq)
	if err != nil {
		log.Logf("调用订单服务异常: %v", err)
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("调用订单服务应答: %v", cancelRsp)
	if cancelRsp.Status == "FAILED" {
		w.WriteHeader(http.StatusOK)
		if err := json.NewEncoder(w).Encode(cancelRsp); err != nil {
			http.Error(w, err.Error(), 500)
		}
		return
	}
	cancelRsp.Status = "SUCCESS"
	cancelRsp.Message = "SUCCESS"
	if err := json.NewEncoder(w).Encode(cancelRsp); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
}
