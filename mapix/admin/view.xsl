<?xml version="1.0"?>
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:lang="exslt://mapix/lang"
	xmlns:user="exslt://mapix/user"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://mapixcms.org/schemas/stylesheet.xsd"
	exclude-result-prefixes="user lang xsi">
	<xsl:output
		method="xml"
		doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd"
		doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN"
		indent="no"
		encoding="utf-8" />

	<!-- Admin template -->
	<xsl:template name="admin">
		<xsl:param name="lang" select="'en'"/>
		<xsl:param name="scripts"/>
		<xsl:param name="stylesheets"/>
		<xsl:param name="messages"/>
		<html xml:lang="{$lang}" lang="{$lang}">
			<head>
				<title><xsl:value-of select="lang:__('admin',$messages)"/></title>
				<meta http-equiv="content-type" content="text/html; charset=utf-8" />
				<link rel="shortcut icon" href="images/favicon.ico"/>
        <link href="http://cdn.sencha.com/ext/gpl/4.2.0/resources/css/ext-all.css" rel="stylesheet" />
        <script src="http://cdn.sencha.com/ext/gpl/4.2.0/ext-all.js"></script>
				<link rel="stylesheet" type="text/css" href="style.css"/>
				<xsl:comment><![CDATA[ [if IE]><link rel="stylesheet" type="text/css" href="iefix.css"/><![endif] ]]></xsl:comment>
				<script type="text/javascript" src="script.js"></script>
				<xsl:for-each select="$scripts//file">
					<script type="text/javascript" src="{@uri}"></script>
				</xsl:for-each>
				<xsl:for-each select="$stylesheets//file">
					<link rel="stylesheet" type="text/css" href="{@uri}"/>
				</xsl:for-each>
			</head>
			<body>
				<noscript>
					<xsl:value-of select="lang:__('noscript',$messages)"/>
				</noscript>
				<div></div>
			</body>
		</html>
	</xsl:template>

	<!-- Header template -->
	<xsl:template name="header">
		<xsl:param name="lang"/>
		<xsl:param name="user"/>
		<xsl:param name="packages-available"/>
		<xsl:param name="packages-enabled"/>
		<xsl:param name="messages"/>
		<h1><span>Mapix CMS</span></h1>
		<h2><xsl:value-of select="lang:__('admin',$messages)"/></h2>
		<div class="infos">
			<p id="version">
				<a href="#" onclick="Mapix.instance.load(null,new Mapix.App.Package())">
					<!--TODO Intersect $packages-available and $packages-enabled -->
					<!--<xsl:if test="$packages-available/package[@name=$packages-enabled/package/@name and @version!=$packages-enabled/package/@version]">
						<xsl:attribute name="class">upgrade</xsl:attribute>
					</xsl:if>-->
					<xsl:value-of select="concat(lang:__('version',$messages),' ')"/>
					<span title="{lang:__('core',$messages)}"><xsl:value-of select="$packages-enabled/package[@name='core']/@version"/></span>
					/
					<span title="{lang:__('admin',$messages)}"><xsl:value-of select="$packages-enabled/package[@name='admin']/@version"/></span>
				</a>
			</p>
			<xsl:apply-templates select="user:profile">
				<xsl:with-param name="user" select="$user"/>
			</xsl:apply-templates>
			<xsl:call-template name="lang:menu">
				<xsl:with-param name="lang" select="$lang"/>
			</xsl:call-template>
		</div>
	</xsl:template>
</xsl:stylesheet>
