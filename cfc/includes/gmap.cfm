<cfsilent><cfscript>
/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2014 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript></cfsilent>
<cfoutput>
	<!-- START: gmapWrapper -->
	<div id="gmapWrapper_#local.thisID#" class="gmapWrapper">
		<div class="gmapCanvas" id="#local.mapCanvasID#"></div>
		<!--- Directions Form --->
		<cfif arguments.displayDirections>
			<div class="gmapDirectionsFormWrapper">
				<form role="form" data-ajax="false" class="gmapDirectionsForm form-horizontal" name="frmDirections" id="#local.formID#" action="javascript:void();" method="post" onSubmit="calcRoute_#local.thisid#(this.start.value,this.end.value,this.mode.value); return false;">
					<div class="gmapStart form-group">
						<label class="control-label col-sm-2" for="start">From:</label>
						<div class="col-sm-9">
							<input class="form-control" type="text" size="40" id="start" name="start" value="#arguments.start#" />
						</div>
					</div>
					<div class="gmapEnd form-group">
						<label class="control-label col-sm-2" for="end">To:</label>
						<div class="col-sm-9">
							<cfif ArrayLen(arguments.places) gt 1>
								<select class="form-control" name="end" id="end">
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
					</div>
					<!--- Travel Modes --->
					<cfif arguments.displayTravelMode>
						<div class="gmapTravelMode form-group">
							<label class="control-label col-sm-2" for="mode">Travel Mode:</label>
							<div class="col-sm-9">
								<select class="form-control" name="mode" id="mode">
									<option value="DRIVING">Driving</option>
									<option value="BICYCLING">Bicycling</option>
									<option value="WALKING">Walking</option>
								</select>
							</div>
						</div>
					<cfelse>
						<input type="hidden" name="mode" id="mode" value="DRIVING" />
					</cfif>
					<div class="form-group">
						<div class="gmapSubmit col-sm-offset-2 col-sm-9">
							<input class="btn btn-primary" type="submit" name="submit" value="Get Directions &raquo;" />
						</div>
					</div>
				</form>
			</div><!-- /.gmapDirectionsFormWrapper -->
			<div class="gmapDirections" id="#local.mapDirectionsID#"></div><!-- /.gmapDirections -->
		</cfif>

	</div><!-- /.gmapWrapper -->
</cfoutput>