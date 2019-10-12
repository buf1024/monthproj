package handler

import (
	"context"
	"encoding/json"
	"github.com/buf1024/monthproj/ms-exam/stock/lib/util"
	"github.com/google/uuid"
	"net/http"

	"github.com/micro/go-micro/client"
	"github.com/micro/go-micro/util/log"

	acct "github.com/buf1024/monthproj/ms-exam/stock/srv/acct/proto/acct"
	user "github.com/buf1024/monthproj/ms-exam/stock/srv/user/proto/user"
	userWeb "github.com/buf1024/monthproj/ms-exam/stock/web/user/proto/user"
)

var (
	userService user.UserService
	acctService acct.AcctService
)

func Init() {
	log.Info("初始化客户端")
	userService = user.NewUserService("com.toyent.srv.user", client.DefaultClient)
	acctService = acct.NewAcctService("com.toyent.srv.acct", client.DefaultClient)
}

func UserRegistry(w http.ResponseWriter, r *http.Request) {
	regReq := userWeb.RegRequest{}
	if err := json.NewDecoder(r.Body).Decode(&regReq); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("注册请求: %v", regReq.String())

	regRsp := userWeb.RegResponse{
		Sid: regReq.Sid,
	}

	defer func() {
		log.Logf("注册应答: %v", regRsp.String())
	}()

	userReq := &user.OpenRequest{
		Sid:      regReq.Sid,
		UserId:   regReq.UserId,
		UserName: regReq.UserName,
		Password: regReq.Password,
	}
	log.Logf("调用用户服务开户请求: %v", userReq)
	userRsp, err := userService.Open(context.Background(), userReq)
	if err != nil {
		log.Logf("调用用户服务开户异常: %v", err)
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("调用用户服务开户应答: %v", userRsp)
	if userRsp.Status == "FAILED" {
		regRsp.Status = userRsp.Status
		regRsp.Message = userRsp.Message
		w.WriteHeader(http.StatusOK)
		if err := json.NewEncoder(w).Encode(regRsp); err != nil {
			http.Error(w, err.Error(), 500)
		}
		return
	}

	// 分布式事务，先不管
	acctReq := &acct.OpenRequest{
		Sid:    regReq.Sid,
		UserId: regReq.UserId,
	}
	log.Logf("调用账户服务开户请求: %v", userReq)
	acctRsp, err := acctService.Open(context.Background(), acctReq)
	if err != nil {
		log.Logf("调用账户服务开户异常: %v", err)
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("调用账户服务开户应答: %v", acctRsp)
	if acctRsp.Status == "FAILED" {
		regRsp.Status = acctRsp.Status
		regRsp.Message = acctRsp.Message
		w.WriteHeader(http.StatusOK)
		if err := json.NewEncoder(w).Encode(regRsp); err != nil {
			http.Error(w, err.Error(), 500)
		}
		return
	}

	regRsp.Status = "SUCCESS"
	regRsp.Message = "SUCCESS"
	regRsp.Balance = acctRsp.Balance

	if err := json.NewEncoder(w).Encode(regRsp); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
}

func UserQuery(w http.ResponseWriter, r *http.Request) {
	queryReq := userWeb.QueryRequest{}
	if err := json.NewDecoder(r.Body).Decode(&queryReq); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("查询请求: %v", queryReq.String())

	queryRsp := userWeb.QueryResponse{
		Sid: queryReq.Sid,
	}

	defer func() {
		log.Logf("查询应答: %v", queryRsp.String())
	}()

	userReq := &user.QueryRequest{
		Sid:    queryReq.Sid,
		UserId: queryReq.UserId,
	}
	log.Logf("调用用户服务查询请求: %v", userReq)
	userRsp, err := userService.Query(context.Background(), userReq)
	if err != nil {
		log.Logf("调用用户服务查询异常: %v", err)
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("调用用户服务查询应答: %v", userRsp)
	if userRsp.Status == "FAILED" {
		queryRsp.Status = userRsp.Status
		queryRsp.Message = userRsp.Message
		w.WriteHeader(http.StatusOK)
		if err := json.NewEncoder(w).Encode(queryRsp); err != nil {
			http.Error(w, err.Error(), 500)
		}
		return
	}

	acctReq := &acct.QueryRequest{
		Sid:    queryReq.Sid,
		UserId: queryReq.UserId,
	}
	log.Logf("调用账户服务查询请求: %v", userReq)
	acctRsp, err := acctService.Query(context.Background(), acctReq)
	if err != nil {
		log.Logf("调用账户服务开户异常: %v", err)
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("调用账户服务开户应答: %v", acctRsp)
	if acctRsp.Status == "FAILED" {
		queryRsp.Status = acctRsp.Status
		queryRsp.Message = acctRsp.Message
		w.WriteHeader(http.StatusOK)
		if err := json.NewEncoder(w).Encode(queryRsp); err != nil {
			http.Error(w, err.Error(), 500)
		}
		return
	}

	queryRsp.Status = "SUCCESS"
	queryRsp.Message = "SUCCESS"
	queryRsp.UserId = queryReq.UserId
	queryRsp.UserName = userRsp.UserName
	queryRsp.Balance = acctRsp.Balance

	if err := json.NewEncoder(w).Encode(queryRsp); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
}
func UserLogin(w http.ResponseWriter, r *http.Request) {
	loginReq := userWeb.LoginRequest{}
	if err := json.NewDecoder(r.Body).Decode(&loginReq); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("登录请求: %v", loginReq.String())

	loginRsp := userWeb.QueryResponse{
		Sid: loginReq.Sid,
	}

	defer func() {
		log.Logf("查询应答: %v", loginRsp.String())
	}()

	userReq := &user.AuthRequest{
		Sid:    loginReq.Sid,
		UserId: loginReq.UserId,
		Password: loginReq.Password,
	}
	log.Logf("调用用户服务查询请求: %v", userReq)
	userRsp, err := userService.Auth(context.Background(), userReq)
	if err != nil {
		log.Logf("调用用户服务查询异常: %v", err)
		http.Error(w, err.Error(), 500)
		return
	}
	log.Logf("调用用户服务查询应答: %v", userRsp)
	if userRsp.Status == "FAILED" {
		loginRsp.Status = userRsp.Status
		loginRsp.Message = userRsp.Message
		w.WriteHeader(http.StatusOK)
		if err := json.NewEncoder(w).Encode(loginRsp); err != nil {
			http.Error(w, err.Error(), 500)
		}
		return
	}

	loginRsp.Status = "SUCCESS"
	loginRsp.Message = "SUCCESS"

	sKey := uuid.New().String()
	w.Header().Set("Authorization", sKey)
	_ = util.SetToken(sKey)

	if err := json.NewEncoder(w).Encode(loginRsp); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

}

func UserLogout(w http.ResponseWriter, r *http.Request) {
	var req map[string]interface{}
	if err := json.NewEncoder(w).Encode(&req); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

	sKey := r.Header.Get("Authorization")

	_ = util.DelToken(sKey)

	rsp := map[string]interface{}{
		"sid": req["sid"],
		"status": "SUCCESS",
		"message": "SUCCESS",
	}

	if err := json.NewEncoder(w).Encode(&rsp); err != nil {
		http.Error(w, err.Error(), 500)
		return
	}

}
