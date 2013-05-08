<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet  version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:http="exslt://mapix/core/http">
	<xsl:output omit-xml-declaration="yes" indent="no"/>

	<!-- Load theme controller -->
	<xsl:include href="mapix/themes/default/controller.xsl"/>

	<!-- Main controller -->
	<xsl:template match="http:request">
		<xsl:call-template name="page-controller">
			<xsl:with-param name="site" select="'mapix/demo'"/>
		</xsl:call-template>
	</xsl:template>

</xsl:stylesheet>
