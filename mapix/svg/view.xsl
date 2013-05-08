<?xml version="1.0"?>
<!-- Mapix CMS SVG editor XSL template -->
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
	<xsl:template match="/svg">
		<xsl:if test="editor/data/*">
			<xsl:copy-of select="editor/data/*"/>
		</xsl:if>
	</xsl:template>
	<!-- Menu -->
	<xsl:template match="/menu">
		<li>
			<span><xsl:value-of select="mxf:locale(messages/message[@id='svgMode'])"/></span>
			<form method="post" action="svg" onsubmit="saveMarkup();return true">
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<input type="hidden" id="data" name="data" value=""/>
				<fieldset>
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='svgMode'])"/></legend>
					<select name="mode" onchange="setMode(this.value)">
						<option selected="selected" value="select"><xsl:value-of select="mxf:locale(messages/message[@id='svgSelect'])"/></option>
						<option value="rect"><xsl:value-of select="mxf:locale(messages/message[@id='svgRectangle'])"/></option>
						<option value="roundrect"><xsl:value-of select="mxf:locale(messages/message[@id='svgRounded'])"/></option>
						<option value="ellipse"><xsl:value-of select="mxf:locale(messages/message[@id='svgEllipse'])"/></option>
						<option value="line"><xsl:value-of select="mxf:locale(messages/message[@id='svgLine'])"/></option>
					</select>
					<input type="button" value="{mxf:locale(messages/message[@id='svgDelete'])}" onclick="deleteShape()"/>
				</fieldset>
			</form>
		</li>
		<li>
			<span><xsl:value-of select="mxf:locale(messages/message[@id='svgFill'])"/></span>
			<form method="post" action="svg" onsubmit="saveMarkup();return true">
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<input type="hidden" id="data" name="data" value=""/>
				<fieldset>
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='svgFill'])"/></legend>
					<select id="fillcolor" onchange="setFillColor(this);">
						<option style="background-color:red;" value="red"></option>
						<option style="background-color:blue;" value="blue"></option>
						<option style="background-color:green;" value="green"></option>
						<option style="background-color:yellow;" value="yellow"></option>
						<option style="background-color:aqua;" value="aqua"></option>
						<option style="background-color:white;" value=""><xsl:value-of select="mxf:locale(messages/message[@id='svgNone'])"/></option>
					</select>
				</fieldset>
			</form>
		</li>
		<li>
			<span><xsl:value-of select="mxf:locale(messages/message[@id='svgLine'])"/></span>
			<form method="post" action="svg" onsubmit="saveMarkup();return true">
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<input type="hidden" id="data" name="data" value=""/>
				<fieldset>
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='svgLine'])"/></legend>
					<select id="linecolor" onchange="setLineColor(this);">
						<option style="background-color:black;" value="black"></option>
						<option style="background-color:red;" value="red"></option>
						<option style="background-color:blue;" value="blue"></option>
						<option style="background-color:green;" value="green"></option>
						<option style="background-color:yellow;" value="yellow"></option>
						<option style="background-color:aqua;" value="aqua"></option>
						<option style="background-color:white;" value=""><xsl:value-of select="mxf:locale(messages/message[@id='svgNone'])"/></option>
					</select>
					<select id="linewidth" onchange="setLineWidth(this);">
						<option value="1px">1px</option>
						<option value="2px">2px</option>
						<option value="3px">3px</option>
						<option value="5px">5px</option>
						<option value="7px">7px</option>
					</select>
				</fieldset>
			</form>
		</li>
		<li>
			<span><xsl:value-of select="mxf:locale(messages/message[@id='resizeImage'])"/></span>
			<form method="post" action="svg" onsubmit="saveMarkup();return true">
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<input type="hidden" id="data" name="data" value=""/>
				<fieldset id="resize">
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='resizeImage'])"/></legend>
					<label><xsl:value-of select="mxf:locale(messages/message[@id='width'])"/> : <input type="text" name="width" id="width" value="{editor/data/*/@width}"/></label>
					<label><xsl:value-of select="mxf:locale(messages/message[@id='height'])"/> : <input type="text" name="height" id="height" value="{editor/data/*/@height}"/></label>
					<input type="button" onclick="setSize()" value="{mxf:locale(messages/message[@id='refresh'])}"/>
				</fieldset>
			</form>
		</li>
	</xsl:template>
</xsl:stylesheet>
