<cfscript>
/**
* 
* This file is part of MuraLocations TM
* (c) Stephen J. Withington, Jr. | www.stephenwithington.com
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*
*/
</cfscript>
<cfoutput>
	<plugin>

		<name>MuraLocations</name>
		<package>MuraLocations</package>
		<directoryFormat>packageOnly</directoryFormat>
		<version>0.1.0 Alpha</version>
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