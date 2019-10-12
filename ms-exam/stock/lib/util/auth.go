package util

import (
	"fmt"
	"time"

	"github.com/buf1024/monthproj/ms-exam/stock/lib/config"
	"github.com/dgrijalva/jwt-go"
	"github.com/micro/go-micro/util/log"
)

func GetToken(sess string) error {
	redisClient := config.GetRedis()
	key := fmt.Sprintf("auth:token:%v", sess)
	token, err := redisClient.Get(key).Result()
	if err != nil {
		log.Logf("token不存在: %v", err)
		return err
	}
	return decodeToken(token)
}
func DelToken(sess string) error {
	redisClient := config.GetRedis()
	key := fmt.Sprintf("auth:token:%v", sess)
	_, err := redisClient.Del(key).Result()
	return err
}
func SetToken(sess string) error {
	redisClient := config.GetRedis()
	token, err := encodeToken()
	if err != nil {
		log.Logf("生成token异常: %v", err)
		return err
	}
	key := fmt.Sprintf("auth:token:%v", sess)
	_, err = redisClient.Set(key, token, time.Minute*5).Result()
	if err != nil {
		log.Logf("保存token redis异常: %v", err)
		return err
	}
	return nil
}

func decodeToken(token string) error {
	keyFunc := func(*jwt.Token) (interface{}, error) {
		return config.GetJwtKey(), nil
	}
	t, err := jwt.ParseWithClaims(token, &jwt.StandardClaims{}, keyFunc)
	if err != nil {
		return err
	}
	if _, ok := t.Claims.(*jwt.StandardClaims); ok && t.Valid {
		return nil
	}
	return fmt.Errorf("无效token")
}
func encodeToken() (string, error) {
	now := time.Now().Unix()
	sc := jwt.StandardClaims{
		Issuer:    "com.toyent.gatway.auth",
		IssuedAt:  now,
		ExpiresAt: now + int64(time.Minute*5),
	}
	token := jwt.NewWithClaims(jwt.SigningMethodHS256, sc)

	return token.SignedString([]byte(config.GetJwtKey()))
}
