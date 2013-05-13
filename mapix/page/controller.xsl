<?xml version="1.0" encoding="utf-8"?>
<!-- Mapix default theme controller -->
<xsl:stylesheet  version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:http="exslt://mapix/core/http"
	xmlns:file="exslt://mapix/file/file"
	xmlns:lang="exslt://mapix/lang"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="../xml/stylesheet.xsd">

	<!-- Functions and templates -->
	<xsl:include href="exslt://mapix/file/file"/>
	<xsl:include href="../lang/view.xsl"/>
	<xsl:include href="view.xsl"/>

	<!-- Main controller -->
	<xsl:template name="page-controller">
		<xsl:param name="site"/>
		<xsl:param name="lang" select="lang:detect()"/>
		<xsl:variable name="content">
			<xsl:choose>
				<xsl:when test="http:virtual-uri='' or http:virtual-uri=lang:detect()"><xsl:value-of select="concat($lang,'/index.html')"/></xsl:when>
				<xsl:when test="file:exists(concat($site,'/',http:virtual-uri))"><xsl:value-of select="http:virtual-uri"/></xsl:when>
				<xsl:otherwise><xsl:value-of select="concat($lang,'/404.html')"/></xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:if test="$content=concat($lang,'/404.html')"><http:header>HTTP/1.0 404 Not Found</http:header></xsl:if>
		<xsl:call-template name="page-view">
			<xsl:with-param name="menu" select="document(concat('../../',$site,'/',$lang,'/menu.html'))"/>
			<xsl:with-param name="messages" select="document(concat('../../',$site,'/',$lang,'/messages.xml'))"/>
			<xsl:with-param name="content" select="document(concat('../../',$site,'/',$content))"/>
		</xsl:call-template>
		<!-- TODO Rewrite links (href/src) before output -->
	</xsl:template>

</xsl:stylesheet>
