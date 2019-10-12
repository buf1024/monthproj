package main

import (
	"github.com/buf1024/monthproj/ms-exam/stock/lib/config"
	"github.com/buf1024/monthproj/ms-exam/stock/srv/stock/handler"
	"github.com/micro/cli"
	"github.com/micro/go-micro"
	"github.com/micro/go-micro/util/log"
	"time"

	stock "github.com/buf1024/monthproj/ms-exam/stock/srv/stock/proto/stock"
)

func main() {
	// New Service
	service := micro.NewService(
		micro.Name("com.toyent.srv.stock"),
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
			log.Log("micro.Action")
			config.InitConfig(ctx.String("config_address"))
		}),
		micro.AfterStop(func() error {
			config.Stop()
			return nil
		}),
	)

	// Initialise service
	service.Init()

	// Register Handler
	_ = stock.RegisterStockHandler(service.Server(), new(handler.Stock))

	// Run service
	if err := service.Run(); err != nil {
		log.Fatal(err)
	}
}
