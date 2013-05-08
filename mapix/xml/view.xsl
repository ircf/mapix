<?xml version="1.0"?>
<!-- Mapix CMS XML editor XSL template -->
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
	<xsl:include href="../functions.xsl"/>
	<!-- Document -->	
	<xsl:template match="/xml">
		<xsl:if test="editor/data/*">
			<form method="post" action="xml">
				<input type="hidden" name="command" value=""/>
				<input type="hidden" name="file" value="{input[@name='file']}"/>								
				<ul class="data">
					<xsl:for-each select="editor/data/*">
						<xsl:variable name="currentElement" select="."/>
						<xsl:call-template name="element">
							<xsl:with-param name="dataElement" select="."/>
							<xsl:with-param name="schemaElement" select="//element[@name=name($currentElement)]"/>
						</xsl:call-template>
					</xsl:for-each>
				</ul>
				<ul class="tooltips">
					<xsl:for-each select="editor/schema//element[@name]">
						<li id="a{@name}">
							<xsl:value-of select="mxf:locale(annotation/documentation)"/>
						</li>
					</xsl:for-each>
				</ul>
			</form>
		</xsl:if>
	</xsl:template>
	<!-- Menu -->
	<xsl:template match="/menu">
		<li><span><xsl:value-of select="mxf:locale(messages/message[@id='save'])"/></span></li>
		<li><span><xsl:value-of select="mxf:locale(messages/message[@id='saveAndClose'])"/></span></li>
		<li onclick="$MA(this).tab.close()"><span><xsl:value-of select="mxf:locale(messages/message[@id='close'])"/></span></li>
		<li onclick="$MA(this).document.loadRequest()"><span><xsl:value-of select="mxf:locale(messages/message[@id='refresh'])"/></span></li>
		<li class="context">
			<span><xsl:value-of select="mxf:locale(messages/message[@id='addNode'])"/></span>
			<form id="add" method="post" action="xml">
				<input type="hidden" name="command" value="add"/>
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<fieldset>
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='addNode'])"/></legend>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='nodeName'])"/></label>
						<xsl:choose>
							<xsl:when test="editor/schema">							
								<select name="newNodeName">
									<xsl:for-each select="editor/schema//element[@name]">
										<option value="{@name}"><xsl:value-of select="@name"/></option>
									</xsl:for-each>
								</select>
							</xsl:when>
							<xsl:otherwise>
								<input type="text" name="newNodeName"/>
							</xsl:otherwise>
						</xsl:choose>
					</p>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='nodePosition'])"/></label>
						<select name="newNodePosition">
							<option value="before"><xsl:value-of select="mxf:locale(messages/message[@id='beforeCurrentNode'])"/></option>
							<option value="after"><xsl:value-of select="mxf:locale(messages/message[@id='afterCurrentNode'])"/></option>
							<option value="into"><xsl:value-of select="mxf:locale(messages/message[@id='intoCurrentNode'])"/></option>
						</select>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="button" value="{mxf:locale(messages/message[@id='addNode'])}"/>
					</p>
				</fieldset>
				<xsl:if test="editor//schema/element">					
					<ul class="newNodes">
						<xsl:for-each select="editor/schema//element">
							<xsl:call-template name="element">
								<xsl:with-param name="dataElement" select="null"/>
								<xsl:with-param name="schemaElement" select="."/>
							</xsl:call-template>
						</xsl:for-each>
					</ul>
				</xsl:if>
			</form>
		</li>
		<li class="context">
			<span><xsl:value-of select="mxf:locale(messages/message[@id='removeNode'])"/></span>
			<form id="remove" method="post" action="xml">
				<input type="hidden" name="command" value="delete"/>
				<input type="hidden" name="file" value="{input[@name='file']}"/>									
				<fieldset>							
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='removeNode'])"/></legend>
					<p>
						<xsl:value-of select="mxf:locale(messages/message[@id='removeNodeConfirm'])"/>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="button" value="{mxf:locale(messages/message[@id='removeNode'])}"/>
					</p>
				</fieldset>
			</form>
		</li>
	</xsl:template>	
	<!-- Template for each element in the xml document -->
	<!-- TODO Complete and optimize specific input fields depending on the element type (date,integer,file...) -->
	<xsl:template name="element">
		<xsl:param name="dataElement"/>
		<xsl:param name="schemaElement"/>
		<xsl:variable name="elementName">
			<xsl:choose>
				<xsl:when test="$dataElement">
					<xsl:value-of select="name($dataElement)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$schemaElement/@name"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<!-- Element list item -->
		<xsl:element name="li">
			<xsl:attribute name="id">
				<xsl:value-of select="$elementName" />
			</xsl:attribute>
			<xsl:if test="$schemaElement/@class">
				<xsl:attribute name="class">
					<xsl:value-of select="$schemaElement/@class"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:choose>
				<xsl:when test="$dataElement/*">
					<span class="arrow subcontent" title="{mxf:locale(/folder/messages/message[@id='displaySubcontent'])}">
						<xsl:text> </xsl:text>
					</span>
				</xsl:when>
				<xsl:otherwise>
					<span class="arrow"><xsl:text> </xsl:text></span>
				</xsl:otherwise>
			</xsl:choose>
			<span class="content">
				<!-- Element name and tooltip, taken for the schemaElement if defined -->
				<label class="handle">
					<xsl:choose>
						<xsl:when test="$schemaElement/annotation/documentation">
							<a class="help" href="#a{$elementName}">
								<xsl:value-of select="$elementName"/>
							</a>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$elementName"/>
						</xsl:otherwise>
					</xsl:choose>
				</label>
				<!-- Attributes -->
				<!-- TODO XMLNS attributes are collected only for the document root -->
				<xsl:if test="name($dataElement/..)='data'">
					<xsl:for-each select="$dataElement/namespace::node()[name()!='xml']">
						<xsl:variable name="name">
							<xsl:if test="string-length(name()) &gt; 0">:</xsl:if>
							<xsl:value-of select="name()"/>
						</xsl:variable>
						<xsl:call-template name="attribute">
							<xsl:with-param name="name" select="concat('xmlns',$name)"/>
							<xsl:with-param name="value" select="."/>
						</xsl:call-template>
					</xsl:for-each>
				</xsl:if>
				<!-- Then look for other attributes -->
				<xsl:choose>
					<!-- If attributes are defined in the schemaElement, loop through them -->
					<xsl:when test="$schemaElement/complexType/attribute">
						<xsl:for-each select="$schemaElement[1]/complexType/attribute">
							<xsl:variable name="attributeName" select="@ref"/>
							<xsl:call-template name="attribute">
								<xsl:with-param name="name" select="@ref"/>
								<xsl:with-param name="value" select="$dataElement/@*[name()=$attributeName]"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:when>
					<!-- Else, loop through the existing attributes -->
					<xsl:otherwise>
						<xsl:for-each select="$dataElement/@*">
							<xsl:call-template name="attribute">
								<xsl:with-param name="name" select="name()"/>
								<xsl:with-param name="value" select="."/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
				<!-- Element content -->
				<xsl:choose>
					<xsl:when test="$schemaElement/@type='xsd:mixed'">
						<textarea cols="100" rows="5">
							<xsl:copy-of select="$dataElement/*|$dataElement/text()"/>
						</textarea>
					</xsl:when>
					<xsl:when test="$schemaElement/@type='xsd:string'">
						<input type="text" value="{$dataElement/text()}" size="80"/>
					</xsl:when>
					<xsl:when test="$schemaElement/@type='xsd:date'">
						<input class="date" type="text" value="{$dataElement/text()}" size="10"/>
					</xsl:when>
					<xsl:when test="$schemaElement/@type='xsd:integer'">
						<input class="integer" type="text" value="{$dataElement/text()}" size="10"/>
					</xsl:when>
					<xsl:when test="$schemaElement/@type = 'xsd:url'">
						<input class="url" type="text" value="{$dataElement/text()}" size="46"/>
						<a href="{concat($dirname,$dataElement/text())}" rel="xml"><xsl:value-of select="mxf:locale(/xml/messages/message[@id='edit'])"/></a>
					</xsl:when>
					<xsl:when test="$schemaElement/@type='xsd:boolean'">
						<xsl:element name="input">
							<xsl:attribute name="type">checkbox</xsl:attribute>
							<xsl:attribute name="value">true</xsl:attribute>
							<xsl:if test="$dataElement/text() = 'true'">
								<xsl:attribute name="checked">checked</xsl:attribute>
							</xsl:if>
						</xsl:element>
					</xsl:when>
					<xsl:when test="$dataElement/*">
						<ul class="hidden">
							<xsl:for-each select="$dataElement/*">
								<xsl:variable name="currentElement" select="."/>
								<xsl:call-template name="element">
									<xsl:with-param name="dataElement" select="."/>
									<xsl:with-param name="schemaElement" select="//element[@name=name($currentElement)]"/>
								</xsl:call-template>
							</xsl:for-each>
						</ul>
					</xsl:when>
					<xsl:when test="string-length($dataElement/text()) &gt; 0">
						<input type="text" value="{$dataElement/text()}" size="80"/>
					</xsl:when>
				</xsl:choose>
			</span>
		</xsl:element>
	</xsl:template>
	<!-- Template for generating an attribute label and input textfield-->
	<!-- TODO Use a common template to define inputs for elements and attributes (avoid duplicate HTML code) -->
	<xsl:template name="attribute">
		<xsl:param name="name"/>
		<xsl:param name="value"/>
		<xsl:variable name="schemaAttribute" select="//schema//attribute[@name=$name]"/>
		<span id="{$name}">
			<label><xsl:value-of select="$name"/></label>
			<xsl:choose>
				<xsl:when test="$name='lang'">
					<xsl:call-template name="languageSelect">
						<xsl:with-param name="name" select="$name"/>
						<xsl:with-param name="value" select="$value"/>
						<xsl:with-param name="lang" select="//input[@name='lang']"/>
					</xsl:call-template>
				</xsl:when>
				<xsl:when test="$schemaAttribute/@type = 'xsd:boolean'">
					<xsl:element name="input">
						<xsl:attribute name="type">checkbox</xsl:attribute>
						<xsl:attribute name="value">true</xsl:attribute>
						<xsl:if test="$value = 'true'">
							<xsl:attribute name="checked">checked</xsl:attribute>
						</xsl:if>
					</xsl:element>
				</xsl:when>
				<xsl:when test="$schemaAttribute/@type = 'xsd:integer'">
					<input class="integer" type="text" value="{$value}" size="10"/>
				</xsl:when>
				<xsl:when test="$schemaAttribute/@type = 'xsd:url'">
					<input class="url" type="text" value="{$value}" size="46"/>
					<a href="{concat($dirname,$value)}" rel="xml"><xsl:value-of select="mxf:locale(/xml/messages/message[@id='edit'])"/></a>
				</xsl:when>
				<xsl:otherwise>
					<input type="text" value="{$value}" size="50"/>
				</xsl:otherwise>
			</xsl:choose>
		</span>
	</xsl:template>
</xsl:stylesheet>
