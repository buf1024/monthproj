package model

import (
	"fmt"
	"github.com/buf1024/monthproj/ms-exam/stock/lib/config"
	"github.com/buf1024/monthproj/ms-exam/stock/lib/util"

	order "github.com/buf1024/monthproj/ms-exam/stock/srv/order/proto/order"
)

func QueryOrder(userId, stockId string, orderId int64) (orders []*order.UserOrder, err error) {
	db := config.GetMysql()

	query := "SELECT id, stock_id, order_type, order_number, deal_number, order_price, order_status FROM `order` WHERE user_id = ?"
	if orderId != 0 {
		query = query + fmt.Sprintf(" and id = %d", orderId)
	}
	if len(stockId) > 0 {
		query = query + fmt.Sprintf(" and stock_id = '%s'", stockId)

	}
	rows, err := db.Query(query, userId)
	if err != nil {
		return
	}
	defer rows.Close()

	for rows.Next() {
		o := order.UserOrder{}
		err = rows.Scan(&o.OrderId, &o.StockId, &o.OrderType, &o.OrderNumber, &o.DealNumber, &o.OrderPrice, &o.OrderStatus)
		if err != nil {
			return
		}

		orders = append(orders, &o)
	}
	return
}

func InsertSellOrder(req *order.OrderRequest) (int64, error) {
	db := config.GetMysql()
	tx, err := db.Begin()
	if err != nil {
		return 0, err
	}

	query := "SELECT stock_id, hold_price, stock_number from user_stock WHERE user_id = ? and stock_id = ?"

	h := order.HoldOrder{}
	err = tx.QueryRow(query, req.UserId, req.StockId).Scan(&h.StockId, &h.HoldPrice, &h.HoldNumber)
	if err != nil {
		return 0, err
	}

	if h.HoldNumber < req.OrderNumber {
		return 0, fmt.Errorf("持仓数 %v 少于 订单数 %v", h.HoldNumber, req.OrderNumber)
	}

	update := "UPDATE `user_stock` SET stock_number = ?"
	_, err = tx.Exec(update, h.HoldNumber-req.OrderNumber)
	if err != nil {
		_ = tx.Rollback()
		return 0, err
	}

	insert := "INSERT INTO `order`(stock_id, user_id, order_type, order_number, order_price) VALUES(?, ?, ?, ?, ?)"
	result, err := tx.Exec(insert, req.StockId, req.UserId, req.OrderType, req.OrderNumber, req.OrderPrice)
	if err != nil {
		_ = tx.Rollback()
		return 0, err
	}
	id, err := result.LastInsertId()
	if err != nil {
		_ = tx.Rollback()
		return 0, err
	}
	o := util.OrderQueueItem{
		OrderId: id,
		OrderNumber: req.OrderNumber,
		OrderPrice: req.OrderPrice,
		UserId: req.UserId,
		StockId: req.StockId,
	}
	err = util.InsertOrderQueue("sell", req.StockId, &o)
	if err != nil {
		_ = tx.Rollback()
		return 0, err
	}
	err = tx.Commit()
	if err != nil {
		_ = tx.Rollback()
		return 0, err
	}
	return id, nil
}

func InsertBuyOrder(req *order.OrderRequest) (int64, error) {
	db := config.GetMysql()
	tx, err := db.Begin()
	if err != nil {
		return 0, err
	}
	insert := "INSERT INTO `order`(stock_id, user_id, order_type, order_number, order_price) VALUES (?, ?, ?, ?, ?)"
	result, err := tx.Exec(insert, req.StockId, req.UserId, req.OrderType, req.OrderNumber, req.OrderPrice)
	if err != nil {
		_ = tx.Rollback()
		return 0, err
	}
	id, err := result.LastInsertId()
	if err != nil {
		_ = tx.Rollback()
		return 0, err
	}
	o := util.OrderQueueItem{
		OrderId: id,
		OrderNumber: req.OrderNumber,
		OrderPrice: req.OrderPrice,
		UserId: req.UserId,
		StockId: req.StockId,
	}
	err = util.InsertOrderQueue("buy", req.StockId, &o)
	if err != nil {
		_ = tx.Rollback()
		return 0, err
	}
	err = tx.Commit()
	if err != nil {
		_ = tx.Rollback()
		return 0, err
	}
	return id, nil
}

func QueryHold(userId, stockId string) ([]*order.HoldOrder, error) {
	db := config.GetMysql()

	query := "SELECT stock_id, hold_price, stock_number from user_stock WHERE user_id = ? "
	if len(stockId) > 0 {
		query = query + fmt.Sprintf(" and stock_id = '%s'", stockId)
	}

	rows, err := db.Query(query, userId)
	if err != nil {
		return nil, nil
	}
	defer rows.Close()

	var holdOrder []*order.HoldOrder
	for rows.Next() {
		o := order.HoldOrder{}
		err = rows.Scan(&o.StockId, &o.HoldPrice, &o.HoldNumber)
		if err != nil {
			return nil, err
		}
		holdOrder = append(holdOrder, &o)
	}

	return holdOrder, nil
}

func CancelOrder(userId string, orderId int64) (int, int, int, error) {
	db := config.GetMysql()
	tx, err := db.Begin()
	if err != nil {
		return 0, 0, 0, err
	}
	query := "SELECT order_status, order_number, deal_number from `order` " +
		"where user_id = ? and id = ? and order_status != 3 and order_status != 4 and order_status != 2"
	orderStatus := 0
	orderNumber := 0
	dealNumber := 0

	err = tx.QueryRow(query, userId, orderId).Scan(&orderStatus, &orderNumber, &dealNumber)
	if err != nil {
		_ = tx.Rollback()
		return 0, 0, 0, err
	}
	// 只是测试而已
	if orderStatus == 1 { // 部分成交
		 orderStatus = 3 // 部分撤销
	} else {
		orderStatus = 4 // 撤销
	}
	update := "UPDATE `order` SET order_status = ? WHERE user_id = ? and id = ?"
	_, err = tx.Exec(update, orderStatus, userId, orderId)
	if err != nil {
		_ = tx.Rollback()
		return 0, 0, 0, err
	}
	_ = tx.Commit()

	return dealNumber, orderNumber - dealNumber, orderStatus, nil
}
