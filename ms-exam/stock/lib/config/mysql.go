package config

import (
	"database/sql"
	"fmt"
	"sync"

	"github.com/micro/go-micro/util/log"
)

var (
	db *sql.DB
	mysqlLock sync.RWMutex
)

func initMysql(mysqlConf mysqlConfig) error {
	mysqlLock.Lock()
	defer mysqlLock.Unlock()

	if db != nil {
		log.Log("断开mysql，重新初始化")
		disconnectMysql()
	}

	log.Logf("初始化mysql: %v", mysqlConf)
	url := fmt.Sprintf(`%s:%s@(%s:%d)/%s?charset=utf8&parseTime=true`,
		mysqlConf.UserName, mysqlConf.UserPassword, mysqlConf.Address, mysqlConf.Port, mysqlConf.DbName)
	//url = url + "&loc=Asia%2FShanghai"
	var err error
	db, err = sql.Open("mysql", url)
	if err != nil {
		return err
	}
	if err := db.Ping(); err != nil {
		return err
	}

	return nil
}

func GetMysql() *sql.DB  {
	return db
}

func disconnectMysql()  {
	if db != nil {
		log.Log("断开mysql连接")
		_ = db.Close()
	}
}