package model

import (
	"database/sql"
	"fmt"
	"time"

	"github.com/buf1024/monthproj/ms-exam/stock/lib/config"
	stock "github.com/buf1024/monthproj/ms-exam/stock/srv/stock/proto/stock"

)

func QueryStock(stockId string) (stocks []*stock.Stock, err error) {
	db := config.GetMysql()

	query := fmt.Sprintf("SELECT stock_id, stock_name, open_price, close_price, trade_date from stock WHERE stock_id = '%s' and trade_date >= ?",
		stockId)
	if len(stockId) == 0 {
		query = "SELECT stock_id, stock_name, open_price, close_price, trade_date from stock WHERE trade_date >= ?"

	}
	dt := time.Now()
	dtS := fmt.Sprintf("%04d-%02d-%02d 00:00:00 ", dt.Year(), dt.Month(), dt.Day())
	fmt.Printf("%v", dtS)
	rows, err := db.Query(query, dtS)
	if err != nil {
		return
	}
	defer rows.Close()

	for rows.Next() {
		s := stock.Stock{}
		var t time.Time
		err = rows.Scan(&s.StockId, &s.StockName, &s.OpenPrice, &s.ClosePrice, &t)
		if err != nil {
			return
		}
		s.TradeDate = fmt.Sprintf("%04d-%02d-%02d", t.Year(), t.Month(), t.Day())

		stocks = append(stocks, &s)
	}
	return
}

func InsertQuot(stockId string, price float64) error {
	db := config.GetMysql()
	tx, err := db.Begin()
	if err != nil {
		return err
	}
	insert := "INSERT INTO quotation (stock_id, stock_price) VALUE (?, ?)"
	_, err = tx.Exec(insert, stockId, price)
	if err != nil{
		_ = tx.Rollback()
		return err
	}
	_ = tx.Commit()

	return nil
}

func GetQuot(stockId string, beginTime, endTime int64) ([]*stock.Price, error)  {
	db := config.GetMysql()

	limit := ""
	if beginTime == 0 || endTime == 0 {
		beginTime = time.Date(2000, 1, 1, 0, 0, 0, 0, time.Local).Unix()
		endTime = time.Now().Unix()

		limit = " limit 1"
	}
	query := "SELECT stock_price, created_time from quotation WHERE stock_id = ? and created_time >= ? and created_time < ? ORDER BY created_time DESC "
	query = query + limit

	dtBegin := time.Unix(beginTime, 0)
	dtEnd := time.Unix(endTime, 0)

	dtBeginS := fmt.Sprintf("%04d-%02d-%02d %02d:%02d:%02d ",
		dtBegin.Year(), dtBegin.Month(), dtBegin.Day(), dtBegin.Hour(), dtBegin.Minute(), dtBegin.Second())

	dtEndS := fmt.Sprintf("%04d-%02d-%02d %02d:%02d:%02d ",
		dtEnd.Year(), dtEnd.Month(), dtEnd.Day(), dtEnd.Hour(), dtEnd.Minute(), dtEnd.Second())

	rows, err := db.Query(query, stockId, dtBeginS, dtEndS)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var prices []*stock.Price
	for rows.Next() {
		price := stock.Price{}
		var t time.Time
		err = rows.Scan(&price.Price, &t)
		if err != nil {
			return nil, err
		}
		tSec := t.Unix()
		price.Time = tSec
		prices = append(prices, &price)
	}

	return prices, nil
}

func OpenTrade() error {
	db := config.GetMysql()
	tx, err := db.Begin()
	if err != nil {
		return err
	}

	query := "SELECT stock_id, open_price, close_price from `stock` "
	rows, err := db.Query(query)
	if err != nil {
		return nil
	}
	defer rows.Close()

	var stocks []*stock.Stock
	for rows.Next() {
		s := stock.Stock{}
		err = rows.Scan(&s.StockId, &s.OpenPrice, &s.ClosePrice)
		if err != nil {
			return err
		}
		stocks = append(stocks, &s)
	}
	for _, s := range stocks {
		query := "SELECT stock_price from `quotation` WHERE stock_id = ? ORDER BY created_time DESC LIMIT 1"
		stockPrice := 0
		err = db.QueryRow(query, s.StockId).Scan(&stockPrice)
		if err != nil && err != sql.ErrNoRows {
			return err
		}
		t := time.Now()
		tradeDate := fmt.Sprintf("%04d-%02d-%02d 00:00:00", t.Year(), t.Month(), t.Day())

		upStock := "UPDATE `stock` set open_price = ?, trade_date = ? where stock_id = ?"
		_, err = tx.Exec(upStock, stockPrice, tradeDate, s.StockId)
		if err != nil {
			_ = tx.Rollback()
			return err
		}
	}
	return tx.Commit()
}