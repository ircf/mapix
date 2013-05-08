<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet  version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:http="exslt://mapix/core/http"
	xmlns:request="exslt://mapix/core/request"
	xmlns:tests="exslt://mapix/tests/tests">

	<xsl:output omit-xml-declaration="yes" indent="no"/>

	<xsl:include href="exslt://mapix/tests/tests"/>

	<xsl:template match="http:request">
    Test #1 : PHP method calls
		<xsl:value-of select="tests:helloWorld()"/><br/>
		<xsl:value-of select="tests:setName('mapix')"/>
		<xsl:value-of select="tests:hello()"/>
	</xsl:template>

	<xsl:template match="request:uri('(en|fr)&lt;lang&gt;/([a-z]*)&lt;page&gt;')">
    Test #2 : GET parameters
		<xsl:variable name="lang" select="request:get('lang')"/>
		<xsl:variable name="page" select="request:get('page')"/>
		Regexp test #1 : lang = <xsl:value-of select="$lang"/>, page = <xsl:value-of select="$page"/>
	</xsl:template>
	
</xsl:stylesheet>
