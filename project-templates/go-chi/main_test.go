package main

import (
    "./web"
	"net/http"
	"net/http/httptest"
	"testing"
	. "github.com/smartystreets/goconvey/convey"
)

var testStrings []string

func TestExample(t *testing.T) {
    // create router
    w, _ := web.New(&web.Config{})
	router := getRouter(w)
	// create a ResponseRecorder (which satisfies http.ResponseWriter) to record the response.
	rr := httptest.NewRecorder()


	// Create a request to router. We don't have any query parameters for now, so we'll
	// pass 'nil' as the third parameter.
	//req, err := http.NewRequest("GET", "/health-check", nil)
	req, err := http.NewRequest("GET", "/", nil)

	// Our handlers satisfy http.Handler, so we can call their ServeHTTP method
	// directly and pass in our Request and ResponseRecorder.
	router.ServeHTTP(rr, req)
	Convey("/ returns 200", t, func() {
		So(err,ShouldBeNil)
		So(rr.Code, ShouldEqual, http.StatusOK)
		So(rr.Body.String(), ShouldContainSubstring, "welcome")
	})

	req2, err := http.NewRequest("GET", "/p/testparam", nil)
	if err != nil {
		t.Fatal(err)
	}
	rr2 := httptest.NewRecorder()
	router.ServeHTTP(rr2, req2)
		Convey("/p/:param returns param", t, func() {
		So(err,ShouldBeNil)
		So(rr2.Code, ShouldEqual, http.StatusOK)
		So(rr2.Body.String(), ShouldContainSubstring, "testparam")
	})
}
