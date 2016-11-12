package main

import (
	"github.com/op/go-logging"
	"goji.io"
	"goji.io/pat"
	"os"
	"strings"
	//	"golang.org/x/net/context"
	"./web"
	"net/http"
)

var version string
var log = logging.MustGetLogger("main")
var stdout_log_format = logging.MustStringFormatter("%{color:bold}%{time:2006-01-02T15:04:05.9999Z-07:00}%{color:reset}%{color} [%{level:.1s}] %{color:reset}%{shortpkg}[%{longfunc}] %{message}")
var listenAddr = "127.0.0.1:3002"

func main() {
	stderrBackend := logging.NewLogBackend(os.Stderr, "", 0)
	stderrFormatter := logging.NewBackendFormatter(stderrBackend, stdout_log_format)
	logging.SetBackend(stderrFormatter)
	logging.SetFormatter(stdout_log_format)

	log.Info("Starting app")
	log.Debugf("version: %s", version)
	if !strings.ContainsRune(version, '-') {
		log.Warning("once you tag your commit with name your version number will be prettier")
	}
	log.Error("now add some code!")

	renderer, err := web.New()
	if err != nil {
		log.Errorf("Renderer failed with: %s", err)
	}
	mux := goji.NewMux()
	mux.Handle(pat.Get("/static/*"), http.StripPrefix("/static", http.FileServer(http.Dir(`public/static`))))
	mux.Handle(pat.Get("/apidoc/*"), http.StripPrefix("/apidoc", http.FileServer(http.Dir(`public/apidoc`))))
	mux.HandleFunc(pat.Get("/"), renderer.HandleRoot)
	mux.HandleFunc(pat.Get("/status"), renderer.HandleStatus)
	log.Warningf("listening on %s", listenAddr)
	log.Errorf("failed on %s", http.ListenAndServe(listenAddr, mux))
}
