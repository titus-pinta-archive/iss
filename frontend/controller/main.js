const getBooksObs = async () => {
	let response = await fetch('http://localhost:8080/books');
	let json = await response.json();
	return Rx.Observable.fromArray(json);
}

var source = new EventSource('http://localhost:8080/events');
source.onmessage = (e) => {
	console.log(e.data);
	var obs = getBooksObs().then(obs => {
		let aux = obs.map(obj => {
			obj.img = "https://www.openbookpublishers.com/shopimages/sections/normal/Open-Bookpic.jpg";
			obj._id = obj.id;
			obj.available = `${obj.available} Available`;

			if (localStorage.getItem('logedIn') === 'true') {
				obj.actions = {'Borrow': rezerveBook}
			}

			delete obj.id;
			return obj;})
		var data = {
			obs: aux
		};
		document.getElementById('user-cards').data = data;
		document.getElementById('user-cards').free();
		document.getElementById('user-cards').render(data);
	});
}

const initNavbar = () => {

		const navbar = document.getElementById('navbar');
		navbar.data = {
			logo: {type: "text", value: "Library"},
			links: [{text: "Register", href: ""}, {text: "Log In", href: "#", action: () => {
				document.querySelector('#log-in-modal').toggle();
			}}]
		};
		return navbar;
}

const initNavbarLogin = () => {

		const navbar = document.getElementById('navbar');
		navbar.data = {
			logo: {type: "text", value: "Library"},
			links: [{text: "Log Out", href: "", action: () => {
				document.getElementById('succes-modal').toggle();
				logout();
			}}, {text: "My Account", href: "#", action: () => {
				console.log('Not implemented yet');
			}}]
		};
}

const initCards = () => {
	var obs = getBooksObs().then(obs => {
		let aux = obs.map(obj => {
			obj.img = "https://www.openbookpublishers.com/shopimages/sections/normal/Open-Bookpic.jpg";
			obj._id = obj.id;
			obj.available = `${obj.available} Available`;

			if (localStorage.getItem('logedIn') === 'true') {
				obj.actions = {'Borrow': rezerveBook}
			}

			delete obj.id;
			return obj;});
		document.getElementById('user-cards').data = {
			obs: aux,
		};
	});
}

const getCardsLogin = async () => {
	var obs = await getBooksObs();
	let aux = obs.map(obj => {
		obj.img = "https://www.openbookpublishers.com/shopimages/sections/normal/Open-Bookpic.jpg";
		obj._id = obj.id;
		obj.available= `${obj.available} Available`;
		obj.actions = {'Borrow': rezerveBook}
		delete obj.id;
		return obj;});
	data = {
		obs: aux,
	};
	return data;
}
const getCardsLogout = async () => {
	var obs = await getBooksObs();
	let aux = obs.map(obj => {
		obj.img = "https://www.openbookpublishers.com/shopimages/sections/normal/Open-Bookpic.jpg";
		obj._id = obj.id;
		obj.available= `${obj.available} Available`;
		delete obj.id;
		return obj;});
	data = {
		obs: aux,
	};
	return data;
}

const rezerveBook = (bookId) => {
	fetch(`http://localhost:8080/books/${bookId}/${parseJwt(localStorage.getItem('jwt')).id}`, 
		{method: 'POST', credential: 'same-origin'})
			.then(x => x.json())
			.then(x => {console.log(x)
				if (x.msg === 'Succes') {
				
							document.getElementById('succes-modal').toggle();
							getCardsLogin().then(data => {
							document.getElementById('user-cards').free();
							document.getElementById('user-cards').render(data);
	});
				}
			});
	
}

const initLogIn = () => {
		const form  = {fields: [
			{
				type: 'email',
				label: 'Email',
				placeholder: 'email',
				name: 'email',
				id: 'login_email'
			},
			{
				type: 'password',
				label: 'Password',
				placeholder: 'password',
				name: 'pass',
				id: 'login_pass'
			}
		],
			action: {name: 'Log in', action: (inputs) => {
				let email = inputs.email.value;
				let pass = inputs.pass.value;
				fetch('http://localhost:8080/authentificate', 
					{method: 'POST', body: JSON.stringify({email: email, pass: pass})})
					.then(x => x.json())
					.then(x => {
						if (x.msg == 'Error') {
							document.getElementById('error-modal').toggle();
						} else if (x.msg == 'Succes') {
							localStorage.setItem('jwt', x.jwt);
							localStorage.setItem('logedIn', true);
							setCookie('jwt', x.jwt, 10);
							document.getElementById('log-in-modal').toggle();
							document.getElementById('succes-modal').toggle();
							login();
						}
					});
				return false;
			}}
		};
		
		document.getElementById('login-form').data = form;
}

function setCookie(cname, cvalue, exdays) {
	  var d = new Date();
	  d.setTime(d.getTime() + (exdays*24*60*60*1000));
	  var expires = "expires="+ d.toUTCString();
	  document.cookie = cname + "=" + cvalue + ";" + expires + ";path=/";
}


const login = () => {
	initNavbarLogin();
	navbar.render(navbar.data);
	getCardsLogin().then(data => {
		document.getElementById('user-cards').free();
		document.getElementById('user-cards').render(data);
	});
}

const logout = () => {
	localStorage.setItem('jwt', '');
	localStorage.setItem('logedIn', false);
	document.cookie = `jwt=; expires=Thu, 01 Jan 1970 00:00:00 UTC;`;

	let navbar = initNavbar();
	navbar.render(navbar.data);
	getCardsLogout().then(data => {
		document.getElementById('user-cards').free();
		document.getElementById('user-cards').render(data);
	});
}

const app = () => {
	initNavbar();
	initCards();
	initLogIn();

	if (localStorage.getItem('logedIn') === 'true') {
		login();
		getCardsLogin().then(data => {
			console.log(data);
			document.getElementById('user-cards').free();
			document.getElementById('user-cards').render(data);
		});
	}

}

app();




function parseJwt (token) {
	var base64Url = token.split('.')[1];
	var base64 = base64Url.replace('-', '+').replace('_', '/');
	return JSON.parse(window.atob(base64));
};
