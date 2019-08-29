package model

import "github.com/buf1024/monthproj/ms-exam/stock/lib/config"

func QueryUser(userId string) (userName string, pwd string, err error) {
	db := config.GetMysql()

	query := "SELECT user_name, pwd from user WHERE user_id = ?"
	err = db.QueryRow(query, userId).Scan(&userName, &pwd)

	return
}
func InsertUser(userId, userName, pwd string) error {
	db := config.GetMysql()
	tx, err := db.Begin()
	if err != nil {
		return err
	}
	insert := "INSERT INTO user (user_id, user_name, pwd) VALUES (?, ?, ?)"
	if _, err := tx.Exec(insert, userId, userName, pwd); err != nil {
		_ = tx.Rollback()
		return err
	}
	_ = tx.Commit()

	return nil
}


