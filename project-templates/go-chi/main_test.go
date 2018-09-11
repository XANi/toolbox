package main

import (
    "./web"
	"net/http"
	"net/http/httptest"
	"testing"
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
	if err != nil {
		t.Fatal(err)
	}

	// Our handlers satisfy http.Handler, so we can call their ServeHTTP method
	// directly and pass in our Request and ResponseRecorder.
	router.ServeHTTP(rr, req)

	// Check the status code is what we expect.
	if status := rr.Code; status != http.StatusOK {
		t.Errorf("handler returned wrong status code: got %v want %v",
			status, http.StatusOK)
	}

	// Check the response body is what we expect.
	expected := `welcome`
	if rr.Body.String() != expected {
		t.Errorf("handler returned unexpected body: got %v want %v",
			rr.Body.String(), expected)
	}
}
