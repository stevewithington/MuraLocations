<cfscript>
/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2014 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript>
<cfoutput>
	<plugin>

		<name>MuraLocations</name>
		<package>MuraLocations</package>
		<directoryFormat>packageOnly</directoryFormat>
		<version>3.1.0</version>
		<provider>Steve Withington</provider>
		<providerURL>http://stephenwithington.com</providerURL>
		<category>Application</category>
		<settings></settings>

		<!-- Event Handlers -->
		<eventHandlers>
			<!-- only need to register the eventHandler.cfc via onApplicationLoad() -->
			<eventHandler 
				event="onApplicationLoad" 
				component="cfc.EventHandler" 
				persist="false" />
		</eventHandlers>

		<!-- Display Objects -->
		<displayobjects location="global">

			<displayobject 
				name="Locations Map" 
				component="cfc.EventHandler"
				displaymethod="dspLocationsMap" 
				persist="false" />

			<displayobject 
				name="Find Locations Form" 
				component="cfc.EventHandler"
				displaymethod="dspFindLocationsForm" 
				persist="false" />

		</displayobjects>

		<!-- Custom Class Extensions -->
		<cfinclude template="classExtensions.xml.cfm" />

	</plugin>

</cfoutput>