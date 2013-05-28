<cfscript>
/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2013 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
	include 'plugin/config.cfm';
</cfscript>
<cfsavecontent variable="body">
	<cfoutput>
		<div>
			<h1>#HTMLEditFormat(pluginConfig.getName())#</h1>
			<p><em>Version: #pluginConfig.getVersion()#<br />
			Author: <a href="http://stephenwithington.com" target="_blank">Steve Withington</a></em></p>

			<h2>Overview</h2>
			<p>This plugin allows content managers to add/edit Locations which can then be displayed on a Google&trade; Map. The plugin also allows for end-users to either use their current location or enter their address to obtain a list of the 'closest' locations.</p>

			<h2>Description</h2>
			<p>This plugin creates two new content types in Mura:</p>
			<ul>
				<li>
					<h3>Folder / MuraLocation</h3>
					<p>This content type will display a Google Map to display any 'Page / MuraLocation' types that have been created on the site. There are a number of configurable options available on the 'Extended Attributes' tab such as Map Width, Map Height, Default Zoom, Map Type, Display Directions, Display Travel Mode Options, etc. Please refer to the help icons on the form for more information regarding these fields.</p>
				</li>

				<li>
					<h3>Page / MuraLocation</h3>
					<p>This content type will display a Google Map of the location. The location information can be entered/updated by editing the 'Extended Attributes' tab. In addition to most of the same attributes available for 'Folder / MuraLocation' you can enter information such as Street Address, City/Locality, State/Region, Postal Code, Phone, Fax, Email, Latitude and Longitude. Please refer to the help icons on the form for more information regarding these fields.</p> 
				</li>
			</ul>

			<h3>Plugin Display Objects</h3>
			<p>There are two display objects available:</p>
			<ul>
				<li>
					<h4>Locations Map</h4>
					<p>This is quite similar to the 'Folder / MuraLocation' with the exception that it will display a map of all content typed as 'Page / MuraLocation' as long as the 'Show on All Locations Map Display Object' setting is set to yes.</p>
				</li>
				<li>
					<h4>Find Locations Form</h4>
					<p>This allows end-users the ability to find locations nearest them. Depending on the user's browser, they may be able to simply click <strong>Use Current Location</strong>.</p>
				</li>
			</ul>

			<p>To use these display objects, go to the 'Layout &amp; Objects' tab &gt; Select 'Plugins' from the 'Available Content Objects' select menu &gt; Select 'MuraLocations' from the list of plugins > Then select a display object and assign it to your desired display region.</p>

			<h2>Designers / Developers</h2>
			<p>The 'Plugin Display Objects' may also be added directly onto your template or even dropped into a content region using '[mura]' tags.</p>

			<h3>Find Locations Form Example Code</h3>
			<h4>Mura Tag Method</h4>
			<pre>[mura]$.muraLocations.dspFindLocationsForm()[/mura]</pre>
			<h4>CFML Method</h4>
			<pre>##$.muraLocations.dspFindLocationsForm()##</pre>

			<p>Also, if your theme is using <strong>jQuery Mobile</strong>, then you will really enjoy the 'Find Locations Form' display object. Be sure to check it out in Mobile Format!</p>

			<h3>Locations Map Example Code</h3>
			<h4>Mura Tag Method</h4>
			<pre>[mura]$.muraLocations.dspLocationsMap()[/mura]</pre>
			<h4>CFML Method</h4>
			<pre>##$.muraLocations.dspLocationsMap()##</pre>

			<p>You can optionally pass in some arguments to this method as well to control the display:</p>

<pre>boolean displayDirections=true
boolean displayTravelMode=true
string start=''
numeric mapHeight=400
string mapType='TERRAIN'
numeric mapWidth=0
string mapZoom='default'</pre>

			<h4>Example Using Arguments</h4>
			<pre>##$.muraLocations.dspLocationsMap(displayTravelMode=false, mapType='ROADMAP')##</pre>

			<h2>Recommended Setup</h2>
			<p>Probably the best way to use this plugin would be to setup your 'Locations' area like this:</p>

<pre>- Locations (Just a normal Page or Folder)
	- Find Locations (A Page with the 'Find Location Form' added to the main content area)
	- View All Locations (Folder / MuraLocation)
		- Location 1 (Page / MuraLocation)
		- Location 2 (Page / MuraLocation)
		- etc.
</pre>
			<p>Technically, you could have 'Page / MuraLocation' content nodes scattered throughout your site and simply use the 'Find Location Form' display object on a 'Find Closest Location' page.</p>

			<h2>Developer Notes</h2>
			<ul>
				<li>The following default Mura CMS form fields are assumed to be unique properties of the Location and thus will be automatically marked up with microdata for SEO purposes:
					<ul>
						<li>The Title is assumed to be the <strong>name</strong> of the Location.</li>
						<li>The primary associated image is assumed to be an <strong>image</strong> of the Location.</li>
						<li>The Content is assumed to be a <strong>description</strong> of the Location.</li>
					</ul>
				</li>
				<li>See <a href="http://schema.org/Place">http://schema.org/Place</a> for details on microdata information used in this plugin.</li>
			</ul>

			<h2>Tested With</h2>
			<ul>
				<li>Mura CMS Core Version 6.0+</li>
				<li>Adobe ColdFusion 10.0.4</li>
				<li>Railo 4.0.2.002</li>
			</ul>

			<h3>Should Also Work With</h3>
			<p><em>Minimum Mura CMS Core Version required is 6.0+</em></p>
			<ul>
				<li>ColdFusion 9.0.1+</li>
				<li>Railo 3.3.1+</li>
			</ul>

			<h2>Need help?</h2>
			<p>If you're running into an issue, please let me know at <a href="https://github.com/stevewithington/MuraLocations/issues">https://github.com/stevewithington/MuraLocations/issues</a> and I'll try to address it as soon as I can.</p>
	
			<p>Cheers!<br />
			<a href="http://stephenwithington.com">Steve Withington</a></p>

			<h2>License</h2>
			<p>Copyright 2012<cfif Year(Now()) neq 2012>-#Year(Now())#</cfif> Stephen J. Withington, Jr.</p>
			<p>Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:</p>

			<blockquote><a href="http://www.apache.org/licenses/LICENSE-2.0">http://www.apache.org/licenses/LICENSE-2.0</a></blockquote>

			<p>Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.</p>
		</div>
	</cfoutput>
</cfsavecontent>
<cfoutput>
	#$.getBean('pluginManager').renderAdminTemplate(
		body = body
		, pageTitle = pluginConfig.getName()
	)#
</cfoutput>