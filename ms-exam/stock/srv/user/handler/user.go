package handler

import (
	"context"
	"fmt"
	"github.com/buf1024/monthproj/ms-exam/stock/lib/util"
	"github.com/buf1024/monthproj/ms-exam/stock/srv/user/model"
	user "github.com/buf1024/monthproj/ms-exam/stock/srv/user/proto/user"
	"github.com/micro/go-micro/util/log"
)

type User struct{}

func (e *User) Open(ctx context.Context, req *user.OpenRequest, rsp *user.OpenResponse) error {
	log.Logf("User.Open 请求: %v", req)
	if !util.SaveSid("user:open:sid:" + req.Sid, req.UserId) {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("user:open:sid:" + req.Sid)
		log.Logf("User.Open 应答: %v", rsp)
	}()

	rsp.Sid = req.Sid
	_, _, err := model.QueryUser(req.UserId)
	if err == nil {
		log.Logf("用户ID: %v 已经存在", req.UserId)
		rsp.Status = "FAILED"
		rsp.Message = fmt.Sprintf("用户ID: %v已经存在", req.UserId)
		return nil
	}
	err = model.InsertUser(req.UserId, req.UserName, req.Password)
	if err != nil {
		log.Log("插入用户表异常", req.UserId)
		rsp.Status = "FAILED"
		rsp.Message = fmt.Sprintf("用户ID: %v已经存在", req.UserId)
		return nil
	}
	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"

	return nil
}

func (e *User) Query(ctx context.Context, req *user.QueryRequest, rsp *user.QueryResponse) error {
	log.Logf("User.Query 请求: %v", req)
	if !util.SaveSid("user:query:sid:" + req.Sid, req.UserId) {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("user:query:sid:" + req.Sid)
		log.Logf("User.Query 应答: %v", rsp)
	}()

	rsp.Sid = req.Sid
	userName, _, err := model.QueryUser(req.UserId)
	if err != nil {
		log.Logf("用户ID: %v 已经不存在", req.UserId)
		rsp.Status = "FAILED"
		rsp.Message = fmt.Sprintf("用户ID: %v已经存在", req.UserId)
		return nil
	}
	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"

	rsp.UserId = req.UserId
	rsp.UserName = userName

	return nil
}

func (e *User) Auth(ctx context.Context, req *user.AuthRequest, rsp *user.AuthResponse) error {
	log.Logf("User.Auth 请求: %v", req)
	if !util.SaveSid("user:auth:sid:" + req.Sid, req.UserId) {
		log.Log("无效或重复报文")
		return fmt.Errorf("无效或重复报文, sid=%v", req.Sid)
	}
	defer func() {
		util.DelSid("user:auth:sid:" + req.Sid)
		log.Logf("User.Auth 应答: %v", rsp)
	}()

	rsp.Sid = req.Sid
	_, password, err := model.QueryUser(req.UserId)
	if err != nil {
		log.Logf("用户ID: %v 已经不存在", req.UserId)
		rsp.Status = "FAILED"
		rsp.Message = fmt.Sprintf("用户ID: %v已经存在", req.UserId)
		return nil
	}
	if req.Password != password {
		rsp.Status = "FAILED"
		rsp.Message = "密码不一致"
		return nil
	}
	rsp.Status = "SUCCESS"
	rsp.Message = "SUCCESS"

	return nil
}
