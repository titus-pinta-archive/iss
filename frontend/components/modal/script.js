class Modal extends HTMLElement {
	
	constructor() {
		super();
	}

	render(data) {
		[].slice.call(this.children).map(child => {
			this.shadowRoot.querySelector('.app-modal__content').appendChild(child);
		});

		this.shadowRoot.querySelector('.app-modal__container').addEventListener('click', (e) => { this.toggle();});
		this.shadowRoot.querySelector('.app-modal__close').addEventListener('click', (e) => { 
			e.stopPropagation();
			this.toggle();});
		this.shadowRoot.querySelector('.app-modal__content').addEventListener('click', (e) => {
			e.stopPropagation();});
	}

	toggle() {
		this.shadowRoot.querySelector('.app-modal__container').classList.toggle('app-modal__hidden');	
	}

	connectedCallback() {
		const shadowRoot = this.attachShadow({mode: 'open'});
		const template = currentDocument.querySelector('#app-modal__template');
		const instance = template.content.cloneNode(true);

		shadowRoot.appendChild(instance);
		this.render(this.data);
	}

}
customElements.define('app-modal', Modal);
