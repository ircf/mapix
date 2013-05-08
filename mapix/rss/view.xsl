<?xml version="1.0"?>
<!-- This template transforms a RSS document into a HTML document -->
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:mxf="http://mapixcms.org/functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://mapixcms.org/schemas/rss.xsd"
	exclude-result-prefixes="mxf xsi">
	<xsl:output omit-xml-declaration="yes"/>
	<xsl:include href="../lang/template.xsl"/>
	<xsl:template match="/*">
		<html xml:lang="{mxf:language()}" lang="{mxf:language()}">
			<head>
				<xsl:copy-of select="mxf:locale(rss/channel/title)"/>
				<meta name="description" content="{rss/channel/description/*}"/>
			</head>
			<body>
				<div class="rss">
					<xsl:apply-templates select="rss/channel/item"/>
				</div>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="item">
		<div class="item">
			<p class="date"><xsl:value-of select="pubDate"/></p>
			<h2><xsl:value-of select="title"/></h2>
			<p><xsl:value-of select="description" disable-output-escaping="yes"/></p>
		</div>
	</xsl:template>
</xsl:stylesheet>
