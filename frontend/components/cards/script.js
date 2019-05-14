class Cards extends HTMLElement {
	
	constructor() {
		super();
	}

	render(data){
		data.obs.subscribe(obj => {
			var card = document.createElement('app-card');
			card.data = obj;
			this.shadowRoot.querySelector('.app-cards__container').appendChild(card);
		});
		if (data.addOne == true) {	
			const div = document.createElement('div');
			div.classList.toggle('app-cards__add');
			div.innerHTML = '<div>+</div>';
			this.shadowRoot.querySelector('.app-cards__container').appendChild(div);
			this.shadowRoot.querySelector('.app-cards__add').addEventListener('click', e => {
				e.preventDefault();
				e.stopPropagation();
				data.action();
			});
		}

	}

	free() {
		let node = this.shadowRoot.querySelector('.app-cards__container');
		while (node.hasChildNodes()) {
			    node.removeChild(node.lastChild);
		}
	}


	connectedCallback() {
		const shadowRoot = this.attachShadow({mode: 'open'});
		const template = currentDocument.querySelector('#app-cards__template');
		const instance = template.content.cloneNode(true);

		shadowRoot.appendChild(instance);
		this.render(this.data);
	}

}
customElements.define('app-cards', Cards);
