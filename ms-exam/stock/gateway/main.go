package main

import (
	"github.com/buf1024/monthproj/ms-exam/stock/gateway/auth"
	"github.com/micro/go-micro"
	"github.com/micro/go-plugins/micro/cors"
	"github.com/micro/micro/cmd"
	"github.com/micro/micro/plugin"
)

func main() {
	_ = plugin.Register(cors.NewPlugin())
	_ = plugin.Register(auth.NewPlugin())

	//plugin.Register(cors.N)
	cmd.Init(
		micro.Name("com.toyent.gateway"),
		micro.Version("latest"),
	)
}
