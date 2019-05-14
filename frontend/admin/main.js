const jwt = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhZG1pbiI6dHJ1ZX0.yjsNXtAz8iwhqBbp7ateEXis6azvkPlH0oxOL9tZEXE"

const getBooksObs = async () => {
	let response = await fetch('http://localhost:8080/rentals');
	let json = await response.json();
	return Rx.Observable.fromArray(json);
}


const initNavbar = () => {

		const navbar = document.getElementById('navbar');
		navbar.data = {
			logo: {type: "text", value: "Library"},
			links: [{text: "Books", href: ""}]
		};
		return navbar;
}

const returnBook = (str) => {
	console.log(str);
	var res = str.split('+');
	fetch(`http://localhost:8080/individual_books/${res[0]}/${res[1]}`, 
		{method: 'POST', credential: 'same-origin'})
			.then(x => x.json())
			.then(x => {console.log(x)
				if (x.msg === 'Succes') {
				
							document.getElementById('succes-modal').toggle();
							getCards().then(data => {
							document.getElementById('user-cards').free();
							document.getElementById('user-cards').render(data);
	});
				}
			});
	

}

const initCards = () => {
	var obs = getBooksObs().then(obs => {
		let aux = obs.map(obj => {
			obj._id = `${obj._individual_book_id}+${obj._user_id}`;
			obj.actions = {'Return': returnBook}
			delete obj.id;
			return obj;});
		document.getElementById('user-cards').data = {
			obs: aux,
		};
	});
}

const getCards= async () => {
	var obs = await getBooksObs();
	let aux = obs.map(obj => {
		obj._id = `${obj._individual_book_id}+${obj._user_id}`;
		obj.actions = {'Return': returnBook}
		delete obj.id;
		return obj;});
	data = {
		obs: aux,
	};
	return data;
}


const app = () => {
	initNavbar();
	initCards();
}

app();
var source = new EventSource('http://localhost:8080/events');
source.onmessage = (e) => {
	console.log(e.data);
	var obs = getBooksObs().then(obs => {
		let aux = obs.map(obj => {
			obj._id = `${obj._individual_book_id}+${obj._user_id}`;
			obj.actions = {'Return': returnBook}
			delete obj.id;
			return obj;});
		var data = {
			obs: aux
		};
		document.getElementById('user-cards').data = data;
		document.getElementById('user-cards').free();
		document.getElementById('user-cards').render(data);
	});
}
