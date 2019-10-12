package handler

import (
	"context"
	"fmt"
	"github.com/buf1024/monthproj/ms-exam/stock/lib/util"
	"github.com/buf1024/monthproj/ms-exam/stock/srv/acct/model"

	"github.com/micro/go-micro/util/log"

	acct "github.com/buf1024/monthproj/ms-exam/stock/srv/acct/proto/acct"
)

type Acct struct{}


func (e *Acct) Open(ctx context.Context, req *acct.OpenRequest, rsp *acct.OpenResponse) error {
	log.Logf("Acct.Open 请求: %v", req)
	if !util.SaveSid("acct:open:sid:" + req.Sid, req.UserId) {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("acct:open:sid:" + req.Sid)
		log.Logf("Acct.Open 应答: %v", rsp)
	}()

	rsp.Sid = req.Sid
	_, err := model.QueryAccount(req.UserId)
	if err == nil {
		log.Logf("用户ID: %v 已经存在", req.UserId)
		rsp.Status = "FAILED"
		rsp.Message = fmt.Sprintf("用户ID: %v已经存在", req.UserId)
		return nil
	}
	id, err := model.InsertAccount(req.UserId, 100000.00)
	if err != nil {
		log.Log("插入账户表异常", req.UserId)
		rsp.Status = "FAILED"
		rsp.Message = fmt.Sprintf("用户ID: %v已经存在", req.UserId)
		return nil
	}
	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"
	rsp.AccountId = id
	rsp.Balance = 100000.00

	return nil
}

func (e *Acct) Query(ctx context.Context, req *acct.QueryRequest, rsp *acct.QueryResponse) error {
	log.Logf("Acct.Query 请求: %v", req)
	if !util.SaveSid("acct:query:sid:" + req.Sid, req.UserId) {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("acct:query:sid:" + req.Sid)
		log.Logf("Acct.Query 应答: %v", rsp)
	}()

	rsp.Sid = req.Sid
	balance, err := model.QueryAccount(req.UserId)
	if err != nil {
		log.Logf("用户ID: %v 不存在", req.UserId)
		rsp.Status = "FAILED"
		rsp.Message = fmt.Sprintf("用户ID: %v 不存在", req.UserId)
		return nil
	}
	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"
	rsp.Balance = balance

	return nil
}


func (e *Acct) Change(ctx context.Context, req *acct.ChangeRequest, rsp *acct.ChangeResponse) error {
	log.Logf("Acct.Change 请求: %v", req)
	if !util.SaveSid("acct:open:sid:" + req.Sid, req.UserId) {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("acct:open:sid:" + req.Sid)
		log.Logf("Acct.Change 应答: %v", rsp)
	}()
	rsp.Sid = req.Sid
	balance, err := model.QueryAccount(req.UserId)
	if err != nil {
		log.Logf("用户ID: %v 不存在", req.UserId)
		rsp.Status = "FAILED"
		rsp.Message = fmt.Sprintf("用户ID: %v 不存在", req.UserId)
		return nil
	}
	if balance + req.Amount < 0 {
		rsp.Status = "FAILED"
		rsp.Message = fmt.Sprintf("用户ID: %v 余额不足, 余额: %v", req.UserId, balance)
		return nil
	}
	balance, err = model.Change(req.UserId, req.Amount)
	if err != nil {
		log.Logf("变更账户信息异常, UserID: %v", req.UserId)
		rsp.Status = "FAILED"
		rsp.Message = err.Error()
		return nil
	}
	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"
	rsp.Balance = balance

	return nil
}
