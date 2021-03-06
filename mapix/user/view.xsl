<?xml version="1.0"?>
<!-- Mapix user HTML templates -->
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://mapixcms.org/schemas/stylesheet.xsd">
	<xsl:output
		indent="no"
		omit-xml-declaration="yes"/>
	<!-- Display user infos -->
	<xsl:template match="user">
		<p id="user">
			<span title="{lang:__('user')}"><xsl:value-of select="@name"/></span>
			/ <span title="{lang:__('group')}"><xsl:value-of select="@group"/></span>
			<a href="logout"><xsl:value-of select="lang:__('logout')"/></a>
		</p>
	</xsl:template>
	<!-- Login form template -->
	<!-- TODO Recode using Mapix 1.0 API -->
	<xsl:template match="login-form">
		<h1><xsl:value-of select="lang:__('loginTitle')"/></h1>
		<p><xsl:value-of select="lang:__('loginText')"/></p>
		<form method="post" action="login/submit">
			<fieldset>
				<p>
					<label><xsl:value-of select="lang:__('login')"/></label>
					<input type="text" name="user"/>
				</p>
				<p>
					<label><xsl:value-of select="lang:__('password')"/></label>
					<input type="password" name="password"/>
				</p>
				<p>
					<input class="button" type="submit" value="{lang:__('loginSubmit')}"/>
				</p>
			</fieldset>
		</form>
		<h1><xsl:value-of select="lang:__('openIdTitle')"/></h1>
		<p><xsl:value-of select="lang:__('openIdText')"/></p>
		<form method="post" action="login/openid">
			<input type="hidden" name="openid_mode" value="login"/>
			<fieldset>
				<p>
					<label><xsl:value-of select="lang:__('openIdLogin')"/></label>
					<input class="openid" type="text" name="openid_url" size="40"/>
				</p>
				<p>
					<input class="button" type="submit" value="{lang:__('loginSubmit')}"/>
				</p>
			</fieldset>
		</form>
	</xsl:template>
</xsl:stylesheet>
