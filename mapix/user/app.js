// Login Application
// Mapix.App.Login
Ext.define('Mapix.App.Login', {
	extend: 'Mapix.App',
	constructor: function(config){
		this.model = new Mapix.App.Login.Store(config);
		this.view = new Mapix.App.Login.Form({store:this.model});
		Mapix.instance.editor.add(this.view).show();
	}
});
