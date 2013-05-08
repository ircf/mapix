<?xml version="1.0"?>
<!-- This template transforms a XForms document in a HTML doc into a HTML form (experimental) -->
<!-- TODO Implement XForms submission and output (will replace the static sendForm behavior) -->
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:mxf="http://mapixcms.org/functions"
	xmlns:xf="http://www.w3.org/2002/01/xforms"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://mapixcms.org/schemas/stylesheet.xsd"
	exclude-result-prefixes="mxf xsi">
	<xsl:output omit-xml-declaration="yes"/>
	<xsl:include href="../lang/template.xsl"/>
	<xsl:template match="/*">
		<html xml:lang="{mxf:language()}" lang="{mxf:language()}">
			<head>
				<xsl:copy-of select="xhtml:html/xhtml:head/xhtml:*"/>
			</head>
			<body>
				<xsl:if test="input[@name='submit'] = 'true'">
					<p class="message">
						<xsl:choose>
							<xsl:when test="sendForm/success='1'">
								<xsl:value-of select="mxf:locale(messages/message[@id='sendFormOk'])"/>
							</xsl:when>
							<xsl:otherwise>
								<xsl:value-of select="mxf:locale(messages/message[@id='sendFormError'])"/>
							</xsl:otherwise>
						</xsl:choose>
					</p>
				</xsl:if>
				<form method="post" action="{input[@name='REQUEST_URI']}">
					<fieldset>
						<xsl:for-each select="xhtml:html/xhtml:body/*">
							<xsl:choose>
								<xsl:when test="namespace-uri()='http://www.w3.org/2002/01/xforms'">
									<xsl:apply-templates select="."/>
								</xsl:when>
								<xsl:otherwise>
									<xsl:copy-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</fieldset>
				</form>
			</body>
		</html>
	</xsl:template>
	<xsl:template match="xf:model">
	</xsl:template>
	<xsl:template match="xf:input">
		<p>
			<label><xsl:value-of select="mxf:locale(xf:label)"/></label>
			<input type="text" name="{@ref}" value="" size="60"/>
		</p>
	</xsl:template>
	<xsl:template match="xf:textarea">
		<p>
			<label><xsl:value-of select="mxf:locale(xf:label)"/></label>
			<textarea name="{@ref}" cols="60" rows="10"></textarea>
		</p>
	</xsl:template>
	<xsl:template match="xf:submit">
		<p>
			<input type="submit" value="{mxf:locale(xf:label)}"/>
		</p>
	</xsl:template>
</xsl:stylesheet>
