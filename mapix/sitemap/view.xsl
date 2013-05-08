<?xml version="1.0"?>
<!-- This template transforms a Mapix menu document into a Google sitemap document -->
<xsl:stylesheet
	version="1.0"
	xmlns="http://www.google.com/schemas/sitemap/0.84"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://mapixcms.org/schemas/stylesheet.xsd"
	exclude-result-prefixes="xsi">
	<xsl:template match="/*">
		<urlset xmlns="http://www.google.com/schemas/sitemap/0.84">
			<xsl:apply-templates select="//xhtml:a"/>
		</urlset>
	</xsl:template>
	<xsl:template match="xhtml:a">
		<url>
			<loc><xsl:value-of select="//input[@name='HTTP_ROOT']"/><xsl:value-of select="@href"/></loc>
			<changefreq>weekly</changefreq>
		</url>
	</xsl:template>
</xsl:stylesheet>
