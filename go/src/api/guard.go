package main

import (
	"fmt"
	"net/http"
	"github.com/dgrijalva/jwt-go"
	"github.com/gorilla/mux"
)

func AuthentificationGuard(inner http.Handler, Auth, UserId string) http.Handler {
	return http.HandlerFunc(func (w http.ResponseWriter, r *http.Request) {
		inner.ServeHTTP(w, r)
		return

		if Auth != "None" {
			cookie, err := r.Cookie("jwt")
			if err != nil {
				panic(err)
			}

			tokenString := cookie.Value



			token, err := jwt.Parse(tokenString, func(token *jwt.Token) (interface{}, error) {
				if _, ok := token.Method.(*jwt.SigningMethodHMAC); !ok {
					return nil, fmt.Errorf("Unexpected signing method: %v", token.Header["alg"])
				}
				return []byte("TitusPinta"), nil
			})

			if claims, ok := token.Claims.(jwt.MapClaims); ok && token.Valid {
				vars := mux.Vars(r)
				if !((Auth == "Admin" && claims["admin"] == "true") ||
					(Auth == "User" && claims["id"] == vars[UserId])) {
						w.Header().Set(
							"Content-Type", "application/json; charset=UTF-8")
						w.WriteHeader(http.StatusUnauthorized)
						fmt.Fprintf(w, "{\"msg\": \"Error\"}")
						panic("Unauthorized")
				}


			} else {
				panic(err)
			}
		}
		inner.ServeHTTP(w, r)
	})
}
