package main

import (
	"github.com/buf1024/monthproj/ms-exam/stock/web/stock/handler"
	"github.com/micro/cli"
	"github.com/micro/go-micro/util/log"
	"github.com/micro/go-micro/web"

	"time"
)

func main() {
	// create new web service
	service := web.NewService(
		web.Name("com.toyent.web.stock"),
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
			handler.Init()
		}),
	)

	// initialise service
	if err := service.Init(); err != nil {
		log.Fatal(err)
	}

	// register call handler
	service.HandleFunc("/stock/query", handler.StockQuery)
	service.HandleFunc("/stock/quot", handler.StockQuot)

	// run service
	if err := service.Run(); err != nil {
		log.Fatal(err)
	}
}
