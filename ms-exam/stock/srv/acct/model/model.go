package model

import "github.com/buf1024/monthproj/ms-exam/stock/lib/config"

func Change(userId string, balance float64) (float64, error) {
	db := config.GetMysql()
	tx, err := db.Begin()
	if err != nil {
		return 0, err
	}
	update := "UPDATE account SET balance = balance + ? WHERE user_id = ?"
	if _, err := tx.Exec(update, balance, userId); err != nil {
		_ = tx.Rollback()
		return 0, err
	}
	_ = tx.Commit()


	return QueryAccount(userId)
}
func QueryAccount(userId string) (float64, error) {
	db := config.GetMysql()

	query := "SELECT balance from account WHERE user_id = ?"
	var balance float64
	err := db.QueryRow(query, userId).Scan(&balance)

	return balance, err
}
func InsertAccount(userId string, balance float64) (int64, error) {
	db := config.GetMysql()
	tx, err := db.Begin()
	if err != nil {
		return 0, err
	}
	insert := "INSERT INTO account (user_id, balance) VALUES (?, ?)"
	result, err := tx.Exec(insert, userId, balance)
	if err != nil {
		_ = tx.Rollback()
		return 0, err
	}
	id, err := result.LastInsertId()
	if err != nil {
		_ = tx.Rollback()
		return 0, err
	}
	_ = tx.Commit()

	return id, nil
}

