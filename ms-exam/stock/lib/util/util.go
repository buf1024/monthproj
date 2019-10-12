package util

import (
	"github.com/buf1024/monthproj/ms-exam/stock/lib/config"
	"github.com/micro/go-micro/util/log"
	"time"
)

func SaveSid(key, value string) bool {
	redisClient := config.GetRedis()
	exists, err := redisClient.Exists(key).Result()
	if err != nil || exists == 1 {
		log.Logf("重复报文/异常: %v, 是否存在: %v", err, exists)
		return false
	}

	err = redisClient.Set(key, value, time.Second * 30).Err()
	if err != nil {
		log.Logf("设置redis会话异常: %v", err)
		return false
	}
	return true
}

func DelSid(key string)  {
	redisClient := config.GetRedis()
	_ = redisClient.Del(key)
}
