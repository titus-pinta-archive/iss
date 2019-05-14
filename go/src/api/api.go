package main

import (
	"log"
	"fmt"
	"net/http"
	"github.com/gorilla/mux"
)

type Route struct {
	Name		string
	Method		string
	Pattern		string
	Auth		string
	UserId		string
	HandlerFunc http.HandlerFunc
}

type Routes []Route

var b *Broker

func NewRouter() *mux.Router {
	router := mux.NewRouter().StrictSlash(true)
	for _, route := range routes {
		handler := Logger(AuthentificationGuard(CORS(route.HandlerFunc, "*"),
			route.Auth, route.UserId), route.Name)
		router.Methods(route.Method).
		Path(route.Pattern).
		Name(route.Name).
		Handler(handler)
	}

	b = &Broker{
		make(map[chan string]bool),
		make(chan (chan string)),
		make(chan (chan string)),
		make(chan string),
	}

	b.Start()

	router.HandleFunc("/events", b.ServeHTTP)

	return router
}

var routes = Routes{
	Route {
		"Index",
		"GET",
		"/",
		"None",
		"",
		Index,
	},
	Route {
		"Books",
		"GET",
		"/books",
		"None",
		"",
		Books,
	},
	Route {
		"CreateBooks",
		"POST",
		"/books",
		"Admin",
		"",
		CreateBook,
	},
	Route {
		"ReadBook",
		"GET",
		"/books/{Id}",
		"None",
		"",
		ReadBook,
	},
	Route {
		"UpdateBook",
		"PUT",
		"/books/{Id}",
		"Admin",
		"",
		UpdateBook,
	},
	Route {
		"DeleteBook",
		"DELETE",
		"/books/{Id}",
		"Admin",
		"",
		DeleteBook,
	},
	Route {
		"CreateReader",
		"POST",
		"/readers",
		"None",
		"",
		CreateReader,
	},
	Route {
		"ReadReader",
		"GET",
		"/readers/{Id}",
		"User",
		"Id",
		ReadReader,
	},
	Route {
		"UpdateReader",
		"PUT",
		"/readers/{Id}",
		"User",
		"Id",
		UpdateReader,
	},
	Route {
		"DeleteReader",
		"DELETE",
		"/readers/{Id}",
		"User",
		"Id",
		DeleteReader,
	},
	Route {
		"CreateIndividualBooks",
		"POST",
		"/individual_books",
		"Admin",
		"",
		CreateIndividualBook,
	},
	Route {
		"ReadIndividualBook",
		"GET",
		"/individual_books/{Id}",
		"Admin",
		"",
		ReadIndividualBook,
	},
	Route {
		"UpdateIndividualBook",
		"PUT",
		"/individual_books/{Id}",
		"Admin",
		"",
		UpdateIndividualBook,
	},
	Route {
		"DeleteIndividualBook",
		"DELETE",
		"/individual_books/{Id}",
		"Admin",
		"",
		DeleteIndividualBook,
	},
	Route {
		"BorrowBook",
		"POST",
		"/books/{BookId}/{UserId}",
		"User",
		"UserId",
		BorrowBook,
	},
	Route {
		"ReturnBook",
		"POST",
		"/individual_books/{IndividualBookId}/{UserId}",
		"Admin",
		"",
		ReturnBook,
	},
	Route {
		"Authentificate",
		"POST",
		"/authentificate",
		"None",
		"",
		Authentificate,
	},
	Route {
		"GetRentals",
		"GET",
		"/rentals",
		"None",
		"",
		GetRentals,
	},
}

type Broker struct {
	clients map[chan string]bool
	newClients chan chan string
	defunctClients chan chan string
	message chan string
}

func (b *Broker) Start() {
	go func () {
		for {
			select {
				case s := <-b.newClients:
					b.clients[s] = true
					log.Println("Added new Client")
				case s := <-b.defunctClients:
					delete(b.clients, s)
					close(s)
				case msg := <-b.message:
					for s := range b.clients {
						s <- msg
					}
					log.Println("Brodcast")

			}
		}
	}()
}

func (b *Broker) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	log.Println("Event subscribed")

	// Make sure that the writer supports flushing.
	//
	f, ok := w.(http.Flusher)
	if !ok {
		http.Error(w, "Streaming unsupported!", http.StatusInternalServerError)
		return
	}

	// Create a new channel, over which the broker can
	// send this client messages.
	messageChan := make(chan string)

	// Add this client to the map of those that should
	// receive updates
	b.newClients <- messageChan

	// Listen to the closing of the http connection via the CloseNotifier
	notify := w.(http.CloseNotifier).CloseNotify()
	go func() {
		<-notify
		// Remove this client from the map of attached clients
		// when `EventHandler` exits.
		b.defunctClients <- messageChan
		log.Println("HTTP connection just closed.")
	}()

	// Set the headers related to event streaming.
	w.Header().Set("Content-Type", "text/event-stream")
	w.Header().Set("Cache-Control", "no-cache")
	w.Header().Set("Connection", "keep-alive")
	w.Header().Set("Transfer-Encoding", "chunked")

	w.Header().Set("Access-Control-Allow-Origin", "*")
	// Don't close the connection, instead loop endlessly.
	for {

		// Read from our messageChan.
		msg, open := <-messageChan

		if !open {
			// If our messageChan was closed, this means that the client has
			// disconnected.
			break
		}

		// Write to the ResponseWriter, `w`.
		fmt.Fprintf(w, "data: Message: %s\n\n", msg)

		// Flush the response.  This is only possible if
		// the repsonse supports streaming.
		f.Flush()
	}

	// Done.
	log.Println("Finished HTTP request at ", r.URL.Path)
}


func main() {

	s = InitDB()



	router := NewRouter()
	log.Fatal(http.ListenAndServe(":8080", router))

}

