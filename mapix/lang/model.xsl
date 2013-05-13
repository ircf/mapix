<?xml version="1.0"?>
<!-- This file defines functions for localization -->
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"	
	xmlns:lang="exslt://mapix/lang"
	xmlns:http="exslt://mapix/core/http"
	xmlns:func="http://exslt.org/functions"
	xsi:noNamespaceSchemaLocation="../../xml/stylesheet.xsd"
	extension-element-prefixes="lang func">
	<!-- Read the language XML file -->
	<xsl:variable name="languages" select="document('languages.xml')/messages/message"/>
	<!-- Function to get the localized content from an element (if exists) -->
	<func:function name="lang:__">
		<xsl:param name="id"/>
		<xsl:param name="messages" select="null"/>
		<xsl:param name="lang" select="lang:detect()"/>
		<xsl:choose>
			<xsl:when test="$messages!=null">
				<xsl:variable name="element" select="$messages/messages/message[@id=$id]"/>
				<xsl:choose>
					<xsl:when test="$element[@lang=$lang]">
						<func:result select="$element[@lang=$lang]"/>
					</xsl:when>
					<xsl:when test="$element[@xml:lang=$lang]">
						<func:result select="$element[@xml:lang=$lang]"/>
					</xsl:when>
					<xsl:otherwise>
						<func:result select="$element[1]"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<func:result select="$id"/>
			</xsl:otherwise>
		</xsl:choose>
	</func:function>
	<!-- Detect language from URI (/lang/...), default is first language from languages file -->
	<func:function name="lang:detect">
		<xsl:param name="uri" select="//http:request/http:uri"/>
		<xsl:param name="default" select="$languages[1]/@lang"/>
		<xsl:variable name="uri-lang" select="substring-before(substring-after(concat($uri,'/'),'/'),'/')"/>
		<xsl:choose>
			<xsl:when test="$languages[@lang=$uri-lang]"><func:result select="$uri-lang"/></xsl:when>
			<xsl:otherwise><func:result select="$default"/></xsl:otherwise>
		</xsl:choose>
	</func:function>
</xsl:stylesheet>
