package model

import (
	"context"
	"database/sql"
	"github.com/buf1024/monthproj/ms-exam/stock/lib/config"
	"github.com/buf1024/monthproj/ms-exam/stock/lib/util"
	"github.com/google/uuid"
	"github.com/micro/go-micro/util/log"

	acct "github.com/buf1024/monthproj/ms-exam/stock/srv/acct/proto/acct"
)

const (
	StatusInit = iota
	StatusPartDeal
	StatusDeal
	StatusPartCancel
	StatusCancel
)

func DelExpireOrder(t string) error {
	db := config.GetMysql()
	tx, err := db.Begin()
	if err != nil {
		return err
	}
	disOrder := "UPDATE `order` set order_status = 4 where UPDATED_TIME < ?"
	_, err = tx.Exec(disOrder, t)
	if err != nil {
		_ = tx.Rollback()
		return err
	}
	return tx.Commit()
}

func CheckOrder(order *util.OrderQueueItem) (bool, error) {
	db := config.GetMysql()
	query := "SELECT status from `order` WHERE id = ?"
	status := StatusInit
	err := db.QueryRow(query, order.OrderId).Scan(&status)
	if err != nil && err != sql.ErrNoRows {
		return false, err
	}
	if status == StatusCancel || status == StatusPartCancel {
		return false, nil
	}
	return true, nil
}

func DealOrder(acctService acct.AcctService, sellOrder, buyOrder *util.OrderQueueItem) (int32, error) {
	dealNumber := buyOrder.OrderNumber
	if dealNumber > sellOrder.OrderNumber {
		dealNumber = sellOrder.OrderNumber
	}
	db := config.GetMysql()
	tx, err := db.Begin()
	if err != nil {
		return 0, err
	}
	price := buyOrder.OrderPrice * (float64(dealNumber))

	acctReq := &acct.ChangeRequest{
		Sid: uuid.New().String(),
		UserId: sellOrder.UserId,
		Amount: price,
	}
	log.Logf("卖单成交变更余额请求: %v", acctReq)
	acctRsp, err := acctService.Change(context.Background(), acctReq)
	if err != nil || acctRsp == nil {
		log.Logf("卖单成交变更余额异常: %v", err)
		return 0, err
	}
	log.Logf("卖单成交变更余额应答: %v", acctRsp)
	if acctRsp.Status != "SUCCESS" {
		log.Logf("卖单成交变更余额失败: %v", acctRsp.Message)
		return 0, err
	}
	acctReq.Amount = -acctReq.Amount
	acctReq.Sid = uuid.New().String()

	status := StatusDeal // 全部成交
	if buyOrder.OrderNumber != dealNumber {
		status = StatusPartDeal
	}
	err = updateOrder(tx, "buy", buyOrder, dealNumber, int32(status))
	if err != nil {
		log.Logf("更新买单信息异常, orderId=%v, err=%v ", buyOrder.OrderId, err)
		rollBackAcct(acctService, acctReq)
		_ = tx.Rollback()
		return 0, err
	}
	status = StatusDeal // 全部成交
	if sellOrder.OrderNumber != dealNumber {
		status = StatusPartDeal
	}
	err = updateOrder(tx, "sell", sellOrder, dealNumber, int32(status))
	if err != nil {
		log.Logf("更新卖单信息异常, orderId=%v, err=%v  ", sellOrder.OrderId, err)
		rollBackAcct(acctService, acctReq)
		_ = tx.Rollback()
		return 0, err
	}
	err = tx.Commit()
	if err != nil {
		log.Logf("提交数据库异常, orderId=%v ", err)
		rollBackAcct(acctService, acctReq)
		_ = tx.Rollback()

		return 0, err
	}

	return dealNumber, nil
}

func rollBackAcct(acctService acct.AcctService, req *acct.ChangeRequest)  {
	for i:=0; i<3; i++ {
		log.Logf("卖单成交变更冲正余额请求: %v", req)
		chgRsp, err := acctService.Change(context.Background(), req)
		if err != nil {
			log.Logf("卖单成交变更冲正余额异常: %v", err)
			continue
		}
		log.Logf("卖单成交变更冲正余额应答: %v", chgRsp)
		break
	}
}

func updateOrder(tx* sql.Tx, typ string, order *util.OrderQueueItem, dealNumber, status int32) error  {
	upOrder := "UPDATE `order` SET deal_number = ?, order_status = ? WHERE id = ? "
	_, err := tx.Exec(upOrder, dealNumber, status, order.OrderId)
	if err != nil {
		return err
	}

	query := "SELECT hold_price, stock_number FROM user_stock WHERE user_id = ? and stock_id = ?"
	holdPrice := 0.0
	stockNumber := int32(0)
	err = tx.QueryRow(query, order.UserId, order.StockId).Scan(&holdPrice, &stockNumber)
	if err != nil && err != sql.ErrNoRows {
		return err
	}

	if typ == "buy" {
		if stockNumber == 0 {
			upOrder = "INSERT INTO `user_stock` (user_id, stock_id, hold_price, stock_number) VALUE (?, ?, ?, ?)"
			_, err = tx.Exec(upOrder, order.UserId, order.StockId, order.OrderPrice, dealNumber)
			if err != nil {
				return err
			}
		} else {
			stockNumber = order.OrderNumber + stockNumber
			holdPrice = (order.OrderPrice * float64(order.OrderNumber) + holdPrice * float64(stockNumber))/float64(stockNumber)

			upHold := "UPDATE `user_stock` SET hold_price = ?, stock_number = ? WHERE user_id = ? and stock_id = ?"
			_, err = tx.Exec(upHold, holdPrice, stockNumber, order.UserId, order.StockId)
			if err != nil {
				return err
			}
		}
	} else {
		if stockNumber == dealNumber {
			// 只是演示
			delHold := "DELETE FROM `user_stock` WHERE user_id = ? and stock_id = ?"
			_, err = tx.Exec(delHold, order.UserId, order.StockId)
			if err != nil {
				return err
			}
		} else {
			stockNumber = stockNumber - dealNumber

			upHold := "UPDATE `user_stock` SET hold_price = ?, stock_number = ? WHERE user_id = ? and stock_id = ?"
			_, err = tx.Exec(upHold, holdPrice, stockNumber, order.UserId, order.StockId)
			if err != nil {
				return err
			}
		}
	}
	return nil
}
