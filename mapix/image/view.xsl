<?xml version="1.0"?>
<!-- Mapix CMS image editor XSL template -->
<xsl:stylesheet version="1.0"
	xmlns:m="http://mapixcms.org/functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://mapixcms.org/schemas/stylesheet.xsd"
	exclude-result-prefixes="m xsi">
	<xsl:output
		method="xml"
		indent="no"
		encoding="utf-8"
		omit-xml-declaration="yes"/>
	<xsl:include href="../lang/template.xsl"/>
	<!-- Document -->
	<xsl:template match="/image">
		<!-- TODO Display error message if image not found -->
		<xsl:if test="image">				
			<img src="{image/@name}" alt="{image/@name}"/>
		</xsl:if>
	</xsl:template>
	<!-- Menu -->
	<xsl:template match="/menu">
		<li>
			<span><xsl:value-of select="m:translate('resizeImage')"/></span>
			<form method="transform" action="image/{image/@name}">
				<fieldset id="resize">
					<legend><xsl:value-of select="m:translate('resizeImage')"/></legend>
					<p>
						<input type="hidden" name="resizeWidth" id="resizeWidth" value="{image/@width}"/>
						<span id="resizeTrack"><span id="resizeHandle"></span></span>
						<label><input type="text" name="resizePercent" id="resizePercent" value="100"/> %</label>
					</p>
					<p>
						<input type="button" value="{m:translate('cancel')}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="button" value="{m:translate('resizeImage')}" onclick="addNode()"/>
					</p>
				</fieldset>
			</form>
		</li>
		<li>
			<span><xsl:value-of select="m:translate('cropImage')"/></span>
			<form method="transform" action="image/{image/@name}">
				<fieldset id="crop">
					<legend><xsl:value-of select="m:translate('cropImage')"/></legend>
					<p>
						<label><xsl:value-of select="m:translate('left')"/> : <input type="text" name="cropX" id="cropX" value="0"/></label>
						<label><xsl:value-of select="m:translate('top')"/> : <input type="text" name="cropY" id="cropY" value="0"/></label>
						<label><xsl:value-of select="m:translate('width')"/> : <input type="text" name="cropWidth" id="cropWidth" value="{image/@width}"/></label>
						<label><xsl:value-of select="m:translate('height')"/> : <input type="text" name="cropHeight" id="cropHeight" value="{image/@height}"/></label>
					</p>
					<p>
						<input type="button" value="{m:translate('cancel')}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="button" value="{m:translate('cropImage')}" onclick="addNode()"/>
					</p>
				</fieldset>
			</form>
		</li>		
		<li>
			<span><xsl:value-of select="m:translate('rotateImage'])"/></span>
			<form method="transform" action="image/{image/@name}">
				<fieldset id="rotation">
					<legend><xsl:value-of select="m:translate('rotateImage'])"/></legend>
					<p>
						<label id="r0"><input type="radio" name="rotation" value="0" checked="checked"/><span>0</span></label>										
						<label id="r90"><input type="radio" name="rotation" value="270"/><span>90</span></label>
						<label id="r180"><input type="radio" name="rotation" value="180"/><span>180</span></label>
						<label id="r270"><input type="radio" name="rotation" value="90"/><span>270</span></label>
					</p>
					<p>
						<input type="button" value="{m:translate('cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="button" value="{m:translate('rotateImage'])}" onclick="addNode()"/>
					</p>
				</fieldset>						
			</form>
		</li>
	</xsl:template>
</xsl:stylesheet>
