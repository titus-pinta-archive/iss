package main

import (
	"fmt"
	"time"
	"github.com/go-xorm/xorm"
	"github.com/satori/go.uuid"
	_ "github.com/lib/pq"
)

//Classes
type Reader struct {
	Id	string	`xorm:"'id' pk uuid" json:"id"validate:"requred,uuid"`
	Email	string	`xorm:"'email' not null unique"json:"email" validate:"required,email"`
	Pass	string	`xorm:"'pass' not null" json:"pass"validate:"required"`
	CNP	string	`xorm:"'cnp' not null unique"json:"cnp" validate:"required"`
	Address	string	`xorm:"'address' not null"json:"address" validate:"required"`
	Phone	string	`xorm:"'phone' not null"json:"phone" validate:"required"`
}

type Book struct {
	Id	string	`xorm:"'id' pk uuid" json:"id" validate:"required,uuid"`
	Title	string	`xorm:"'title' not null unique"json:"title" validate:"required"`
	Author	string	`xorm:"'author' not null" json:"author" validate:"required"`
	Image	string	`xorm:"'image'" json:"img"`
}

type IndividualBook struct {
	Id	string	`xorm:"'id' pk uuid" json:"id" validate:"required,uuid"`
	BookId	string	`xorm:"'book_id' uuid" json:"book_id" validate:"required,uuid"`
}

type BookView struct {
	Id		string	`xorm:"'book_id' uuid" json:"id"`
	Title		string	`xorm:"'title' not null unique"json:"title"`
	Author		string	`xorm:"'author' not null" json:"author"`
	Available	int	`xorm:"'available'"json:"available"`
	Image		string	`xorm:"'image'" json:"img"`
}

func (BookView) TableName() string {
	return "book"
}

type LoanEvent struct {
	Id			string		`xorm:"'id' pk uuid" json:"id" validate:"requred,uuid"`
	IndividualBookId	string		`xorm:"'individual_book_id' uuid" json:"individual_book_id"`
	UserId			string		`xorm:"'user_id' uuid" json:"user_id"`
	EventType		string		`xorm:"'event_type'" json:"event_type"`
	TimeStamp		time.Time		`xorm:"'created'" json:"time_stamp"`
}

type LoanEventView struct {
	EventType	string	`xorm:"event_type"`
	BookId		string	`xorm:"book_id"`
}

func (LoanEventView) TableName() string {
	return "loan_event"
}

type RentalView struct {
	IndividualBookId	string	`xorm:"'individual_book_id'" json:"_individual_book_id"`
	UserId			string	`xorm:"'reader_id'" json:"_user_id"`
	Title			string	`xorm:"'title'" json:"title"`
	Email			string	`xorm:"'email'" json:"email"`
	EventType		string	`xorm:"'event_type'" json:"_event_type"`
}

func (RentalView) TableName() string {
	return "loan_event"
}

type DBSession struct {
	orm	*xorm.Engine
}

//CRUD Reader
func (s DBSession) CreateReader(
	Email, Pass, CNP, Address, Phone string) *Reader {

	r := &Reader{uuid.Must(uuid.NewV4()).String(),
		Email, Pass, CNP, Address, Phone}

	_, err := s.orm.Insert(r)
	if err != nil {
		return &Reader{}
		panic(err)
	}
	return r
}

func (s DBSession) ReadReader(Id string) *Reader {
	var r []Reader
	err := s.orm.Where("id = ?", Id).Find(&r)
	if err != nil {
		fmt.Println(err)
		return nil
	} else if (len(r)) != 1{
		fmt.Println("Not found")
		return nil
	} else {
		return &r[0]
	}
}

func (s DBSession) UpdateReader(
	Id, Email, Pass, CNP, Address, Phone string) *Reader {

	r := &Reader{Id, Email, Pass, CNP, Address, Phone}
	_, err := s.orm.Where("id = ?", Id).Update(r)
	if err != nil {
		panic(err)
	}
	return r
}

func (s DBSession) DeleteReader(Id string) {
	_, err := s.orm.Where("id = ?", Id).Delete(&Reader{})
	if err != nil {
		panic(err)
	}
}


//CRUD Book
func (s DBSession) CreateBook(Title, Author, Image string) *Book {
	b := &Book{uuid.Must(uuid.NewV4()).String(),
		Title, Author, Image}

	_, err := s.orm.Insert(b)
	if err != nil {
		panic(err)
	}
	return b
}

func (s DBSession) ReadBook(Id string) *Book {
	var b []Book
	err := s.orm.Where("id = ?", Id).Find(&b)
	if err != nil {
		fmt.Println(err)
		return nil
	} else if (len(b)) != 1{
		fmt.Println("Not found")
		return nil
	} else {
		return &b[0]
	}
}

func (s DBSession) UpdateBook(Id, Author, Title, Image string) *Book {
	b := &Book{Id, Author, Title, Image}
	_, err := s.orm.Where("id = ?", Id).Update(b)
	if err != nil {
		panic(err)
	}
	return b
}

func (s DBSession) DeleteBook(Id string) {
	_, err := s.orm.Where("id = ?", Id).Delete(&Book{})
	if err != nil {
		panic(err)
	}
}


//CRUD IndividualBook
func (s DBSession) CreateIndividualBook(BookId string) *IndividualBook {
	b := &IndividualBook{uuid.Must(uuid.NewV4()).String(), BookId}

	_, err := s.orm.Insert(b)
	if err != nil {
		panic(err)
	}
	return b
}

func (s DBSession) ReadIndividualBook(Id string) *IndividualBook {
	var b []IndividualBook
	err := s.orm.Where("id = ?", Id).Find(&b)
	if err != nil {
		fmt.Println(err)
		return nil
	} else if (len(b)) != 1{
		fmt.Println("Not found")
		return nil
	} else {
		return &b[0]
	}
}

func (s DBSession) UpdateIndividualBook(Id, BookId string) *IndividualBook {
	b := &IndividualBook{Id, BookId}
	_, err := s.orm.Where("id = ?", Id).Update(b)
	if err != nil {
		panic(err)
	}
	return b
}

func (s DBSession) DeleteIndividualBook(Id string) {
	_, err := s.orm.Where("id = ?", Id).Delete(&IndividualBook{})
	if err != nil {
		panic(err)
	}
}

//Buissniss Logic

func (s DBSession) Authentificate(Email, Password string) bool {
	total, err := s.orm.Where("email = ? AND pass = ?", Email, Password).
		Count(&Reader{})
	if err != nil {
		panic(err)
	}
	if total == 1 {
		return true
	} else {
		return false
	}
}

func (s DBSession) GetUserFromEmail(Email string) *Reader {
	var r []Reader
	err := s.orm.Where("email = ?", Email).Find(&r)
	if err != nil {
		panic(err)
	}
	return &r[0]
}

func (s DBSession) BorrowBook(BookId, UserId string) string {
	var IndividualBooks []IndividualBook
	err := s.orm.Where("book_id = ?", BookId).Find(&IndividualBooks)
	if err != nil {
		panic(err)
	}


	var IndividualBookId string
	for _, individualBook := range IndividualBooks {
		var LoanEvents []LoanEvent
		err := s.orm.Where("individual_book_id = ?", individualBook.Id).
			OrderBy("created").
			Find(&LoanEvents)
		if err != nil {
			panic(err)
		}

		if LoanEvents == nil {
			IndividualBookId = individualBook.Id
			break
		} else {
			fmt.Println(LoanEvents)
			if LoanEvents[len(LoanEvents) - 1].EventType == "return" {
				IndividualBookId = individualBook.Id
				break
			}
		}

		fmt.Println(individualBook.Id, LoanEvents)
	}

	if IndividualBookId != "" {
		loanEvent := &LoanEvent{uuid.Must(uuid.NewV4()).String(),
			IndividualBookId, UserId, "borrow", time.Now()}
			_, err := s.orm.Insert(loanEvent)
			if err != nil {
				panic(err)
			}

		s.UpdateBookView()

		return "{\"msg\": \"Succes\"}"
	} else {
		return "{\"msg\": \"Error\"}"
	}

}

func (s DBSession) ReturnBook(IndividualBookId, UserId string) string {
	totalBorrowed, err := s.orm.
		Where("loan_event.event_type = 'borrow' AND individual_book_id = ? AND user_id = ?",
			IndividualBookId, UserId).
		Count(&LoanEvent{})
	if err != nil {
		panic(err)
	}

	totalReturned, err := s.orm.
		Where("loan_event.event_type = 'return' AND individual_book_id = ? AND user_id = ?",
			IndividualBookId, UserId).
		Count(&LoanEvent{})

	if totalBorrowed - totalReturned != 1 {
		return "{\"msg\": \"Error\"}"
	}

	loanEvent := &LoanEvent{uuid.Must(uuid.NewV4()).String(),
		IndividualBookId, UserId, "return", time.Now()}
		_, err = s.orm.Insert(loanEvent)
		if err != nil {
			panic(err)
		}

	s.UpdateBookView()

	return "{\"msg\": \"Succes\"}"
}

var CurrentBooks *[]BookView

func (s DBSession) UpdateBookView() {
	var books []BookView
	err := s.orm.GroupBy("book_id, title, author, image").
		Select("book_id, title, author, image, count(*) as available").
		Join("INNER", "individual_book", "book.id = individual_book.book_id").
		Find(&books)

	if err != nil {
		panic(err)
	}

	for i, b := range books {
		totalBorrowed, err := s.orm.
			Join("INNER", "individual_book", "loan_event.individual_book_id = individual_book.id").
			Where("loan_event.event_type = 'borrow' AND individual_book.book_id = ?", b.Id).
			Count(&LoanEvent{})
		if err != nil {
			panic(err)
		}

		totalReturned, err := s.orm.
			Join("INNER", "individual_book", "loan_event.individual_book_id = individual_book.id").
			Where("loan_event.event_type = 'return' AND individual_book.book_id = ?", b.Id).
			Count(&LoanEvent{})
		if err != nil {
			panic(err)
		}
		books[i].Available = b.Available - int(totalBorrowed) + int(totalReturned)
	}
	CurrentBooks = &books
}

func (s DBSession) GetBooks() *[]BookView {

	return CurrentBooks
}

type Ids struct {
	Id string `xorm:"id"`
}
func (Ids) TableName() string {
	return "individual_book"
}

func (s DBSession) GetRentals() *[]RentalView{
	var rentals []RentalView


	var ids []Ids

	err := s.orm.Select("id").Find(&ids)
	if err != nil {
		panic(err)
	}

	for _, id := range ids {
		var rental RentalView
		_, err = s.orm.Select("individual_book.id as individual_book_id, reader.id as reader_id, title, email, event_type").
			Where("individual_book.id = ?", id.Id).
			Join("INNER", "reader", "reader.id = loan_event.user_id").
			Join("INNER", "individual_book", "loan_event.individual_book_id = individual_book.id").
			Join("INNER", "book", "individual_book.book_id = book_id").Desc("loan_event.created").
		Get(&rental)

		if err != nil {
			panic(err)
		}
		if rental.EventType == "borrow" {
			rentals = append(rentals, rental)
		}

	}
	fmt.Println(rentals)
	return &rentals
}

//Init DB
func InitDB() *DBSession {

	orm, err := xorm.NewEngine(
		"postgres", "user=titus dbname=iss sslmode=disable")

	if err != nil {
		fmt.Println(err)
		return nil
	}
	orm.ShowSQL(true)
	err = orm.Sync2(&Reader{}, &Book{}, &IndividualBook{}, &LoanEvent{})
	if err != nil {
		fmt.Println(err)
		return nil
	}

	temp := &DBSession{orm}
	temp.UpdateBookView()
	return temp
}
