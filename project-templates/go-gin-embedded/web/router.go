package web

import (
	"fmt"
	"github.com/efigence/go-mon"
	ginzap "github.com/gin-contrib/zap"
	"github.com/gin-gonic/gin"
	"go.uber.org/zap"
	"html/template"
	"io/fs"
	"net/http"
	"strings"
	"time"
)

type WebBackend struct {
	l   *zap.SugaredLogger
	al  *zap.SugaredLogger
	r   *gin.Engine
	cfg *Config
}

type Config struct {
	Logger       *zap.SugaredLogger `yaml:"-"`
	AccessLogger *zap.SugaredLogger `yaml:"-"`
	ListenAddr   string             `yaml:"listen_addr"`
}

func New(cfg Config, webFS fs.FS) (backend *WebBackend, err error) {
	if cfg.Logger == nil {
		panic("missing logger")
	}
	if len(cfg.ListenAddr) == 0 {
		panic("missing listen addr")
	}
	w := WebBackend{
		l:   cfg.Logger,
		al:  cfg.AccessLogger,
		cfg: &cfg,
	}
	if cfg.AccessLogger == nil {
		w.al = w.l //.Named("accesslog")
	}
	r := gin.New()
	w.r = r
	gin.SetMode(gin.ReleaseMode)
	t, err := template.ParseFS(webFS, "templates/*.tmpl")
	if err != nil {
		return nil, fmt.Errorf("error loading templates: %s", err)
	}
	r.SetHTMLTemplate(t)
	// for zap logging
	r.Use(ginzap.Ginzap(w.al.Desugar(), time.RFC3339, false))
	//r.Use(ginzap.RecoveryWithZap(w.al.Desugar(), true))
	// basic logging to stdout
	//r.Use(gin.LoggerWithWriter(os.Stdout))
	r.Use(gin.Recovery())

	// monitoring endpoints
	r.GET("/_status/health", gin.WrapF(mon.HandleHealthcheck))
	r.HEAD("/_status/health", gin.WrapF(mon.HandleHealthcheck))
	r.GET("/_status/metrics", gin.WrapF(mon.HandleMetrics))
	// healthcheckHandler, haproxyStatus := mon.HandleHealthchecksHaproxy()
	// r.GET("/_status/metrics", gin.WrapF(healthcheckHandler))

	httpFS := http.FileServer(http.FS(webFS))
	r.GET("/s/*filepath", func(c *gin.Context) {
		// content is embedded under static/ dir
		p := strings.Replace(c.Request.URL.Path, "/s/", "/static/", -1)
		c.Request.URL.Path = p
		//c.Header("Cache-Control", "public, max-age=3600, immutable")
		httpFS.ServeHTTP(c.Writer, c.Request)
	})
	r.GET("/", func(c *gin.Context) {
		c.HTML(http.StatusOK, "index.tmpl", gin.H{
			"title": c.Request.RemoteAddr,
		})
	})
	r.NoRoute(func(c *gin.Context) {
		c.HTML(http.StatusNotFound, "404.tmpl", gin.H{
			"notfound": c.Request.URL.Path,
		})
	})

	return &w, nil
}

func (b *WebBackend) Run() error {
	b.l.Infof("listening on %s", b.cfg.ListenAddr)
	return b.r.Run(b.cfg.ListenAddr)
}
