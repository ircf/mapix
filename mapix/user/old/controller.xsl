<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet  version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:http="exslt://mapix/core/http"
	xmlns:session="exslt://mapix/core/session">
	<xsl:output omit-xml-declaration="yes" indent="no"/>

	<!-- User controller -->
	<!-- TODO Use request:local-uri instead -->
	<xsl:template match="http:virtual-uri=''">
		<xsl:call-template name="page-controller">
			<xsl:with-param name="site" select="'mapix/demo'"/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>

<!-- Mapix admin map -->
<mapix xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://mapixcms.org/schemas/mapix.xsd">
	<page>
		<template url="template.xsl">
			<input type="session" name="lang"/>
			<input type="session" name="user"/>
			<content url="messages.xml"/>
		</template>
	</page>
	<page url="submit">
		<content url="../../users/session.php" method="post">
			<output name="command">set</output>
			<output name="variable">user</output>
			<output name="value">
				<template url="template.xsl">	
					<input type="post" name="user"/>
					<input type="post" name="password"/>
					<content url="../users.xml"/>
				</template>
			</output>
		</content>
	</page>
	<page url="openid">
		<content url="../../users/openid.php" method="post">
			<output name="openid_url">
				<input type="post" name="openid_url"/>
			</output>
			<output name="openid_mode">
				<input type="post" name="openid_mode"/>
			</output>
			<output name="openid_approved_url">
				<input type="server" name="REQUEST_URI"/>
			</output>
		</content>
	</page>
	<page url="logout">
		<content url="../../users/session.php" method="post">
			<output name="command">unset</output>						
			<output name="variable">user</output>
		</content>
		<header name="location">..</header>
	</page>
</mapix>
