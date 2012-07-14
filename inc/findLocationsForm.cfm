<cfsilent><cfscript>
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
</cfscript></cfsilent>
<cfoutput>
	<div id="muraLocationsWrapper">
			<!--- Matches --->
			<cfif Val($.event('geoMatches')) gt 1>
				<div id="multipleMatches">
					<p>There were #Val($.event('geoMatches'))# possible matches. Please select a location from the list below:</p>
					<form id="possibleMatchesForm" method="post">
						<select name="currentLocation">
							<cfloop array="#$.event('geoResponse').results#" index="local.i">
								<option value="#HTMLEditFormat(local.i.formatted_address)#">
									#HTMLEditFormat(local.i.formatted_address)#
								</option>
							</cfloop>
						</select>
						<input type="submit" value="Find" data-icon="search" data-theme="e" />
						<input type="hidden" name="findLocationRequestSubmitted" id="findLocationRequestSubmitted" value="true" />
						<!---<a href="#$.content('url')#" data-role="button" rel="external" data-theme="b">Back</a>--->
					</form>
				</div>
			<cfelseif !IsSimpleValue($.event('geoResponse')) and Val($.event('geoMatches')) lt 1>
				<div id="noMatches">
					<p>There were no matches to your location. Please try again.</p>
					<a href="#$.content('url')#" data-role="button" rel="external" data-theme="b">Back</a>
				</div>
			<cfelseif Val($.event('geoMatches')) eq 1>
				<!--- output closest locations --->
				<cfset class = $.event('muraMobileRequest') ? 'locationMobileFormat' : 'locationBrowserFormat'>				
				<div id="locationResult" class="#class#">
					#$.muraLocations.dspClosestLocations($)#
				</div>
			<cfelse>
				<div id="status"></div>

				<!--- Geo Options --->
				<div id="geoOptions">
					<cfif $.event('muraMobileRequest')>
						<a id="btnDoGeo" href="##" data-role="button" data-icon="search" data-theme="e">Use Current Location</a>
						<a id="btnDoForm" href="##" data-role="button" data-theme="b">Manually Enter Location</a>
					<cfelse>
						<a class="geoButton" id="btnDoGeo" href="##">Use Current Location</a>
						<a class="geoButton" id="btnDoForm" href="##">Manually Enter Location</a>
					</cfif>
				</div>
			
				<!--- Manual Form --->
				<div id="initialFormWrapper">
					<form id="initialForm" method="post">
						<label for="currentLocation" class="ui-hidden-accessible">Location:</label>
						<input type="text" name="currentLocation" id="currentLocation" value="#$.event('currentLocation')#" placeholder="Enter a location..." required />
						<input type="submit" value="Find" data-icon="search" data-theme="e" />
						<input type="hidden" name="usingGeolocation" id="usingGeolocation" value="false" />
						<input type="hidden" name="findLocationRequestSubmitted" id="findLocationRequestSubmitted" value="true" />
					</form>
				</div>
			</cfif>
	</div><!--- /muraLocationsWrapper --->
</cfoutput>