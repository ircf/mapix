<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet  version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://mapixcms.org/schemas/stylesheet.xsd"
	xmlns:http="exslt://mapix/core/http"
	xmlns:file="exslt://mapix/file/file"
	xmlns:package="exslt://mapix/package/package">

	<xsl:output omit-xml-declaration="yes" indent="no"/>

	<!-- Functions and templates -->
	<xsl:include href="exslt://mapix/core/http"/>
	<xsl:include href="exslt://mapix/file/file"/>
	<xsl:include href="exslt://mapix/package/package"/>
	<xsl:include href="../lang/view.xsl"/>
	<xsl:include href="../user/view.xsl"/>
	<xsl:include href="view.xsl"/>

	<!-- Admin controller -->
	<xsl:template match="http:request[http:virtual-uri='']">
		<xsl:call-template name="admin">
			<!--<xsl:with-param name="lang" select="http:session/http:lang"/>
			<xsl:with-param name="user" select="http:session/http:user"/>-->
			<xsl:with-param name="messages" select="document('messages.xml')"/>
			<xsl:with-param name="scripts" select="file:find('','pattern=/.*\.app\.js/')"/>
			<xsl:with-param name="stylesheets" select="file:find('','pattern=/.*\.app\.css/')"/>
		</xsl:call-template>
	</xsl:template>

	<!-- Header controller -->
	<xsl:template match="http:request[http:virtual-uri='header']">
		<xsl:call-template name="header">
			<!--<xsl:with-param name="lang" select="http:session/http:lang"/>
			<xsl:with-param name="user" select="http:session/http:user"/>-->
			<xsl:with-param name="messages" select="document('messages.xml')"/>
			<xsl:with-param name="packages-enabled" select="package:meta()"/>
			<!--<xsl:with-param name="packages-available" select="document('http://mapixcms.org/repository/')"/>-->
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
