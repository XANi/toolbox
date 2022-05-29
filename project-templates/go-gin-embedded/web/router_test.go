package web

import (
	"github.com/gin-gonic/gin"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"go.uber.org/zap/zaptest"
	"io/ioutil"
	"net/http"
	"net/http/httptest"
	"os"
	"testing"
)

var webContent = os.DirFS("../testdata/fs")

func testServer(eng *gin.Engine, req *http.Request) *httptest.ResponseRecorder {
	w := httptest.NewRecorder()
	eng.ServeHTTP(w, req)
	return w
}

func TestWebBackend_Run(t *testing.T) {
	backend, err := New(Config{
		Logger:     zaptest.NewLogger(t).Sugar(),
		ListenAddr: "0.0.0.0",
	},
		webContent,
	)
	require.Nil(t, err)
	r, _ := http.NewRequest("GET", "/", nil)
	t1 := testServer(backend.r, r)
	b, _ := ioutil.ReadAll(t1.Body)
	assert.Contains(t, string(b), "<head>")
	require.Nil(t, err)
	r2, _ := http.NewRequest("GET", "/s/s.css", nil)
	t2 := testServer(backend.r, r2)
	b, _ = ioutil.ReadAll(t2.Body)
	assert.Contains(t, string(b), "background-color")
}
