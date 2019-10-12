package main

import (
	"time"

	"github.com/buf1024/monthproj/ms-exam/stock/lib/config"
	"github.com/buf1024/monthproj/ms-exam/stock/srv/order-deal/handler"
	"github.com/micro/cli"
	"github.com/micro/go-micro"
	"github.com/micro/go-micro/util/log"
)

func main() {
	// New Service
	service := micro.NewService(
		micro.Name("com.toyent.srv.orderdeal"),
		micro.RegisterTTL(time.Second * 30),
		micro.RegisterInterval(time.Second * 10),
		micro.Flags(cli.StringFlag{
			Name: "config_address",
			Usage: "Config config center address",
			EnvVar: "CONFIG_ADDRESS",
			Value: "127.0.0.1:8500",
		}),
		micro.Version("latest"),
		micro.Action(func(ctx *cli.Context) {
			config.InitConfig(ctx.String("config_address"))
			handler.Init()
		}),
		micro.AfterStop(func() error {
			config.Stop()
			return nil
		}),
	)

	// Initialise service
	service.Init()

	go handler.HandleOrder()

	// Run service
	if err := service.Run(); err != nil {
		log.Fatal(err)
	}
}
