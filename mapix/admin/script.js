/**
 * Mapix CMS API
 * @author IRCF
 * @version 1.0.0
 */

// Classes
Ext.define('Mapix', {
	statics: {
		instance: null
	},
	constructor: function(config){
		Ext.create('Ext.container.Viewport', {
			layout: 'border',
			items: [ 
				this.header = Ext.create('Mapix.Header'),
				this.explorer = Ext.create('Mapix.Explorer'),
				this.editor = Ext.create('Mapix.Editor')
			]
		});
		this.self.instance = this;
		this.load();
	},
	// TODO Debug
	// TODO Implement application detection depending on file type
	load: function(file,app){
		if (typeof file == 'undefined') file = '';
		if (typeof app == 'undefined') app = Ext.create('Mapix.App.Login');
		app.load({file:file});
	}
});

// Header panel
Ext.define('Mapix.Header', {
	extend: 'Ext.Panel',
	id: 'header',
	region: 'north',
	autoHeight: true,
	autoLoad: {
		url: 'header',
		callback: function(){
			Mapix.instance.doLayout()
		}
	}
});

// Explorer panel
Ext.define('Mapix.Explorer', {
	extend: 'Ext.TabPanel',
	id: 'explorer',
	xtype: 'tabpanel',
	region: 'west',
	width: '20%',
	split: true,
	collapsible: true,
	collapsed: true
});

// Editor panel
Ext.define('Mapix.Editor', {
	extend: 'Ext.TabPanel',
	id: 'editor',
	xtype: 'tabpanel',
	region: 'center'
});

// Application model
Ext.define('Mapix.App', {
	extend: 'Object',
	constructor: function(){
	}
});

// Initialization
Ext.onReady(function(){
	Ext.create('Mapix');
});
