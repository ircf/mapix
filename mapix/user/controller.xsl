<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet  version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:session="exslt://mapix/core/session">
	<xsl:output omit-xml-declaration="yes" indent="no"/>

	<!-- User login controller -->
	<xsl:template name="user-login">
		<xsl:param name="users"/>
		<xsl:param name="login"/>
		<xsl:param name="password"/>
		<!-- TODO Match user into users file and save session variable and/or HTTP header if found -->
		<xsl:variable name="user" select="document($users)"/>
	</xsl:template>

</xsl:stylesheet>
