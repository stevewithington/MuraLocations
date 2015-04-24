<cfscript>
/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2015 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
	include 'settings.cfm';
</cfscript>
<cfoutput>
	<plugin>

		<name>#variables.settings.pluginName#</name>
		<package>#variables.settings.package#</package>
		<directoryFormat>packageOnly</directoryFormat>
		<loadPriority>#variables.settings.loadPriority#</loadPriority>
		<version>#variables.settings.version#</version>
		<provider>#variables.settings.provider#</provider>
		<providerURL>#variables.settings.providerURL#</providerURL>
		<category>#variables.settings.category#</category>
		<settings></settings>

		<!-- Event Handlers -->
		<eventHandlers>
			<!-- only need to register the eventHandler.cfc via onApplicationLoad() -->
			<eventHandler 
				event="onApplicationLoad" 
				component="extensions.EventHandler" 
				persist="false" />
		</eventHandlers>

		<!-- Display Objects -->
		<displayobjects location="global">

			<displayobject 
				name="Locations Map" 
				component="extensions.EventHandler"
				displaymethod="dspLocationsMap" 
				persist="false" />

		</displayobjects>

		<!-- Custom Class Extensions -->
		<cfinclude template="classExtensions.xml.cfm" />

	</plugin>

</cfoutput>