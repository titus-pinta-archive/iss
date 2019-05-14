class Form extends HTMLElement {
	
	constructor() {
		super();
	}

	render(data) {
		var f = {};

		for (var field in data.fields) {
			var app_field = document.createElement('app-field');
			app_field.data = data.fields[field];
			app_field.id = `field_${data.fields[field].id}`;
			this.shadowRoot.querySelector('#app-form__form').appendChild(app_field);
			f[data.fields[field].name] = app_field.shadowRoot.querySelector('input');
		}
		
		var submit = document.createElement('submit');
		submit.value = data.action.name;
		submit.innerHTML = data.action.name;
		submit.addEventListener('click', e => {
			e.preventDefault();
			e.stopPropagation();
			data.action.action(f);
		});
		submit.classList.toggle('app-form__submit');
		this.shadowRoot.querySelector('#app-form__form').appendChild(submit);

	}

	connectedCallback() {
		const shadowRoot = this.attachShadow({mode: 'open'});
		const template = currentDocument.querySelector('#app-form__template');
		const instance = template.content.cloneNode(true);

		shadowRoot.appendChild(instance);


		this.render(this.data);
	}

}
customElements.define('app-form', Form);
