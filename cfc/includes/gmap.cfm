<cfsilent><cfscript>
/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2013 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript></cfsilent>
<cfoutput>
	<!-- START: gmapWrapper -->
	<div class="gmapWrapper">

		<div class="gmapCanvas" id="#local.mapCanvasID#"></div>

		<!--- Directions Form --->
		<cfif arguments.displayDirections>
			<div class="gmapDirectionsFormWrapper">
				<form data-ajax="false" class="gmapDirectionsForm" name="frmDirections" id="#local.formID#" action="javascript:void();" method="post" onSubmit="calcRoute(this.start.value,this.end.value,this.mode.value); return false;">
					<div class="gmapStart gmapField">
						<label for="start">From:</label>
						<input type="text" size="40" id="start" name="start" value="#arguments.start#" />
					</div>
					<div class="gmapEnd gmapField">
						<label for="end">To:</label>
						<cfif ArrayLen(arguments.places) gt 1>
							<select name="end" id="end">
								<cfloop array="#arguments.places#" index="local.place">
									<option value="#local.place[2]#,#local.place[3]#">#local.place[1]#</option>
								</cfloop>
							</select>
						<cfelse>
							<cfloop array="#arguments.places#" index="local.place">
								#local.place[1]# <input type="hidden" name="end" value="#local.place[2]#,#local.place[3]#" />
							</cfloop>
						</cfif>
					</div>
					<!--- Travel Modes --->
					<cfif arguments.displayTravelMode>
						<div class="gmapTravelMode gmapField"><label for="mode">Travel Mode:</label>
							<select name="mode" id="mode">
								<option value="DRIVING">Driving</option>
								<option value="BICYCLING">Bicycling</option>
								<option value="WALKING">Walking</option>
							</select>
						</div>
					<cfelse>
						<input type="hidden" name="mode" id="mode" value="DRIVING" />
					</cfif>
					<div class="gmapSubmit gmapField">
						<input type="submit" name="submit" value="Get Directions &raquo;" />
					</div>
				</form>
			</div><!-- /.gmapDirectionsFormWrapper -->
			<div class="gmapDirections" id="#local.mapDirectionsID#"></div><!-- /.gmapDirections -->
		</cfif>

	</div><!-- /.gmapWrapper -->
</cfoutput>