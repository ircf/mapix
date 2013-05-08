<?xml version="1.0" encoding="utf-8"?>
<!-- TODO Implement credentials -->
<xsl:stylesheet  version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:http="exslt://modules/core/http"
	xmlns:image="exslt://modules/images/image">

	<xsl:include href="exslt://modules/file/file"/>

	<xsl:output omit-xml-declaration="yes" indent="no"/>

	<xsl:template match="http:request[http:method='get']">
		<xsl:value-of select="image:get(http:virtual-uri)" disable-output-escaping="yes"/>
	</xsl:template>

	<xsl:template match="http:request[http:method='post']">
		<xsl:value-of select="image:post(http:virtual-uri)" disable-output-escaping="yes"/>
	</xsl:template>

	<xsl:template match="http:request[http:method='put']">
		<xsl:value-of select="image:put(http:virtual-uri)" disable-output-escaping="yes"/>
	</xsl:template>

	<xsl:template match="http:request[http:method='transform']">
		<xsl:value-of select="image:transform(http:virtual-uri,http:parameter)" disable-output-escaping="yes"/>
	</xsl:template>

</xsl:stylesheet>
