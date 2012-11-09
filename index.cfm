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
	include 'plugin/config.cfm';
</cfscript>
<cfsavecontent variable="body">
	<cfoutput>
		<div style="width:650px;">
			<h2>#HTMLEditFormat(pluginConfig.getName())#</h2>
			<p><em>Version: #pluginConfig.getVersion()#<br />
			Author: <a href="http://stephenwithington.com" target="_blank">Steve Withington</a></em></p>

			<h3>End User License Agreement (EULA)</h3>
			<p><em><a href="plugin/license.txt" target="_blank">View Printer-Friendly Version &gt;</a></em></p>
			<div class="notice">
				<p><textarea readonly="readonly" name="EULA" id="EULA" label="End User License Agreement (EULA)" cols="77" rows="10"><cfinclude template="plugin/license.txt" /></textarea></p>
			</div>

			<h3>How Do I Use This?</h3>
			<p>Coming soon.</p>

			<h3>Requirements</h3>
			<div class="notice">
				<ul style="padding:0 2em;">
					<li>ColdFusion 9.0.1+ or Railo 3.3.1+ <em>(this has NOT been tested on Open BlueDragon)</em></li>
					<li>Mura 5.6+</li>
				</ul>
			</div>

			<h3>Need help?</h3>
			<p>Catch me on the <a href="http://www.getmura.com/forum/" target="_blank">Mura CMS forums</a>, contact me through my site at <a href="http://www.stephenwithington.com" target="_blank">www.stephenwithington.com</a>, or via email at steve [at] stephenwithington [dot] com.</p>
			<p>Cheers!</p>
		</div>
	</cfoutput>
</cfsavecontent>
<cfoutput>
	#$.getBean('pluginManager').renderAdminTemplate(
		body = body
		, pageTitle = pluginConfig.getName()
	)#
</cfoutput>