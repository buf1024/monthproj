package util

import (
	"encoding"
	"fmt"
	"github.com/buf1024/monthproj/ms-exam/stock/lib/config"
	"github.com/go-redis/redis"
	"github.com/google/uuid"
	"github.com/micro/go-micro/config/encoder/json"
	"github.com/micro/go-micro/util/log"
	"time"
)

type OrderQueueItem struct {
	OrderId int64 `json:"order_id"`
	OrderNumber int32 `json:"order_number"`
	OrderPrice float64 `json:"order_price"`
	UserId string `json:"user_id"`
	StockId string `json:"stock_id"`
}
func (o *OrderQueueItem) MarshalBinary() (data []byte, err error) {
	return json.NewEncoder().Encode(o)
}

func (o *OrderQueueItem) UnmarshalBinary(data []byte) error {
	return json.NewEncoder().Decode(data, o)
}

var _ encoding.BinaryMarshaler = &OrderQueueItem{}
var _ encoding.BinaryUnmarshaler = &OrderQueueItem{}

func InsertOrderQueue(t, stockId string, item *OrderQueueItem) error {
	redisClient := config.GetRedis()
	key := fmt.Sprintf("order:queue:%s:%s", t, stockId)

	zR := redis.ZRangeBy{
		Min: fmt.Sprintf("%f", item.OrderPrice),
		Max: fmt.Sprintf("%f", item.OrderPrice),
	}
	list, err := redisClient.ZRangeByScore(key, zR).Result()
	if err != nil {
		log.Logf("查询队列异常: %v 到队列异常: %v", key, err)
		return err
	}
	var listKey string
	if len(list) > 0 {
		listKey = list[0]
	} else {
		listKey = uuid.New().String()

		m := redis.Z{Score: item.OrderPrice, Member: listKey}
		_, err = redisClient.ZAdd(key, m).Result()
		if err != nil {
			log.Logf("增加键: %v 到队列异常: %v", key, err)
			return err
		}

		expireKey(key)

	}
	_, err = redisClient.LPush(listKey, item).Result()
	if err != nil {
		log.Logf("增加键: %v 到队列异常: %v", list[0], err)
		return err
	}
	expireKey(listKey)

	return nil
}

func expireKey(key string)  {
	redisClient := config.GetRedis()

	t := time.Now()
	t = t.Add(time.Hour * 24)
	tNight := time.Date(t.Year(), t.Month(), t.Day(), 0, 0, 0, 0, t.Location())
	redisClient.ExpireAt(key, tNight)
}

func GetOrderQueue(t, stockId string) (*OrderQueueItem, string, error) {
	redisClient := config.GetRedis()
	key := fmt.Sprintf("order:queue:%s:%s", t, stockId)

	var start, end int64
	if "sel" == t {
		// 最小价格
		start = 0
		end = 0
	} else {
		start = -1
		end = -1
	}
	list, err := redisClient.ZRange(key, start, end).Result()
	if err != nil {
		return nil, "", err
	}
	if len(list) == 0 {
		return nil, "", nil
	}

	listKey := list[0]

	var items []*OrderQueueItem
	if err := redisClient.LRange(listKey, 0, 0).ScanSlice(&items); err != nil {
		return nil, "", err
	}
	if len(items) == 0 {
		return nil, "", nil
	}
	return items[0], listKey, nil
}

func DelOrder(key string) error {
	redisClient := config.GetRedis()

	if _, err := redisClient.LPop(key).Result(); err != nil {
		return err
	}
	return nil
}

func DealOrderQuery(keySell, keyBuy string, dealNumber int32) error  {
	redisClient := config.GetRedis()

	sellOrder := &OrderQueueItem{}
	if err := redisClient.LPop(keySell).Scan(sellOrder); err != nil {
		return err
	}
	sellOrder.OrderNumber -= dealNumber
	if sellOrder.OrderNumber > 0 {
		_, err := redisClient.LPush(keySell, sellOrder).Result()
		if err != nil {
			return err
		}
		expireKey(keySell)
	} else {
		l, err := redisClient.LLen(keySell).Result()
		if  err != nil{
			return err
		}
		if l <= 0 {
			key := fmt.Sprintf("order:queue:sell:%s", sellOrder.StockId)
			redisClient.ZRemRangeByScore(key, fmt.Sprintf("%f", sellOrder.OrderPrice), fmt.Sprintf("%f", sellOrder.OrderPrice))
		}
	}

	buyOrder := &OrderQueueItem{}
	if err := redisClient.LPop(keyBuy).Scan(buyOrder); err != nil {
		return err
	}

	buyOrder.OrderNumber -= dealNumber
	if buyOrder.OrderNumber > 0 {
		_, err := redisClient.LPush(keyBuy, buyOrder).Result()
		if err != nil {
			return err
		}
		expireKey(keyBuy)
	} else {
		l, err := redisClient.LLen(keyBuy).Result()
		if  err != nil{
			return err
		}
		if l <= 0 {
			key := fmt.Sprintf("order:queue:buy:%s", sellOrder.StockId)
			redisClient.ZRemRangeByScore(key, fmt.Sprintf("%f", sellOrder.OrderPrice), fmt.Sprintf("%f", sellOrder.OrderPrice))
		}
	}


	return nil
}