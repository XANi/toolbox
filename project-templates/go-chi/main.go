package main

import (
	"./web" // fixme to absolute path after import
	"github.com/go-chi/chi"
	"github.com/go-chi/chi/middleware"
	"github.com/op/go-logging"
	"net/http"
	"os"
	"strings"
	"time"
)

var version string
var log = logging.MustGetLogger("main")
var stdout_log_format = logging.MustStringFormatter("%{color:bold}%{time:2006-01-02T15:04:05.0000Z-07:00}%{color:reset}%{color} [%{level:.1s}] %{color:reset}%{shortpkg}[%{longfunc}] %{message}")
var listenAddr = ":3004"

func main() {
	stderrBackend := logging.NewLogBackend(os.Stderr, "", 0)
	stderrFormatter := logging.NewBackendFormatter(stderrBackend, stdout_log_format)
	logging.SetBackend(stderrFormatter)
	logging.SetFormatter(stdout_log_format)

	log.Noticef("Starting app, version %s", version)
	if !strings.ContainsRune(version, '-') {
		log.Warning("once you tag your commit with name your version number will be prettier")
	}
	log.Error("now add some code!")
	w, _ := web.New(&web.Config{})
	_ = w
	r := chi.NewRouter()
	r.Use(middleware.RequestID)
	r.Use(middleware.RealIP)
	r.Use(middleware.Logger)
	r.Use(middleware.Recoverer)
	// Set a timeout value on the request context (ctx), that will signal
	// through ctx.Done() that the request has timed out and further
	// processing should be stopped.
	r.Use(middleware.Timeout(60 * time.Second))
	r.Get("/", func(w http.ResponseWriter, r *http.Request) {
		w.Write([]byte("welcome"))
	})
	r.Get("/p/{param}", func(w http.ResponseWriter, r *http.Request) {
		userID := chi.URLParam(r, "param")
		w.Write([]byte(userID))
	})

	log.Noticef("Listening on %s", listenAddr)
	log.Errorf("Error when listening: %s", http.ListenAndServe(listenAddr, r))
}
