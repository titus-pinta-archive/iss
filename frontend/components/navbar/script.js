const currentDocument = document.currentScript.ownerDocument;
class Navbar extends HTMLElement {
	
	constructor() {
		super();
	}

	render(data) {
		var logoHtml = '';
		if (data.logo)
			if (data.logo.type === 'text')
				logoHtml = `<h2>${data.logo.value}</h2>`;
	
		var linksHtml = '';
		if (data.links)
			linksHtml = data.links.map((link) => `<li id="app-navbar__link-${link.text.replace(' ', '-')}"><a href="${link.href}">${link.text}</a></li>`).reduce((acc, cur) => acc + cur, '');

		this.shadowRoot.querySelector('.app-navbar__logo').innerHTML = logoHtml;
		this.shadowRoot.querySelector('.app-navbar__links').innerHTML = linksHtml;
		this.shadowRoot.querySelector('.app-navbar__search-container').style.setProperty('display', 'none');

		this.shadowRoot.querySelector('.app-navbar__nav').style.setProperty('transition', 'all 0.2s ease-in'); 
		this.shadowRoot.querySelector('.app-navbar__hidden').style.setProperty('transition', 'visibility 0.2s ease-in'); 

		this.shadowRoot.querySelector('.app-navbar__menu-container').addEventListener('click', e => {
			this.shadowRoot.querySelector('.app-navbar__nav').classList.toggle('app-navbar__active');
			this.shadowRoot.querySelector('.app-navbar__hidden').classList.toggle('app-navbar__active');
		});
		this.shadowRoot.querySelector('.app-navbar__hidden').addEventListener('click', e => {
			this.shadowRoot.querySelector('.app-navbar__nav').classList.toggle('app-navbar__active');
			this.shadowRoot.querySelector('.app-navbar__hidden').classList.toggle('app-navbar__active');
		});
	
		data.links.map((link) => {
			if (link.action) {
				this.shadowRoot.querySelector(`#app-navbar__link-${link.text.replace(' ', '-')}`).addEventListener('click', e => {
					e.preventDefault();
					e.stopPropagation();
					link.action();
				});
			}
		});


	}
	
	connectedCallback() {
		const shadowRoot = this.attachShadow({mode: 'open'});
		const template = currentDocument.querySelector('#app-navbar__template');
		const instance = template.content.cloneNode(true);

		shadowRoot.appendChild(instance);
		this.render(this.data);
	}

}

customElements.define('app-navbar', Navbar);
