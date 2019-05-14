package main

import (
	"net/http"
)

func CORS(inner http.Handler, Origin string) http.Handler {
	return http.HandlerFunc(func (w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Access-Control-Allow-Origin", Origin)
		inner.ServeHTTP(w, r)

	})
}
