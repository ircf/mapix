<?xml version="1.0"?>
<!-- This is the folder editor XSL template -->
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
	<xsl:include href="../lang/view.xsl"/>
	<xsl:include href="../users/view.xsl"/>
	<xsl:variable name="view">
		<xsl:choose>
			<xsl:when test="string-length(//input[@name='view']) = 0">icons</xsl:when>
			<xsl:otherwise><xsl:value-of select="//input[@name='view']"/></xsl:otherwise>
		</xsl:choose>
	</xsl:variable>
	<!-- Folder Document -->
	<xsl:template match="/folder">
		<xsl:if test="editor[1]/data/*">
			<ul class="{$view}" rel="{input[@name='file']}">
				<li class="header">
					<span class="arrow"><xsl:text> </xsl:text></span>
					<span class="name"><xsl:value-of select="mxf:locale(messages/message[@id='fileName'])"/></span>
					<span class="size"><xsl:value-of select="mxf:locale(messages/message[@id='fileSize'])"/></span>
					<span class="created"><xsl:value-of select="mxf:locale(messages/message[@id='dateCreated'])"/></span>
					<span class="modified"><xsl:value-of select="mxf:locale(messages/message[@id='dateModified'])"/></span>
				</li>
				<xsl:apply-templates select="editor[1]/data/file"/>
			</ul>
		</xsl:if>
	</xsl:template>
	<!-- Folder Menu -->
	<xsl:template match="/menu">
		<li>
			<span><xsl:value-of select="mxf:locale(messages/message[@id='createFile'])"/></span>
			<form id="create" method="post" action="services/folder.php">
				<input type="hidden" name="command" value="create"/>
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<fieldset>
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='createFile'])"/></legend>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='fileName'])"/></label>
						<input type="text" name="data[0]"/>
					</p>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='fileType'])"/></label>
						<select name="data[1]" onchange="this.form['data[2]'].disabled=(this.selectedIndex>0)">
							<option value="document"><xsl:value-of select="mxf:locale(messages/message[@id='xmlDocument'])"/></option>
							<option value="file"><xsl:value-of select="mxf:locale(messages/message[@id='textFile'])"/></option>
							<option value="folder"><xsl:value-of select="mxf:locale(messages/message[@id='folder'])"/></option>
						</select>
					</p>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='xmlSchema'])"/></label>
						<select name="data[2]">
							<xsl:for-each select="editor[2]/data/file[not(@hidden)]">
								<option value="{concat(@path,'/',@name)}"><xsl:value-of select="@name"/></option>
							</xsl:for-each>
						</select>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="submit" value="{mxf:locale(messages/message[@id='submit'])}"/>
					</p>
				</fieldset>
			</form>
		</li>
		<li>
			<span><xsl:value-of select="mxf:locale(messages/message[@id='uploadFile'])"/></span>
			<!--<form id="upload" method="post" action="folder" enctype="multipart/form-data">
				<input type="hidden" name="command" value="upload"/>
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<fieldset class="flash" id="fsUploadProgress">
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='uploadFiles'])"/></legend>
				</fieldset>
				<p>
					<label>
						<input type="checkbox" name="data[0]" value="1" checked="checked"/>
						<xsl:value-of select="mxf:locale(messages/message[@id='extractArchive'])"/>
					</label>
				</p>
				<p>
					<label>
						<input type="checkbox" name="data[1]" value="1" checked="checked"/>
						<xsl:value-of select="mxf:locale(messages/message[@id='deleteArchive'])"/>
					</label>
				</p>
				<p>
					<span id="spanButtonPlaceHolder"></span>
					<input id="btnCancel" type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="cancelQueue(swfUpload);" disabled="disabled"/>
					<input type="button" value="{mxf:locale(messages/message[@id='close'])}" onclick="$MA(this).menu.toggleForm(null)"/>							
				</p>
			</form>-->
			<form action="../common/js/fancyUpload/script.php" method="post" enctype="multipart/form-data" class="form-demo">
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<fieldset>
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='uploadFiles'])"/></legend>
				</fieldset>
				<div class="demo-status hide">
					<p>
						<a href="#" class="demo-browse"><xsl:value-of select="mxf:locale(messages/message[@id='browseFiles'])"/></a> |
						<a href="#" class="demo-clear"><xsl:value-of select="mxf:locale(messages/message[@id='clearList'])"/></a> |
						<a href="#" class="demo-upload"><xsl:value-of select="mxf:locale(messages/message[@id='startUpload'])"/></a>
					</p>
					<div>
						<strong class="overall-title"><xsl:value-of select="mxf:locale(messages/message[@id='overallProgress'])"/></strong><br/>
						<img src="../common/js/fancyUpload/images/bar.gif" class="progress overall-progress" />
					</div>
					<div>
						<strong class="current-title"><xsl:value-of select="mxf:locale(messages/message[@id='fileProgress'])"/></strong><br/>
						<img src="../common/js/fancyUpload/images/bar.gif" class="progress current-progress" />
					</div>
					<div class="current-text"><xsl:text> </xsl:text></div>
				</div>
				<ul class="demo-list"><xsl:text> </xsl:text></ul>
				<p>
					<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
				</p>
			</form>
		</li>
		<li class="context">
			<span><xsl:value-of select="mxf:locale(messages/message[@id='folderEditor'])"/></span>
			<form class="folder" id="folder" method="post">
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<fieldset>										
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='folderEditor'])"/></legend>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='fileName'])"/></label>
						<input type="text" name="data[0]"/>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="button" value="{mxf:locale(messages/message[@id='submit'])}" onclick="$MA(this).document.editor('folder',this.form['data[0]'].value)"/>
					</p>
				</fieldset>
			</form>
		</li>
		<li class="context">
			<span><xsl:value-of select="mxf:locale(messages/message[@id='textEditor'])"/></span>
			<form class="text" id="text" method="post">
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<fieldset>										
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='textEditor'])"/></legend>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='fileName'])"/></label>
						<input type="text" name="data[0]"/>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="button" value="{mxf:locale(messages/message[@id='submit'])}" onclick="$MA(this).document.editor('text',this.form['data[0]'].value)"/>
					</p>
				</fieldset>
			</form>
		</li>
		<li class="context">
			<span><xsl:value-of select="mxf:locale(messages/message[@id='xmlEditor'])"/></span>
			<form class="xml" id="xml" method="post">
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<fieldset>										
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='xmlEditor'])"/></legend>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='fileName'])"/></label>
						<input type="text" name="data[0]"/>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="button" value="{mxf:locale(messages/message[@id='submit'])}" onclick="$MA(this).document.editor('xml',this.form['data[0]'].value)"/>
					</p>
				</fieldset>
			</form>
		</li>
		<li class="context">
			<span><xsl:value-of select="mxf:locale(messages/message[@id='imageEditor'])"/></span>
			<form class="image" id="image" method="post">
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<fieldset>										
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='imageEditor'])"/></legend>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='fileName'])"/></label>
						<input type="text" name="data[0]"/>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="button" value="{mxf:locale(messages/message[@id='submit'])}" onclick="$MA(this).document.editor('image',this.form['data[0]'].value)"/>
					</p>
				</fieldset>
			</form>
		</li>
		<li class="context">
			<span><xsl:value-of select="mxf:locale(messages/message[@id='svgEditor'])"/></span>
			<form class="svg" id="svg" method="post">
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<fieldset>										
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='svgEditor'])"/></legend>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='fileName'])"/></label>
						<input type="text" name="data[0]"/>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="button" value="{mxf:locale(messages/message[@id='submit'])}" onclick="$MA(this).document.editor('svg',this.form['data[0]'].value)"/>
					</p>
				</fieldset>
			</form>
		</li>
		<li class="context">
			<span><xsl:value-of select="mxf:locale(messages/message[@id='deleteFile'])"/></span>
			<form id="delete" method="post" action="services/folder.php">
				<input type="hidden" name="command" value="delete"/>
				<input type="hidden" name="file" value="{input[@name='file']}"/>									
				<fieldset>										
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='deleteFile'])"/></legend>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='fileName'])"/></label>
						<input type="text" name="data[0]"/>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="submit" value="{mxf:locale(messages/message[@id='submit'])}"/>
					</p>
				</fieldset>
			</form>
		</li>
		<li class="context">
			<span><xsl:value-of select="mxf:locale(messages/message[@id='moveFile'])"/></span>
			<form id="move" method="post" action="services/folder.php">
				<input type="hidden" name="command" value="move"/>
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<fieldset>
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='moveFile'])"/></legend>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='sourceFile'])"/></label>
						<input type="text" name="data[0]"/>
					</p>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='targetFolder'])"/></label>
						<input type="text" name="data[1]" value="{input[@name='file']}"/>
					</p>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='targetFile'])"/></label>
						<input type="text" name="data[2]"/>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="submit" value="{mxf:locale(messages/message[@id='submit'])}"/>
					</p>
				</fieldset>
			</form>
		</li>
		<li class="context">
			<span><xsl:value-of select="mxf:locale(messages/message[@id='copyFile'])"/></span>
			<form id="copy" method="post" action="services/folder.php">
				<input type="hidden" name="command" value="copy"/>
				<input type="hidden" name="file" value="{input[@name='file']}"/>
				<fieldset>
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='copyFile'])"/></legend>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='sourceFile'])"/></label>
						<input type="text" name="data[0]"/>
					</p>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='targetFolder'])"/></label>
						<input type="text" name="data[1]" value="{input[@name='file']}"/>
					</p>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='targetFile'])"/></label>
						<input type="text" name="data[2]"/>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="submit" value="{mxf:locale(messages/message[@id='submit'])}"/>
					</p>
				</fieldset>
			</form>
		</li>
		<li class="context">
			<span><xsl:value-of select="mxf:locale(messages/message[@id='extractArchive'])"/></span>
			<form id="extract" method="post" action="services/folder.php">
				<input type="hidden" name="command" value="extract"/>
				<input type="hidden" name="file" value="{input[@name='file']}"/>									
				<fieldset>										
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='extractArchive'])"/></legend>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='fileName'])"/></label>
						<input type="text" name="data[0]"/>
					</p>
					<p>
						<label>
							<input type="checkbox" name="data[1]" value="1" checked="checked"/>
							<xsl:value-of select="mxf:locale(messages/message[@id='deleteArchive'])"/>
						</label>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="submit" value="{mxf:locale(messages/message[@id='submit'])}"/>
					</p>
				</fieldset>
			</form>
		</li>
		<li class="context">
			<span><xsl:value-of select="mxf:locale(messages/message[@id='lockUnlock'])"/></span>
			<form id="lockUnlock" method="post" action="services/folder.php">
				<input type="hidden" name="file" value="{input[@name='file']}"/>									
				<fieldset>										
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='lockUnlock'])"/></legend>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='action'])"/></label>
						<select name="command">
							<option value="unlock"><xsl:value-of select="mxf:locale(messages/message[@id='unlock'])"/></option>
							<option value="lock"><xsl:value-of select="mxf:locale(messages/message[@id='lock'])"/></option>
						</select>
					</p>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='fileName'])"/></label>
						<input type="text" name="data[0]"/>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="submit" value="{mxf:locale(messages/message[@id='submit'])}"/>
					</p>
				</fieldset>
			</form>
		</li>
		<li class="context">
			<span><xsl:value-of select="mxf:locale(messages/message[@id='backupRestore'])"/></span>
			<form id="backupRestore" method="post" action="services/folder.php">
				<input type="hidden" name="file" value="{input[@name='file']}"/>									
				<fieldset>										
					<legend><xsl:value-of select="mxf:locale(messages/message[@id='backupRestore'])"/></legend>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='action'])"/></label>
						<select name="command" onchange="this.form['data[1]'].disabled=(this.selectedIndex>0)">
							<option value="restore"><xsl:value-of select="mxf:locale(messages/message[@id='restore'])"/></option>												
							<option value="backup"><xsl:value-of select="mxf:locale(messages/message[@id='backup'])"/></option>
						</select>
					</p>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='fileName'])"/></label>
						<input type="text" name="data[0]" onblur="backupFilter(this.value)"/>
					</p>
					<p>
						<label><xsl:value-of select="mxf:locale(messages/message[@id='version'])"/></label>
						<select id="version" name="data[1]">
							<option value=""></option>
							<xsl:for-each select="editor[1]/data/file[@hidden]">
								<option value="{@name}"><xsl:value-of select="concat(substring-after(@name,'~'),' - ',@modified)"/></option>
							</xsl:for-each>
						</select>
					</p>
					<p>
						<input type="button" value="{mxf:locale(messages/message[@id='cancel'])}" onclick="$MA(this).menu.toggleForm(null)"/>
						<input type="submit" value="{mxf:locale(messages/message[@id='submit'])}"/>
					</p>
				</fieldset>
			</form>
		</li>
		<li onclick="$MA(this).toggleView()"><span><xsl:value-of select="mxf:locale(messages/message[@id='toggleViewMode'])"/></span></li>
		<li onclick="$MA(this).toggleHiddenFiles()"><span><xsl:value-of select="mxf:locale(messages/message[@id='toggleHiddenFiles'])"/></span></li>
		<li onclick="$MA(this).document.loadRequest()"><span><xsl:value-of select="mxf:locale(messages/message[@id='refresh'])"/></span></li>
	</xsl:template>
	<!-- File and folder items -->
	<xsl:template match="file">
		<xsl:variable name="file" select="concat(/folder/input[@name='file'],'/',@name)"/>
		<xsl:variable name="permission" select="mxf:permission($file)"/>
		<xsl:variable name="hidden"><xsl:if test="@hidden"> hidden</xsl:if></xsl:variable>
		<xsl:variable name="locked"><xsl:if test="@locked"> locked</xsl:if></xsl:variable>
		<!--<xsl:if test="$permission and $permission/@read = 'true'">-->
			<li class="{$hidden} {$locked} {@type}" id="{@name}">
				<a href="{$file}" class="content">
					<xsl:choose>
						<xsl:when test="@type='folder'">
							<span class="arrow subcontent" title="{mxf:locale(/folder/messages/message[@id='displaySubcontent'])}">
								<xsl:text> </xsl:text>
							</span>
						</xsl:when>
						<xsl:otherwise>
							<span class="arrow"><xsl:text> </xsl:text></span>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:if test="@locked">
						<span class="locked"><xsl:text> </xsl:text></span>	
					</xsl:if>
					<xsl:if test="@type='download image'">
						<span class="image"><img src="{$file}" alt=""/></span>	
					</xsl:if>
					<span class="name"><xsl:value-of select="@name"/></span>
					<span class="size"><xsl:value-of select="@size"/></span>
					<span class="created"><xsl:value-of select="@created"/></span>
					<span class="modified"><xsl:value-of select="@modified"/></span>
				</a>
			</li>
		<!--</xsl:if>-->
	</xsl:template>
</xsl:stylesheet>
