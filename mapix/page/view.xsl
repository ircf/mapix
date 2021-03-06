<?xml version="1.0" encoding="utf-8"?>
<!-- Mapix default theme view -->
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:html="http://www.w3.org/1999/xhtml"
	xmlns:lang="exslt://mapix/lang"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="../../xml/stylesheet.xsd"
	exclude-result-prefixes="lang xsi">
	<xsl:output
		method="xml"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"
		doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN"
		encoding="utf-8"
		omit-xml-declaration="yes"
		indent="no"/>

	<!-- Page template -->
	<xsl:template name="page-view">
		<xsl:param name="lang" select="lang:detect()"/>
		<xsl:param name="menu" select="null"/>
		<xsl:param name="content" select="null"/>
		<xsl:param name="messages" select="null"/>
		<html xml:lang="{$lang}" lang="{$lang}">
			<head>
				<xsl:copy-of select="$content/html/head/*"/>
				<link rel="stylesheet" type="text/css" href="style.css"/>
				<link rel="shortcut icon" href="images/favicon.ico"/>
				<xsl:comment><![CDATA[ [if IE]><link rel="stylesheet" type="text/css" href="iefix.css"/><![endif] ]]></xsl:comment>
			</head>
			<body>
				<div id="page">
					<div id="header">
						<xsl:value-of select="lang:__('header',$messages)"/>
						<xsl:call-template name="lang:menu">
							<xsl:with-param name="lang" select="$lang"/>
						</xsl:call-template>
						<xsl:copy-of select="$menu//html:body/*"/>
					</div>
					<div id="content">
						<xsl:for-each select="$content/html:html">
							<div class="content" id="content-{position()}">
								<h1><xsl:value-of select="html:head/html:title"/></h1>
								<xsl:apply-templates select="html:body/html:*" />
							</div>
						</xsl:for-each>
					</div>
					<div id="footer">
						<xsl:copy-of select="$menu//html:body/*"/>
						<xsl:value-of select="lang:__('footer',$messages)"/>
					</div>
				</div>
			</body>
		</html>
	</xsl:template>
	<!-- Copy a XHTML element without additional namespaces -->
	<!-- TODO Generalize and create a EXSLT function like copy-exclude-ns() -->
	<!--<xsl:template match="*">
		<xsl:element name="{name()}" namespace="{namespace-uri()}">
			<xsl:copy-of select='@*'/>
			<xsl:apply-templates select='node()'/>
		</xsl:element>
	</xsl:template>-->
</xsl:stylesheet>
