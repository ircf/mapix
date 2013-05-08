<?xml version="1.0" encoding="utf-8"?>
<!-- TODO Implement credentials -->
<xsl:stylesheet  version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:http="exslt://mapix/core/http"
	xmlns:file="exslt://mapix/file/file">

	<xsl:include href="exslt://mapix/file/file"/>

	<xsl:output indent="no"/>

	<xsl:template match="http:request[http:method='get']">
		<http:header name="content-type">text/xml</http:header>
		<xsl:copy-of select="file:get(http:virtual-uri)" disable-output-escaping="yes"/>
	</xsl:template>

	<xsl:template match="http:request[http:method='post']">
		<xsl:value-of select="file:post(http:virtual-uri)" disable-output-escaping="yes"/>
	</xsl:template>

	<xsl:template match="http:request[http:method='put']">
		<xsl:value-of select="file:put(http:virtual-uri)" disable-output-escaping="yes"/>
	</xsl:template>

</xsl:stylesheet>
