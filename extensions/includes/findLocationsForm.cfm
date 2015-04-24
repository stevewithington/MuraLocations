<cfsilent><cfscript>
/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2015 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript></cfsilent>
<cfoutput>
	<div id="muraLocationsWrapper">
			<!--- Matches --->
			<cfif Val(variables.$.event('geoMatches')) gt 1>
				<div id="multipleMatches">
					<p>There were #Val(variables.$.event('geoMatches'))# possible matches. Please select a location from the list below:</p>
					<form id="possibleMatchesForm" method="post">
						<div class="form-group">
							<select class="form-control" name="currentLocation">
								<cfloop array="#variables.$.event('geoResponse').results#" index="local.i">
									<option value="#HTMLEditFormat(local.i.formatted_address)#">
										#HTMLEditFormat(local.i.formatted_address)#
									</option>
								</cfloop>
							</select>
						</div>
						<button type="submit" class="btn btn-primary" value="Find" data-icon="search" data-theme="e">
							<i class="fa fa-search"></i> Find
						</button>
						<input type="hidden" name="findLocationRequestSubmitted" id="findLocationRequestSubmitted" value="true" />
						<!---<a href="#variables.$.content('url')#" data-role="button" rel="external" data-theme="b">Back</a>--->
					</form>
				</div>
			<cfelseif !IsSimpleValue(variables.$.event('geoResponse')) and Val(variables.$.event('geoMatches')) lt 1>
				<div id="noMatches">
					<p>There were no matches to your location. Please try again.</p>
					<a class="btn btn-primary" href="#variables.$.content('url')#" data-role="button" rel="external" data-theme="b">Back</a>
				</div>
			<cfelseif Val(variables.$.event('geoMatches')) eq 1>
				<!--- output closest locations --->
				<cfset class = variables.$.event('muraMobileRequest') ? 'locationMobileFormat' : 'locationBrowserFormat'>				
				<div id="locationResult" class="#class#">
					#variables.$.muraLocations.dspClosestLocations(variables.$)#
				</div>
			<cfelse>
				<div id="status"></div>

				<!--- Geo Options --->
				<div id="geoOptions">
					<cfif variables.$.event('muraMobileRequest')>
						<a id="btnDoGeo" href="##" data-role="button" data-icon="search" data-theme="e">Use Current Location</a>
						<a id="btnDoForm" href="##" data-role="button" data-theme="b">Manually Enter Location</a>
					<cfelse>
						<a class="geoButton btn btn-primary" id="btnDoGeo" href="##">Use Current Location</a>
						<a class="geoButton btn btn-default" id="btnDoForm" href="##">Manually Enter Location</a>
					</cfif>
				</div>
			
				<!--- Manual Form --->
				<div id="initialFormWrapper">
					<form id="initialForm" method="post">
						<label for="currentLocation" class="ui-hidden-accessible">Location:</label>
						<div class="input-group">
							<input type="text" class="form-control" name="currentLocation" id="currentLocation" value="#variables.$.event('currentLocation')#" placeholder="Enter a location..." required />
							<span class="input-group-btn">
								<button type="submit" class="btn btn-default" value="Find" data-icon="search" data-theme="e"><i class="fa fa-search"></i> Find</button>
							</span>
						</div>
						<input type="hidden" name="usingGeolocation" id="usingGeolocation" value="false" />
						<input type="hidden" name="findLocationRequestSubmitted" id="findLocationRequestSubmitted" value="true" />
					</form>
				</div>
			</cfif>
	</div><!--- /muraLocationsWrapper --->
</cfoutput>