micro/config/gateway:
{
  "jwt_key": "abcdefghhhizzaaeeaaifffadff",
  "white_url": ["/", "/stock/quot", "/stock/query", "/user/registry", "/user/login"]
}

micro/config/mysql:
{
	"address": "mysql",
	"port": 3306,
	"user_name": "able",
	"user_password": "111111",
	"db_name": "stock_db"
}

micro/config/redis:
{
	"address": "redis:6379",
	"db": 0
}

# Web API
/user/register
/user/login
/user/logout
/user/query

/stock/query
/stock/quot

/order/order
/order/query
/order/queryhold
/order/cancel

