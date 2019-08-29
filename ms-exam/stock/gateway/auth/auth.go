package auth

import (
	"github.com/buf1024/monthproj/ms-exam/stock/lib/config"
	"github.com/buf1024/monthproj/ms-exam/stock/lib/util"

	"github.com/micro/cli"
	"github.com/micro/go-micro/util/log"
	"github.com/micro/micro/plugin"

	"net/http"
	"strings"
)

type auth struct {
}

func (a *auth) Flags() []cli.Flag {
	return []cli.Flag{
		cli.StringFlag{
			Name:   "config_address",
			Usage:  "Config config center address",
			EnvVar: "CONFIG_ADDRESS",
			Value:  "127.0.0.1:8500",
		},
	}
}

func (a *auth) Commands() []cli.Command {
	return nil
}

func (a *auth) Handler() plugin.Handler {
	whiteUrl := config.GetWhiteUrl()
	log.Logf("url 白名单: %v", whiteUrl)
	return func(h http.Handler) http.Handler {
		return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
			url := strings.ToLower(r.URL.Path)
			if len(url) > 1 && url[len(url)-1] == '/' {
				url = url[:len(url)-1]
			}

			for _, s := range whiteUrl {
				if s == url {
					h.ServeHTTP(w, r)
					return
				}
			}

			session := r.Header.Get("Authorization")
			err := util.GetToken(session)
			if err != nil {
				log.Logf("获取token异常: %v", err)
				w.WriteHeader(http.StatusUnauthorized)
				return
			}

			h.ServeHTTP(w, r)

			_ = util.SetToken(session)
		})
	}
}

func (a *auth) Init(ctx *cli.Context) error {
	config.InitGatewayConfig(ctx.String("config_address"))
	return nil
}

func (a *auth) String() string {
	return "com.toyent.gateway.auth"
}

func NewPlugin() plugin.Plugin {
	return &auth{}
}
