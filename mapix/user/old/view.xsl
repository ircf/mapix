<?xml version="1.0"?>
<!-- This template handles users functionnalities -->
<xsl:stylesheet version="1.0"
	xmlns="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://mapixcms.org/schemas/stylesheet.xsd"
	xmlns:mxf="http://mapixcms.org/functions"
	xmlns:func="http://exslt.org/functions"
	extension-element-prefixes="func">
	<xsl:output
		indent="no"
		omit-xml-declaration="yes"/>
	<!-- Identify user -->
	<xsl:template match="users">
		<xsl:apply-templates select="user[@name=//input[@name='user'] and @password=//input[@name='password']]" mode="user"/>
	</xsl:template>
	<!-- Display user infos -->
	<xsl:template match="user">
		<p id="user">
			<span title="{lang:__('user')}"><xsl:value-of select="@name"/></span>
			/ <span title="{lang:__('group')}"><xsl:value-of select="@group"/></span>
			<a href="logout"><xsl:value-of select="lang:__('logout')"/></a>
		</p>
	</xsl:template>
	<!-- User profile -->
	<xsl:template match="user" mode="user">
		<user name="{@name}" password="{@password}" group="{../@name}">
			<xsl:copy-of select="permission"/>
			<xsl:copy-of select="../permission"/>
		</user>
	</xsl:template>
	<!-- Function to determine whether user has permission on a file -->
	<!-- This function uses the input[@name='user'] as a global parameter -->
	<func:function name="mxf:permission">
		<xsl:param name="file"/>
		<xsl:for-each select="//input[@name='user']/user/permission">
			<xsl:if test="starts-with($file,substring-before(@url,'*')) and mxf:ends-with($file,substring-after(@url,'*'))">
				<xsl:variable name="permission" select="."/>
				<func:result select="$permission"/>
			</xsl:if>
		</xsl:for-each>
	</func:function>
	<!-- TODO Mode this function into a separate "xsl functions" module -->
	<func:function name="mxf:ends-with">
		<xsl:param name="a"/>
		<xsl:param name="b"/>
		<xsl:choose>
			<xsl:when test="substring($a,1+string-length($a)-string-length($b)) = $b">
				<func:result select="true()"/>
			</xsl:when>
			<xsl:otherwise>
				<func:result select="false()"/>
			</xsl:otherwise>
		</xsl:choose>
	</func:function>
	<!-- Login template -->
	<xsl:template match="login">
		<script type="text/javascript">
			Mapix.App.Login.failed = "<xsl:value-of select="lang:__('loginFailed')"/>";
			<xsl:if test="input[@name='user']/user">Mapix.App.Login.alreadyLogged = true;</xsl:if>
		</script>
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
