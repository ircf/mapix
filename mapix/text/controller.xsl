<?xml version="1.0"?>
<!-- Text editor map -->
<mapix xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://mapixcms.org/schemas/mapix.xsd">

	<template url="template.xsl">
		<input type="session" name="lang" global="true"/>
		<input type="session" name="user" global="true"/>
		<input type="request" name="file" global="true"/>
		<content url="../messages.xml" global="true"/>
		<content url="messages.xml" global="true"/>
		<page>
			<content url="text.php" method="post">
				<output name="command">
					<input type="post" name="command"/>
				</output>
				<output name="file">
					<input type="request" name="file"/>
				</output>
				<output name="data" serialize="false">
					<input type="post" name="data"/>
				</output>
				<output name="backup">
					<input type="post" name="backup"/>
				</output>
			</content>
		</page>
		<page url="menu"/>
	</template>
</mapix>
