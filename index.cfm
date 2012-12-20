<cfscript>
/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2012 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
	include 'plugin/config.cfm';
</cfscript>
<cfsavecontent variable="body">
	<cfoutput>
		<div>
			<h2>#HTMLEditFormat(pluginConfig.getName())#</h2>
			<p><em>Version: #pluginConfig.getVersion()#<br />
			Author: <a href="http://stephenwithington.com" target="_blank">Steve Withington</a></em></p>

			<h3>Description</h3>

			<p>This plugin creates two new content types in Mura:</p>
			<ul>
				<li>
					<h5>Folder / MuraLocation</h5>
					<p>This content type will display a Google Map to display any 'Page / MuraLocation' types that have been created on the site. There are a number of configurable options available on the 'Extended Attributes' tab such as Map Width, Map Height, Default Zoom, Map Type, Display Directions, Display Travel Mode Options, etc. Please refer to the help icons on the form for more information regarding these fields.</p>
				</li>

				<li>
					<h5>Page / MuraLocation</h5>
					<p>This content type will display a Google Map of the location. The location information can be entered/updated by editing the 'Extended Attributes' tab. In addition to most of the same attributes available for 'Folder / MuraLocation' you can enter information such as Street Address, City/Locality, State/Region, Postal Code, Phone, Fax, Email, Latitude and Longitude. Please refer to the help icons on the form for more information regarding these fields.</p> 
				</li>
			</ul>

			<h4>Plugin Display Objects</h4>
			<p>There are two display objects available:</p>
			<ul>
				<li>
					<h5>Locations Map</h5>
					<p>This is quite similar to the 'Folder / MuraLocation' with the exception that it will display a map of all content typed as 'Page / MuraLocation' as long as the 'Show on All Locations Map Display Object' setting is set to yes.</p>
				</li>
				<li>
					<h5>Find Locations Form</h5>
					<p>This allows end-users the ability to find locations nearest them. Depending on the user's browser, they may be able to simply click <strong>Use Current Location</strong>.</p>
				</li>
			</ul>

			<p>To use these display objects, go to the 'Layout &amp; Objects' tab &gt; Select 'Plugins' from the 'Available Content Objects' select menu &gt; Select 'MuraLocations' from the list of plugins > Then select a display object and assign it to your desired display region.</p>

			<h3>Designers / Developers</h3>
			<p>The 'Plugin Display Objects' may also be added directly onto your template or even dropped into a content region using '[mura]' tags.</p>

			<h4>Find Locations Form Example Code</h4>
			<h5>Mura Tag Method</h5>
			<pre>[mura]$.muraLocations.dspFindLocationsForm()[/mura]</pre>
			<h5>CFML Method</h5>
			<pre>##$.muraLocations.dspFindLocationsForm()##</pre>

			<p>Also, if your theme is using <strong>jQuery Mobile</strong>, then you will really enjoy the 'Find Locations Form' display object. Be sure to check it out in Mobile Format!</p>

			<h4>Locations Map Example Code</h4>
			<h5>Mura Tag Method</h5>
			<pre>[mura]$.muraLocations.dspLocationsMap()[/mura]</pre>

			<h5>CFML Method</h5>
			<pre>##$.muraLocations.dspLocationsMap()##</pre>

			<p>You can optionally pass in some arguments to this method as well to control the display:</p>

<pre>boolean displayDirections=true
boolean displayTravelMode=true
string start=''
numeric mapHeight=400
string mapType='TERRAIN'
numeric mapWidth=0
string mapZoom='default'</pre>

			<h5>Example Using Arguments</h5>
			<pre>##$.muraLocations.dspLocationsMap(displayTravelMode=false, mapType='ROADMAP')##</pre>

			<h3>Tested With</h3>
			<ul>
				<li>Mura CMS Core Version 6.0.5171</li>
				<li>Adobe ColdFusion 10.0.4</li>
				<li>Railo 4.0.2.002</li>
			</ul>

			<h4>Should Also Work With</h4>
			<ul>
				<li>Mura 5.6+</li>
				<li>ColdFusion 9.0.1+</li>
				<li>Railo 3.3.1+</li>
			</ul>

			<h3>Need help?</h3>
			<p>If you're running into an issue, please let me know at <a href="https://github.com/stevewithington/MuraLocations/issues">https://github.com/stevewithington/MuraLocations/issues</a> and I'll try to address it as soon as I can.</p>
	
			<p>Cheers!<br />
			<a href="http://stephenwithington.com">Steve Withington</a></p>
		</div>
	</cfoutput>
</cfsavecontent>
<cfoutput>
	#$.getBean('pluginManager').renderAdminTemplate(
		body = body
		, pageTitle = pluginConfig.getName()
	)#
</cfoutput>