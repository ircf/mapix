<?xml version="1.0"?>
<!-- This template transforms a Gallery document into a HTML document -->
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:mxf="http://mapixcms.org/functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://mapixcms.org/schemas/gallery.xsd"
	exclude-result-prefixes="mxf xsi">
	<xsl:output omit-xml-declaration="yes"/>
	<xsl:include href="../lang/template.xsl"/>
	<xsl:template match="/*">
		<html xml:lang="{mxf:language()}" lang="{mxf:language()}">
			<head>
				<xsl:copy-of select="gallery/title"/>
				<script type="text/javascript" src="../mootools/mootools.js"></script>	
				<script type="text/javascript" src="../mootools/mootools-more.js"></script>
				<script type="text/javascript" src="../lightbox/lightbox.js"></script>
				<link rel="stylesheet" type="text/css" href="../lightbox/lightbox.css"/>
			</head>
			<body>
				<p><xsl:value-of select="gallery/text"/></p>
				<div id="gallery">				
					<ul>
						<xsl:for-each select="gallery/media">
							<li>
								<xsl:if test="(position() mod 3) = 1"><xsl:attribute name="class">separator</xsl:attribute></xsl:if>
								<h2><xsl:value-of select="./title"/></h2>
								<p><xsl:value-of select="./text" disable-output-escaping="yes"/></p>
								<div><a href="{@url}" rel="lightbox[gallery]"><img src="{@url}" alt="{./title}"/></a></div>
							</li>
						</xsl:for-each>
					</ul>
				</div>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
