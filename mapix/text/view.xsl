<?xml version="1.0"?>
<!-- Text file editor XSL template -->
<xsl:stylesheet version="1.0"
	xmlns:func="http://exslt.org/functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://mapixcms.org/xml/stylesheet.xsd"
	xmlns:lang="exslt://mapix/lang"
	xmlns:text="exslt://mapix/text"
	exclude-result-prefixes="lang text">
	<xsl:output
		method="xml"
		indent="no"
		encoding="utf-8"
		omit-xml-declaration="yes"/>
	<!-- Editor -->
	<xsl:template name="text:editor">
		<xsl:param name="file"/>
		<form method="post" action="text/{$file/@href}">
			<textarea name="content" class="{$file/@type}" cols="100" rows="26">
				<xsl:if test="$file/@locked"><xsl:attribute name="disabled">disabled</xsl:attribute></xsl:if>
				<xsl:value-of select="document($file/@href)"/>
			</textarea>
		</form>
	</xsl:template>
	<!-- Menu -->
	<xsl:template name="text:menu">
		<xsl:param name="messages"/>
		<li><span><xsl:value-of select="lang:__('save',$messages)"/></span></li>
		<li><span><xsl:value-of select="lang:__('saveAndClose',$messages)"/></span></li>
		<li onclick="$MA(this).tab.close()"><span><xsl:value-of select="lang:__('close',$messages)"/></span></li>
		<li onclick="$MA(this).document.loadRequest()"><span><xsl:value-of select="lang:__('refresh',$messages)"/></span></li>
	</xsl:template>
	<!-- Functions -->
	<func:function name="text:ends-with">
		<xsl:param name="haystack"/>
		<xsl:param name="needle"/>
		<func:return select="string-length(substring-before($haystack,$needle))!=0"/>
	</func:function>
</xsl:stylesheet>
