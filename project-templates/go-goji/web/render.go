package web

import (
	"html/template"
	"golang.org/x/net/context"
	"net/http"
	"goji.io/pat"
	"github.com/op/go-logging"
	"gopkg.in/unrolled/render.v1"
	"sync"
	"fmt"

)
var log = logging.MustGetLogger("main")
type Renderer struct {
	templateCache map[string]*template.Template
	Cache bool
	Params map[string]string
	render *render.Render
	sync.RWMutex
}

func New() (r *Renderer,err error) {
	var v Renderer
	v.templateCache = make(map[string]*template.Template)
	v.Cache=true
	v.Params = make(map[string]string)
	v.render = render.New()
	return &v,err
}


func (r *Renderer) Handle(ctx context.Context, w http.ResponseWriter, req *http.Request) {
	page := pat.Param(ctx, "page")
	r.HandlePage(page,ctx,w,req)
}
func (r *Renderer) HandleRoot(ctx context.Context, w http.ResponseWriter, req *http.Request) {
	page := `index.html`
	r.HandlePage(page,ctx,w,req)
}

func (r *Renderer) HandleStatus(ctx context.Context, w http.ResponseWriter, req *http.Request) {
	r.render.JSON(w, http.StatusOK,  map[string]bool{"ok": true})
}

func (r *Renderer) HandlePage(page string,ctx context.Context, w http.ResponseWriter, req *http.Request) {
	t, err := r.getTpl(page)
	if err != nil {
		fmt.Fprintf(w, "Page %s not found, err:[%+v]",page,err)
		return
	}
	t.Execute(w, r.Params)
}

func (r *Renderer)getTpl(name string) (t *template.Template, err error) {
	r.RLock()
	t, ok := r.templateCache[name]
	r.RUnlock()

	if !ok {
		t,err = template.ParseFiles(fmt.Sprintf("templates/%s",name))
		if err != nil {
			return t, err
		}
		if r.Cache {
			r.Lock()
			r.templateCache[name] = t
			r.Unlock()
		}
	}
	return t,err


}
