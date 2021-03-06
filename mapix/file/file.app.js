/**
 * Mapix File Application
 * @author IRCF
 * @version 1.0.0
 */

// App model
Ext.define('Mapix.App.File', {
	extend: 'Mapix.App',
	constructor : function(config){
		this.model = Ext.create('Mapix.App.File.Store',config);
		this.view = Ext.create('Mapix.App.File.Icons',{store:this.model});
		Mapix.instance.editor.add(this.view).show();
	}
});

// Store model
Ext.define('Mapix.App.File.Store', {
	extend: 'Ext.data.XmlStore',
	base: '../file/',
	constructor: function(config){
		this.superclass().constructor.call(this, Ext.apply({
			autoLoad: true,
			url: this.base,
			record: 'file',
			fields: [
				{name: 'name', mapping: '@name'},
				{name: 'type', mapping: '@type'},
				{name: 'size', mapping: '@size'},
				{name: 'created', mapping: '@created'},
				{name: 'modified', mapping: '@modified'},
				{name: 'hidden', mapping: '@hidden'},
				{name: 'locked', mapping: '@locked'},
				{name: 'uri', mapping: '@uri'}
			]
		},config));
	},
	load: function(config){
		if (config && config.file) this.proxy.setUrl(this.base + config.file, false);
		this.superclass().load.call(this, config);
	}
});

// Icons view
Ext.define('Mapix.App.File.Icons', {
	extend: 'Ext.Panel',
	cls: 'icons',
	title: 'Files',
	closable: false,
	initComponent: function() {
		this.items = new Ext.DataView({
			itemSelector: 'div.file',
			overClass: 'x-view-selector',
			style: 'overflow:auto;height:100%',
			multiSelect: true,
			//plugins: new Ext.DataView.DragSelector({dragSafe:true}),
			store: this.store,
			tpl: new Ext.XTemplate(
				'<tpl for=".">',
				'<div id="{name}" class="file {type} {hidden}">',
				// TODO '<span class="image"><img src="{uri}"/></span>',
				'<span class="name">{name}</span>',
				// TODO '<span class="locked">{locked}</span>',
				'</div>',
				'</tpl>'
			),
			listeners: {
				dblclick: {fn:this.load, scope:this}
			}
		});
		this.superclass().initComponent.apply(this, arguments);
	},
	load: function(){
		var file = this.items.items[0].getSelectedRecords()[0];
		if (file) this.store.load({file:file.data.uri});
	}
});

// TODO Tree view
/*
Ext.define('Mapix.App.File.Tree', {
	extend: 'Ext.ux.tree.TreeGrid',
	cls: 'tree',
	title: 'File explorer',
	enableDD: true,
	initComponent: function() {
		this.columns = [{
			header: 'Name',
			dataIndex: 'name'
		},{
			header: 'Type',
			dataIndex: 'type'
		},{
			header: 'Size',
			dataIndex: 'size'
		}];
		this.superclass().initComponent.apply(this, arguments);
	}
});
*/
