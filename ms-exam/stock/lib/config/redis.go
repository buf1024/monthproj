package config

import (
	"github.com/go-redis/redis"
	"github.com/micro/go-micro/util/log"
	"sync"
)

var (
	client  *redis.Client
	redisLock sync.RWMutex
)

func initRedis(redisConf redisConfig) error {
	redisLock.Lock()
	defer redisLock.Unlock()

	if client != nil {
		log.Log("断开redis，重新初始化")
		disconnectRedis()
	}

	log.Logf("初始化redis: %v", redisConf)
	client = redis.NewClient(&redis.Options{
		Addr:     redisConf.Address,
		DB:       redisConf.Db,
	})

	pong, err := client.Ping().Result()
	if err != nil {
		log.Fatal(err.Error())
		return err
	}
	log.Logf("检查连接: %v", pong)

	return nil


}

func disconnectRedis()  {
	if client != nil{
		log.Log("断开redis连接")
		_ = client.Close()
	}
}

func GetRedis() *redis.Client{
	return client
}


