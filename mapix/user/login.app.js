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

Ext.define('Mapix.App.Login.Form', {
    extend: 'Ext.form.Panel',
    url: '../user/login',
    items: [
        // TODO Define form fields
    ],
    buttons: [
        {
            text: 'Submit',
            handler: function() {
                var form = this.up('form').getForm(); // get the basic form
                if (form.isValid()) { // make sure the form contains valid data before submitting
                    form.submit({
                        success: function(form, action) {
                           Ext.Msg.alert('Success', action.result.msg);
                        },
                        failure: function(form, action) {
                            Ext.Msg.alert('Failed', action.result.msg);
                        }
                    });
                } else { // display error alert if the data is invalid
                    Ext.Msg.alert('Invalid Data', 'Please correct form errors.')
                }
            }
        }
    ]
});
