<?xml version="1.0"?>
<!-- This file defines functions and templates for localization -->
<!-- TODO Move functions to controller.xsl and/or model.xsl -->
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"	
	xmlns:lang="exslt://mapix/lang"
	xmlns:http="exslt://mapix/core/http"
	xmlns:func="http://exslt.org/functions"
	xsi:noNamespaceSchemaLocation="../../xml/stylesheet.xsd"
	extension-element-prefixes="lang func">
	<xsl:output
		method="xml"
		indent="no"
		encoding="utf-8" />
	<!-- Read the language XML file -->
	<xsl:variable name="languages" select="document('languages.xml')/messages/message"/>
	<!-- Template to display the language menu -->
	<xsl:template name="lang:menu">
		<xsl:param name="lang" select="lang:detect()"/>
		<xsl:param name="page" select="''"/>
		<ul id="lang">
			<xsl:for-each select="$languages[@lang=$languages[1]/@lang and $lang='']|$languages[@lang=$lang and $lang!='']">
				<li><a href="/{@id}/{$page}" title="{.}">
					<xsl:value-of select="."/>
				</a></li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	<!-- Template to display a language select box -->
	<xsl:template name="lang:select">
		<xsl:param name="id"/>
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:param name="lang" select="lang:detect()"/>
		<xsl:element name="select">
			<xsl:if test="$id"><xsl:attribute name="id" select="$id"/></xsl:if>
			<xsl:if test="$name"><xsl:attribute name="name" select="$name"/></xsl:if>
			<xsl:attribute name="class">lang</xsl:attribute>
			<option value=""></option>
			<xsl:for-each select="$languages[@lang=$languages[1]/@lang and $lang='']|$languages[@lang=$lang and $lang!='']">
				<xsl:element name="option">
					<xsl:attribute name="value"><xsl:value-of select="@id"/></xsl:attribute>
					<xsl:if test="@id = $value">
						<xsl:attribute name="selected">true</xsl:attribute>
					</xsl:if>
					<xsl:value-of select="."/>
				</xsl:element>
			</xsl:for-each>
		</xsl:element>
	</xsl:template>
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
