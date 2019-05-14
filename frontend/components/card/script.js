class Card extends HTMLElement {
	
	constructor() {
		super();
	}

	render(data){
		console.log(data);
		this.shadowRoot.querySelector('.app-card__card').setAttribute('id', data._id);
		if (data.img) {
			this.shadowRoot.querySelector('.app-card__card').innerHTML = `<img src="${data.img}" alt="${data.alt}"\>`;
			delete data.img;
		}

		var html = '';

		if (data.more) {
			html += `<div class="app-card__more-container"><div class="more icon"></div></div><div class="app-card__more">${data.more}</div>`;
			delete data.more;
		}

		if (data.title) { 
			html += `<h4>${data.title}</h4>`;
			delete data.title;
		}
	
		const actions = data.actions;
		delete data.actions;

		let property;
		for (property in data) {
			if (property[0] != '_')
				html += `<p>${data[property]}</p>`;	
		}

		if (actions) {
			html += '<div class="app-card__actions">'
			for (property in actions) {
				html += `<a id="app-card__action-${property}">${property}</a>`;
			}
			html += '</div>';
		}

		this.shadowRoot.querySelector('.app-card__card').innerHTML += `<div class="app-card__container">${html}</div>`;

		for (property in actions) {
				let aux = property;
				this.shadowRoot.getElementById(`app-card__action-${property}`).addEventListener('click', e => {
				e.preventDefault();
				e.stopPropagation();
				actions[aux](data._id);
			});
		}

	}

	connectedCallback() {
		const shadowRoot = this.attachShadow({mode: 'open'});
		const template = currentDocument.querySelector('#app-card__template');
		const instance = template.content.cloneNode(true);

		shadowRoot.appendChild(instance);
		this.render(this.data);
	}

}
customElements.define('app-card', Card);
