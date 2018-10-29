package main

import (
	"github.com/gin-gonic/gin"
	"github.com/op/go-logging"
	"github.com/urfave/cli"
	"go.uber.org/zap"
	"go.uber.org/zap/zapcore"
	"os"
	"time"
)

var version string
var log *zap.SugaredLogger
var log2 = logging.MustGetLogger("main")
var debug = true

func init() {
	consoleEncoderConfig := zap.NewDevelopmentEncoderConfig()
	consoleEncoderConfig.EncodeLevel = zapcore.CapitalColorLevelEncoder
	consoleEncoder := zapcore.NewConsoleEncoder(consoleEncoderConfig)
	// split off logs to stdout(normal) and stderr (errors)
	consoleStdout := zapcore.Lock(os.Stdout)
	consoleStderr := zapcore.Lock(os.Stderr)
	_ = consoleStdout
	_ = consoleStderr
	highPriority := zap.LevelEnablerFunc(func(lvl zapcore.Level) bool {
		return lvl >= zapcore.ErrorLevel
	})
	lowPriority := zap.LevelEnablerFunc(func(lvl zapcore.Level) bool {
		return lvl < zapcore.ErrorLevel
	})
	core := zapcore.NewTee(
		zapcore.NewCore(consoleEncoder, os.Stdout, lowPriority),
		zapcore.NewCore(consoleEncoder, os.Stderr, highPriority),
	)
	logger := zap.New(core)
	if debug {
		logger = logger.WithOptions(
		//			zap.Development(),
		//			zap.AddCaller(),
		//			zap.AddStacktrace(highPriority),
		)
	} else {
		logger = logger.WithOptions(
			zap.AddCaller(),
		)
	}
	log = logger.Sugar()
	log22, _ := zap.NewProduction()
	log = log22.Sugar()
	//log = zap.NewExample().Sugar()
	//	cfg := zap.NewProductionConfig()
	//cfg.OutputPaths = []string{tmpfile.Name()}
	//	lozzer, _ := cfg.Build()
	//	log = lozzer.Sugar()
}

func main() {
	defer log.Sync()
	log.Errorf("Starting app version: %s", version)
	app := cli.NewApp()
	app.Name = "foobar"
	app.Description = "do foo to bar"
	app.Version = version
	app.HideHelp = true
	app.Flags = []cli.Flag{
		cli.BoolFlag{Name: "help, h", Usage: "show help"},
		cli.StringFlag{
			Name:   "url",
			Value:  "http://127.0.0.1",
			Usage:  "It's an url",
			EnvVar: "_URL",
		},
	}
	app.Action = func(c *cli.Context) error {
		if c.Bool("help") {
			cli.ShowAppHelp(c)
			os.Exit(1)
		}
		log.Infof("Starting app version: %s", version)
		log.Infof("var example %s", c.GlobalString("url"))
		runWeb(c)
		return nil
	}
	app.Commands = []cli.Command{
		{
			Name:    "rem",
			Aliases: []string{"a"},
			Usage:   "example cmd",
			Action: func(c *cli.Context) error {
				log.Warnf("running example cmd")
				return nil
			},
		},
		{
			Name:    "add",
			Aliases: []string{"a"},
			Usage:   "example cmd",
			Action: func(c *cli.Context) error {
				log.Warnf("running example cmd")
				return nil
			},
		},
	}
	// to sort do that
	//sort.Sort(cli.FlagsByName(app.Flags))
	//sort.Sort(cli.CommandsByName(app.Commands))
	app.Run(os.Args)
}

func runWeb(c *cli.Context) {
	r := gin.New()

	r.Use(gin.Logger())
	r.Use(webLogger)

	r.Use(gin.Recovery())

	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})

	r.Run(":3004") // listen and serve on 0.0.0.0:8080
}

func webLogger(c *gin.Context) {

	path := c.Request.URL.Path
	raw := c.Request.URL.RawQuery
	start := time.Now()
	c.Next()
	end := time.Now()
	latency := end.Sub(start)

	if raw != "" {
		path = path + "?" + raw
	}
	logstart := time.Now()
	log.Infow(path,
		"status", c.Writer.Status(), // adds 1us
		"duration", latency, //adds 14-40us
		"method", c.Request.Method, // adds <300ns
		"ip", c.ClientIP(), //adds 1us
		"errors", c.Errors.ByType(gin.ErrorTypePrivate).String(), // adds <1us
	)
	logend := time.Now()

	loglatency := logend.Sub(logstart)
	log2.Warningf("request: %s", latency)
	log2.Warningf("logger: %s", loglatency)

}
