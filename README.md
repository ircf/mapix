Mapix
=====

Mapix is a try to implement a web framework and CMS based on XSL and XML.

WARNING : This is a work in progress. Conventions and mechanisms described below may not match the actual version.

Mapix framework
---------------

A mapix application is composed of four components :

* `mapix` directory which contains distributed packages
* `.htaccess` file which rewrites URLs to mapix core handler
* `controller.xsl` file which contains XSL templates to define routes/controllers for your application
* your application files and/or custom packages

Mapix framework is based on the following principles :

### Package everything

* Any concept in your application should be defined in a package.
* A package is a single directory, containing a `package.xml` file.
* The `package.xml` file uses the package XML format described in the `mapix/package/package.xsd` file.
* Packages can contain other packages (sub-package = sub-directory with package.xml)
* The only required package is `mapix/core`.

### Physical vs virtual path

Mapix will automatically execute the nearest `controller.xsl` file depending on the requested URL. For that purpose any URI is composed of two parts :

* The physical path : the part of URI which matches real files.
* The virtual path : the part of URI which does NOT match real files.

For example, `/foo/bar` would execute `/controller.xsl`, whereas `/mapix/tests/foo/bar` would execute `/mapix/tests/controller.xsl` file.

### MVC

* Models : XSL templates/functions (`model.xsl` or `whatever.model.xsl`) or native PHP model classes (`whatever.php`)
* Views : XSL templates (`view.xsl` or `whatever.view.xsl`)
* Controllers : XSL templates (`controller.xsl` or `whatever.controller.xsl`)

### EXSLT

* Mapix uses EXSLT to enable native (PHP) class loading and method calling.
* Classes can be loaded with `<xsl:include href="exslt://path/to/native/class"/>`, `.php` should be ommited.
* `mapix/core` classes are automatically loaded when `controller.xsl` is executed.
* Methods can be executed with the XPath expression `class:method(...)`.
* See `mapix/tests/controller.xsl` for examples.

Mapix CMS
---------

Mapix CMS is built on top of Mapix framework. It consists in many packages :

* `mapix/admin` : administration site
* `mapix/demo` : demonstration site
* `mapix/html` : HTML generic templates
* `mapix/themes` : HTML/CSS templates
* ...
