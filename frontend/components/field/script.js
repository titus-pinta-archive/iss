class Field extends HTMLElement {
	
	constructor() {
		super();
	}

	render(data) {
		this.shadowRoot.querySelector('.app-field__container').innerHTML = 
			`<input id="${data.id}" name="${data.name}" type="${data.type}" placeholder="${data.placeholder}"/><label>${data.label}</label>`;
	}

	connectedCallback() {
		const shadowRoot = this.attachShadow({mode: 'open'});
		const template = currentDocument.querySelector('#app-field__template');
		const instance = template.content.cloneNode(true);

		shadowRoot.appendChild(instance);
		this.render(this.data);
	}

}
customElements.define('app-field', Field);
