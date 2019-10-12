package config

import (
	"github.com/micro/go-micro/config"
	"github.com/micro/go-micro/config/source/consul"
	"github.com/micro/go-micro/util/log"
	"time"

	"os"
)

//{
//	"address": "127.0.0.1:6379",
//	"db": 0
//}
type redisConfig struct {
	Address string `json:"address"`
	Db      int    `json:"db"`
}

//{
//	"address": "127.0.0.1",
//	"port": 3306,
//	"user_name": "able",
//	"user_password": "111111",
//	"db_name": "stock_db"
//}
type mysqlConfig struct {
	Address      string `json:"address"`
	Port         int    `json:"port"`
	UserName     string `json:"user_name"`
	UserPassword string `json:"user_password"`
	DbName       string `json:"db_name"`
}

//{
//"jwt-key": "abcdefghhhizzaaeeaaifffadff"
//}

type gatewayConfig struct {
	JwtKey   string   `json:"jwt_key"`
	WhiteUrl []string `json:"white_url"`
}

var (
	redisConf = redisConfig{}
	mysqlConf = mysqlConfig{}
	gatewayConf   = gatewayConfig{}

	confCenter config.Config
)

func InitGatewayConfig(address string) {
	log.Log("配置初始化")

	source := consul.NewSource(
		consul.WithAddress(address))

	confCenter = config.NewConfig(config.WithSource(source))

	initRedisConf()

	initGatewayConf()
}

func InitWebConfig(address string) {
	log.Log("配置初始化")

	source := consul.NewSource(
		consul.WithAddress(address))

	confCenter = config.NewConfig(config.WithSource(source))

	initRedisConf()
}

func InitConfig(address string) {

	log.Logf("配置初始化: %v", address)

	source := consul.NewSource(
		consul.WithAddress(address))

	confCenter = config.NewConfig(config.WithSource(source))

	initRedisConf()

	initMysqlConf()
}

func initRedisConf() {
	if err := confCenter.Get("micro", "config", "redis").Scan(&redisConf); err != nil {
		log.Logf("读redis配置 micro/config/redis 错误!")
		os.Exit(-1)
	}
	if err := initRedis(redisConf); err != nil {
		log.Logf("连接redis异常: %v!", err)
		os.Exit(-1)
	}
	go watchConfig(&redisConf, func() {
		if err := initRedis(redisConf); err != nil {
			log.Logf("重新连接redis异常: %v!", err)
		}
	}, "micro", "config", "redis")
}

func initMysqlConf() {
	if err := confCenter.Get("micro", "config", "mysql").Scan(&mysqlConf); err != nil {
		log.Logf("读 micro/config/mysql 错误!")
		os.Exit(-1)
	}
	if err := initMysql(mysqlConf); err != nil {
		log.Logf("连接mysql异常: %v!", err)
		os.Exit(-1)
	}

	go watchConfig(&mysqlConf, func() {
		if err := initMysql(mysqlConf); err != nil {
			log.Logf("连接mysql异常: %v!", err)
		}
	}, "micro", "config", "mysql")
}

func initGatewayConf() {
	if err := confCenter.Get("micro", "config", "gateway").Scan(&gatewayConf); err != nil {
		log.Logf("读配置 micro/config/gateway 错误!")
		os.Exit(-1)
	}

	go watchConfig(&gatewayConf, func() {
	}, "micro", "config", "gateway")
}

func watchConfig(v interface{}, f func(), path ...string) {
	log.Logf("开始监控配置变动: %v", path)
	for {
		watch, err := confCenter.Watch(path...)
		if err != nil {
			log.Logf("监听配置: %v 异常: %v", path, err)
			time.Sleep(time.Second * 5)
			continue
		}
		value, err := watch.Next()
		if err != nil {
			log.Logf("监听变动: %v 异常: %v", path, err)
			time.Sleep(time.Second * 5)
			continue
		}
		err = value.Scan(v)
		if err != nil {
			log.Logf("监听读配置: %v 异常: %v", path, err)
			time.Sleep(time.Second * 5)
			continue
		}
		f()
	}
}

func Stop() {
	disconnectMysql()
	disconnectRedis()
}

func GetJwtKey() string {
	return gatewayConf.JwtKey
}
func GetWhiteUrl() [] string {
	return gatewayConf.WhiteUrl
}