package main

import (
	"fmt"
	"io"
	"io/ioutil"
	"encoding/json"
	"net/http"
	"github.com/gorilla/mux"
	"github.com/dgrijalva/jwt-go"
)

var s *DBSession

func Index(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello world")
}

//Logic

func Authentificate(w http.ResponseWriter, r *http.Request) {
	type User struct {
		Email		string	`json:"email"`
		Password	string	`json:"pass"`
	}

	var u User

	body, err := ioutil.ReadAll(io.LimitReader(r.Body, 1048576))
	if err != nil {
		panic(err)
	}
	if err := r.Body.Close(); err != nil {
		panic(err)
	}
	if err := json.Unmarshal(body, &u); err != nil {
		w.Header().Set(
			"Content-Type", "application/json; charset=UTF-8")
		w.WriteHeader(422)
		if err := json.NewEncoder(w).Encode(err); err != nil {
			panic(err)
		}
	}

	var ret string

	if (s.Authentificate(u.Email, u.Password)) {
		reader := s.GetUserFromEmail(u.Email)
		token := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
			    "id": reader.Id,
			    "email": reader.Email,
			    "cnp": reader.CNP,
			    "phone": reader.Phone,
			    "admin": false,
			})

		tokenString, err := token.SignedString([]byte("TitusPinta"))
		if err != nil {
			panic(err)
		}
		ret = "{\"msg\": \"Succes\", \"jwt\":\"" + tokenString + "\"}"

	} else {
		ret = "{\"msg\": \"Error\"}"
	}

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, "%s", ret)
}

func Books(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).Encode(s.GetBooks()); err != nil {
		        panic(err)
	}
}

func BorrowBook(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, s.BorrowBook(vars["BookId"], vars["UserId"]))
	b.message <- "update"
}

func ReturnBook(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	fmt.Fprintf(w, s.ReturnBook(vars["IndividualBookId"], vars["UserId"]))
	b.message <- "update"
}

func GetRentals(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).Encode(s.GetRentals()); err != nil {
		        panic(err)
	}
}

//CRUD Books

func CreateBook(w http.ResponseWriter, r *http.Request) {
	type BookTemp struct {
		Title	string	`json:"title"`
		Author	string	`json:"author"`
		Image	string	`json:"img"`
	}

	var b BookTemp

	body, err := ioutil.ReadAll(io.LimitReader(r.Body, 1048576))
	if err != nil {
		panic(err)
	}
	if err := r.Body.Close(); err != nil {
		panic(err)
	}

	if err := json.Unmarshal(body, &b); err != nil {
		w.Header().Set(
			"Content-Type", "application/json; charset=UTF-8")
		w.WriteHeader(422)
		if err := json.NewEncoder(w).Encode(err); err != nil {
			panic(err)
		}
	}

	book := s.CreateBook(b.Title, b.Author, b.Image)

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusCreated)
	if err := json.NewEncoder(w).Encode(book); err != nil {
		panic(err)
	}
}

func ReadBook(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	w.Header().Set(
		"Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).
			Encode(s.ReadBook(vars["Id"])); err != nil {

		panic(err)
	}
}

func UpdateBook(w http.ResponseWriter, r *http.Request) {
	type BookTemp struct {
		Title	string	`json:"title"`
		Author	string	`json:"author"`
		Image	string	`json:"img"`
	}

	var b BookTemp

	body, err := ioutil.ReadAll(io.LimitReader(r.Body, 1048576))
	if err != nil {
		panic(err)
	}
	if err := r.Body.Close(); err != nil {
		panic(err)
	}

	if err := json.Unmarshal(body, &b); err != nil {
		w.Header().Set(
			"Content-Type", "application/json; charset=UTF-8")
		w.WriteHeader(422)
		if err := json.NewEncoder(w).Encode(err); err != nil {
			panic(err)
		}
	}

	vars := mux.Vars(r)

	book := s.UpdateBook(vars["Id"], b.Title, b.Author, b.Image)

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).Encode(book); err != nil {
		panic(err)
	}
}

func DeleteBook(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	w.WriteHeader(http.StatusNoContent)
	s.DeleteBook(vars["Id"])
}

//CRUD Readers

func CreateReader(w http.ResponseWriter, r *http.Request) {
	type ReaderTemp struct {
		Email	string	`json:"email"`
		Pass	string	`json:"pass"`
		CNP	string	`json:"cnp"`
		Address	string	`json:"address"`
		Phone	string	`json:"phone"`
	}

	var reader ReaderTemp

	body, err := ioutil.ReadAll(io.LimitReader(r.Body, 1048576))
	if err != nil {
		panic(err)
	}
	if err := r.Body.Close(); err != nil {
		panic(err)
	}

	if err := json.Unmarshal(body, &reader); err != nil {
		w.Header().Set(
			"Content-Type", "application/json; charset=UTF-8")
		w.WriteHeader(422)
		if err := json.NewEncoder(w).Encode(err); err != nil {
			panic(err)
		}
	}

	created_reader := s.CreateReader(
		reader.Email, reader.Pass, reader.CNP,
		reader.Address, reader.Phone)

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusCreated)
	if err := json.NewEncoder(w).Encode(created_reader); err != nil {
		panic(err)
	}
}

func ReadReader(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	w.Header().Set(
		"Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).Encode(s.ReadReader(vars["Id"])); err != nil {
		panic(err)
	}
}

func UpdateReader(w http.ResponseWriter, r *http.Request) {
	type ReaderTemp struct {
		Email	string	`json:"email"`
		Pass	string	`json:"pass"`
		CNP	string	`json:"cnp"`
		Address	string	`json:"address"`
		Phone	string	`json:"phone"`
	}

	var reader ReaderTemp

	body, err := ioutil.ReadAll(io.LimitReader(r.Body, 1048576))
	if err != nil {
		panic(err)
	}
	if err := r.Body.Close(); err != nil {
		panic(err)
	}

	if err := json.Unmarshal(body, &reader); err != nil {
		w.Header().Set(
			"Content-Type", "application/json; charset=UTF-8")
		w.WriteHeader(422)
		if err := json.NewEncoder(w).Encode(err); err != nil {
			panic(err)
		}
	}

	vars := mux.Vars(r)
	created_reader := s.UpdateReader(vars["Id"],
		reader.Email, reader.Pass, reader.CNP,
		reader.Address, reader.Phone)

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusCreated)
	if err := json.NewEncoder(w).Encode(created_reader); err != nil {
		panic(err)
	}
}

func DeleteReader(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	w.WriteHeader(http.StatusNoContent)
	s.DeleteReader(vars["Id"])
}

//CRUD IndividualBooks

func CreateIndividualBook(w http.ResponseWriter, r *http.Request) {
	type BookTemp struct {
		BookId	string	`json:"book_id"`
	}

	var b BookTemp

	body, err := ioutil.ReadAll(io.LimitReader(r.Body, 1048576))
	if err != nil {
		panic(err)
	}
	if err := r.Body.Close(); err != nil {
		panic(err)
	}

	if err := json.Unmarshal(body, &b); err != nil {
		w.Header().Set(
			"Content-Type", "application/json; charset=UTF-8")
		w.WriteHeader(422)
		if err := json.NewEncoder(w).Encode(err); err != nil {
			panic(err)
		}
	}

	book := s.CreateIndividualBook(b.BookId)

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusCreated)
	if err := json.NewEncoder(w).Encode(book); err != nil {
		panic(err)
	}
}

func ReadIndividualBook(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	w.Header().Set(
		"Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).Encode(
		s.ReadIndividualBook(vars["Id"])); err != nil {
			panic(err)
	}
}

func UpdateIndividualBook(w http.ResponseWriter, r *http.Request) {
	type BookTemp struct {
		BookId	string	`json:"book_id"`
	}

	var b BookTemp

	body, err := ioutil.ReadAll(io.LimitReader(r.Body, 1048576))
	if err != nil {
		panic(err)
	}
	if err := r.Body.Close(); err != nil {
		panic(err)
	}

	if err := json.Unmarshal(body, &b); err != nil {
		w.Header().Set(
			"Content-Type", "application/json; charset=UTF-8")
		w.WriteHeader(422)
		if err := json.NewEncoder(w).Encode(err); err != nil {
			panic(err)
		}
	}

	vars := mux.Vars(r)

	book := s.UpdateIndividualBook(vars["Id"], b.BookId)

	w.Header().Set("Content-Type", "application/json; charset=UTF-8")
	w.WriteHeader(http.StatusOK)
	if err := json.NewEncoder(w).Encode(book); err != nil {
		panic(err)
	}
}

func DeleteIndividualBook(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	w.WriteHeader(http.StatusNoContent)
	s.DeleteIndividualBook(vars["Id"])
}
