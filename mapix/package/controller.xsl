<?xml version="1.0" encoding="utf-8"?>
<!-- Package manager controller -->
<!-- TODO Implement credentials -->
<xsl:stylesheet  version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://mapixcms.org/schemas/stylesheet.xsd"
	xmlns:http="exslt://mapix/core/http"
	xmlns:package="exslt://mapix/package/package">

	<xsl:output omit-xml-declaration="yes" indent="no"/>

	<!-- TODO Get one package (download) -->
	<xsl:template match="http:request[http:method='get']">
		Sorry, package download not implemented yet !
	</xsl:template>

	<!-- Get one or all package meta descriptors -->
	<xsl:template match="http:request[http:method='meta']">
		<xsl:copy-of select="package:meta(http:virtual-uri)"/>
	</xsl:template>

	<!-- Install/upgrade one or many packages -->
	<xsl:template match="http:request[http:method='put' or http:method='post']">
		<xsl:copy-of select="package:put(http:virtual-uri,http:parameter/packages)"/>
	</xsl:template>

	<!-- Delete one or many packages -->
	<xsl:template match="http:request[http:method='delete']">
		<xsl:copy-of select="package:delete(http:virtual-uri,http:parameter/packages)"/>
	</xsl:template>

</xsl:stylesheet>
