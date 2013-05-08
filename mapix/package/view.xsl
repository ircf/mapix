<?xml version="1.0"?>
<!-- Mapix CMS package manager template -->
<xsl:stylesheet version="1.0"
	xmlns:mxf="http://mapixcms.org/functions"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	xsi:noNamespaceSchemaLocation="http://mapixcms.org/schemas/stylesheet.xsd"
	exclude-result-prefixes="mxf xsi">
	<xsl:output
		method="xml"
		indent="no"
		encoding="utf-8"
		omit-xml-declaration="yes"/>
	<xsl:include href="../../lang/template.xsl"/>
	<!-- Document -->	
	<xsl:template match="/package">
		<xsl:if test="editor[1]/message!='userError'">
			<form method="post" action="package" onsubmit="return packageSubmit('{mxf:locale(messages/message[@id='dataDownloaded'])}','{mxf:locale(messages/message[@id='dataRemoved'])}','{mxf:locale(messages/message[@id='packageSubmit'])}');">				
				<input type="hidden" name="command" value="install"/>
				<input type="hidden" name="data[0]" value="{input[@name='repository']}"/>
				<p>
					<label for="filter"><strong><xsl:value-of select="mxf:locale(messages/message[@id='show'])"/> : </strong></label>
					<select name="filter" id="filter">
						<option value="all">
							<xsl:if test="input[@name='filter']='all'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
							<xsl:value-of select="mxf:locale(messages/message[@id='allPackages'])"/>
						</option>
						<option value="installed">
							<xsl:if test="input[@name='filter']='installed'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
							<xsl:value-of select="mxf:locale(messages/message[@id='installedPackages'])"/>
						</option>
						<option value="upgrades">
							<xsl:if test="input[@name='filter']='upgrades'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
							<xsl:value-of select="mxf:locale(messages/message[@id='upgrades'])"/>
						</option>
						<option value="repository">
							<xsl:if test="input[@name='filter']='repository'"><xsl:attribute name="selected">selected</xsl:attribute></xsl:if>
							<xsl:value-of select="mxf:locale(messages/message[@id='repository'])"/>
						</option>
					</select>
				</p>
				<fieldset>
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='packageList'])"/></legend>
					<ul>
						<xsl:apply-templates select="editor/data/package"/>
					</ul>
				</fieldset>
			</form>
		</xsl:if>
	</xsl:template>
	<!-- Template to display a package in the list -->
	<xsl:template match="package">
		<xsl:variable name="this" select="."/>
		<xsl:variable name="upgrade" select="/package/editor[3]/data/package[@name=$this/@name and @version!=$this/@version]"/>
		<li>
			<xsl:attribute name="class">folded<xsl:if test="@install"> installed<xsl:if test="$upgrade"> upgrade</xsl:if></xsl:if></xsl:attribute>
			<xsl:choose>
				<xsl:when test="@install">
					<xsl:if test="$upgrade">
						<label><xsl:value-of select="concat(mxf:locale(../../../messages/message[@id='upgrade']),' (',mxf:locale(../../../messages/message[@id='version']),' ',/package/editor[3]/data/package[@name=$this/@name]/@version,') ')"/>
						<input type="checkbox" name="data[1][]" value="{concat(@install,@name)}" checked="checked" size="{$upgrade/@size}"/></label>
					</xsl:if>
					<label><xsl:value-of select="mxf:locale(../../../messages/message[@id='uninstall'])"/>
					<input type="checkbox" name="data[2][]" value="{concat(@install,@name)}" size="{@size}"/></label>
				</xsl:when>
				<xsl:otherwise>
					<label><xsl:value-of select="mxf:locale(../../../messages/message[@id='install'])"/>
					<input type="checkbox" name="data[3][]" value="{@name}" size="{@size}"/></label>
				</xsl:otherwise>
			</xsl:choose>
			<strong><xsl:value-of select="mxf:locale(name)"/></strong>
			<span class="version"><xsl:value-of select="concat(' (',mxf:locale(../../../messages/message[@id='version']),' : ',@version,', ',mxf:locale(../../../messages/message[@id='size']),' : ',round(@size div 1000),'K)')"/></span>
			<xsl:if test="@install">
				<em><xsl:value-of select="concat(' ',mxf:locale(../../../messages/message[@id='installedIn']),' ',@install)"/></em>
			</xsl:if>
			<p><xsl:value-of select="mxf:locale(description)"/></p>
		</li>
	</xsl:template>
	<!-- Function to tell whether an upgrade is available -->
	<xsl:template match="package">
		<xsl:variable name="this" select="."/>
		<xsl:variable name="upgrade" select="/package/editor[3]/data/package[@name=$this/@name and @version!=$this/@version]"/>
		<li>
			<xsl:attribute name="class">folded<xsl:if test="@install"> installed<xsl:if test="$upgrade"> upgrade</xsl:if></xsl:if></xsl:attribute>
			<xsl:choose>
				<xsl:when test="@install">
					<xsl:if test="$upgrade">
						<label><xsl:value-of select="concat(mxf:locale(../../../messages/message[@id='upgrade']),' (',mxf:locale(../../../messages/message[@id='version']),' ',/package/editor[3]/data/package[@name=$this/@name]/@version,') ')"/>
						<input type="checkbox" name="data[1][]" value="{concat(@install,@name)}" checked="checked" size="{$upgrade/@size}"/></label>
					</xsl:if>
					<label><xsl:value-of select="mxf:locale(../../../messages/message[@id='uninstall'])"/>
					<input type="checkbox" name="data[2][]" value="{concat(@install,@name)}" size="{@size}"/></label>
				</xsl:when>
				<xsl:otherwise>
					<label><xsl:value-of select="mxf:locale(../../../messages/message[@id='install'])"/>
					<input type="checkbox" name="data[3][]" value="{@name}" size="{@size}"/></label>
				</xsl:otherwise>
			</xsl:choose>
			<strong><xsl:value-of select="mxf:locale(name)"/></strong>
			<span class="version"><xsl:value-of select="concat(' (',mxf:locale(../../../messages/message[@id='version']),' : ',@version,', ',mxf:locale(../../../messages/message[@id='size']),' : ',round(@size div 1000),'K)')"/></span>
			<xsl:if test="@install">
				<em><xsl:value-of select="concat(' ',mxf:locale(../../../messages/message[@id='installedIn']),' ',@install)"/></em>
			</xsl:if>
			<p><xsl:value-of select="mxf:locale(description)"/></p>
		</li>
	</xsl:template>
</xsl:stylesheet>
