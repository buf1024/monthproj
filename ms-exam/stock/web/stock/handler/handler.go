package handler

import (
	"context"
	"encoding/json"
	"github.com/micro/go-micro/client"
	"github.com/micro/go-micro/util/log"
	"net/http"

	stock "github.com/buf1024/monthproj/ms-exam/stock/srv/stock/proto/stock"
)

var (
	stockService stock.StockService
)

func Init() {
	log.Info("初始化客户端")
	stockService = stock.NewStockService("com.toyent.srv.stock", client.DefaultClient)
}

func StockQuery(w http.ResponseWriter, r *http.Request) {
	queryReq := stock.QueryRequest{}
	if err := json.NewDecoder(r.Body).Decode(&queryReq); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("查询请求: %v", queryReq.String())

	queryRsp := &stock.QueryResponse{
		Sid: queryReq.Sid,
	}

	defer func() {
		log.Logf("查询应答: %v", queryRsp.String())
	}()

	log.Logf("调用STOCK服务请求: %v", queryReq)
	queryRsp, err := stockService.Query(context.TODO(), &queryReq)
	if err != nil {
		log.Logf("调用STOCK服务异常: %v", err)
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("调用STOCK服务应答: %v", queryRsp)
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

func StockQuot(w http.ResponseWriter, r *http.Request) {
	quotReq := stock.QuotRequest{}
	if err := json.NewDecoder(r.Body).Decode(&quotReq); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("查询请求: %v", quotReq.String())

	quotRsp := &stock.QuotResponse{
		Sid: quotReq.Sid,
	}

	defer func() {
		log.Logf("查询应答: %v", quotRsp.String())
	}()

	log.Logf("调用STOCK服务请求: %v", quotReq)
	quotRsp, err := stockService.Quot(context.TODO(), &quotReq)
	if err != nil {
		log.Logf("调用STOCK服务异常: %v", err)
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("调用STOCK服务应答: %v", quotRsp)

	quotRsp.Status = "SUCCESS"
	quotRsp.Message = "SUCCESS"
	if err := json.NewEncoder(w).Encode(quotRsp); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
}
