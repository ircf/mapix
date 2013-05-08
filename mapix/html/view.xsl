<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet  version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml">
	<xsl:template name="page">
		<xsl:param name="content"/>
		<xsl:param name="lang" select="null"/>
		<html>
			<xsl:if test="$lang!=null"><xsl:attribute name="lang" select="$lang"/></xsl:if>
			<head>
				<xsl:copy-of select="$content//html:head/*"/>
			</head>
			<body>
				<xsl:for-each select="$content//html:body">
					<div class="content" id="content-{position()}">
						<xsl:copy-of select="*|text()"/>
					</div>	
				</xsl:for-each>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
