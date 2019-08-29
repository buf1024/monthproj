package main

import (
	"github.com/buf1024/monthproj/ms-exam/stock/lib/config"
	"github.com/micro/cli"
	"github.com/micro/go-micro/util/log"
	"time"

	"github.com/buf1024/monthproj/ms-exam/stock/web/user/handler"
	"github.com/micro/go-micro/web"
)

func main() {
	// create new web service
	service := web.NewService(
		web.Name("com.toyent.web.user"),
		web.Version("latest"),
		web.RegisterTTL(time.Second*30),
		web.RegisterInterval(time.Second*10),
		web.Flags(cli.StringFlag{
			Name:   "config_address",
			Usage:  "Config config center address",
			EnvVar: "CONFIG_ADDRESS",
			Value:  "127.0.0.1:8500",
		}),
		web.Version("latest"),
		web.Action(func(ctx *cli.Context) {
			config.InitWebConfig(ctx.String("config_address"))
			handler.Init()
		}),
	)

	// initialise service
	if err := service.Init(); err != nil {
		log.Fatal(err)
	}

	// register call handler
	service.HandleFunc("/user/register", handler.UserRegistry)
	service.HandleFunc("/user/login", handler.UserLogin)
	service.HandleFunc("/user/logout", handler.UserLogout)
	service.HandleFunc("/user/query", handler.UserQuery)

	// run service
	if err := service.Run(); err != nil {
		log.Fatal(err)
	}
}
