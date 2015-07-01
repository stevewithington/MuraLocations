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
	<!--- GMap Wrapper --->
		<div class="gmap-outer-wrapper" id="gmap-outer-wrapper-#local.mapCanvasID#">

			<!--- Map Category Filter --->
				<cfif StructKeyExists(arguments, 'displayCategoryFilter') and YesNoFormat(arguments.displayCategoryFilter)>
					<cfscript>
						var cats = [];
						for ( var place in arguments.places ) {
							for ( var category in place.categories) {
								if ( !ArrayFind(cats, category) ) {
									ArrayAppend(cats, category);
								}
							}
						}
						ArraySort(cats, 'textnocase', 'asc');
					</cfscript>
					<cfif ArrayLen(arguments.places) gt 1 and ArrayLen(cats) gt 1>
						<div class="gmap-header">
							<h4 class="gmap-header-title">Filter Map</h4>
							<div class="gmap-category-filters" id="gmap-category-filters-#local.mapCanvasID#">
								<cfloop array="#cats#" index="cat">
									<div class="gmap-category-filter-wrapper">
										<label class="gmap-category-filter-label">
											<input type="checkbox" class="gmap-category-filter-option" name="gmap-category-filter-option" value="#cat#" checked> <span class="gmap-category-filter-name">#cat#</span>
										</label>
									</div>
								</cfloop>
							</div>
						</div>
					</cfif>
				</cfif>
			<!--- /Map Category Filter --->

			<!--- GMap --->
				<div class="gmap-wrapper" id="gmap-wrapper-#local.mapCanvasID#">
					<div class="gmap-canvas" id="#local.mapCanvasID#">
						<cfloop array="#arguments.places#" index="place">
							<div class="gmap-marker" data-categories="#ArrayToList(place.categories)#" data-lat="#place.lat#" data-lng="#place.lng#" data-icon="#place.icon#" data-zindex="#place.zindex#">
								<div class="gmap-marker-info">
									#place.infowindow#
								</div>
							</div>				
						</cfloop>
					</div>
				</div>
			<!--- /GMap --->

			<!--- <a href="https://www.google.com/maps/?q=#esapiEncode('html_attr', local.place['lat'])#,#esapiEncode('html_attr', local.place['lng'])#" class="btn btn-link" target="_blank">View in Google Maps &raquo;</a> --->

			<!--- Directions Form --->
				<cfif StructKeyExists(arguments, 'displayDirections') and YesNoFormat(arguments.displayDirections)>
					<!--- Directions Wrapper --->
						<div class="gmap-directions-form-wrapper">
							<form role="form" data-ajax="false" class="gmap-directions-form form-horizontal" name="frm-directions" id="#local.formID#" action="javascript:void();" method="post">
								<!--- Start From --->
									<div class="gmap-start form-group">
										<label class="control-label col-sm-2" for="start">From:</label>
										<div class="col-sm-9">
											<input class="form-control" type="text" size="40" name="start" id="start-#local.formID#" value="#esapiEncode('html_attr', arguments.start)#" />
										</div>
									</div>
								<!--- /Start From --->
								<!--- To --->
									<div class="gmap-end form-group">
										<label class="control-label col-sm-2" for="end">To:</label>
										<div class="col-sm-9">
											<cfif ArrayLen(arguments.places) gt 1>
												<select class="form-control" name="end" id="end-#local.formID#">
													<cfloop array="#arguments.places#" index="local.place">
														<option value="#esapiEncode('html_attr', local.place['lat'])#,#esapiEncode('html_attr', local.place['lng'])#">#esapiEncode('html', local.place['placename'])#</option>
													</cfloop>
												</select>
											<cfelse>
												<cfloop array="#arguments.places#" index="local.place">
													#esapiEncode('html', local.place['placename'])# <input type="hidden" name="end" id="end-#local.formID#" value="#esapiEncode('html_attr', local.place['lat'])#,#esapiEncode('html_attr', local.place['lng'])#" />
												</cfloop>
											</cfif>
										</div>
									</div>
								<!--- /To --->
								<!--- Travel Modes --->
									<cfif StructKeyExists(arguments, 'displayTravelMode') and YesNoFormat(arguments.displayTravelMode)>
										<div class="gmap-travel-mode form-group">
											<label class="control-label col-sm-2" for="mode">Travel Mode:</label>
											<div class="col-sm-9">
												<select class="form-control" name="mode" id="mode-#local.formID#">
													<option value="DRIVING">Driving</option>
													<option value="BICYCLING">Bicycling</option>
													<option value="WALKING">Walking</option>
												</select>
											</div>
										</div>
									<cfelse>
										<input type="hidden" name="mode" id="mode" value="DRIVING" />
									</cfif>
								<!--- /Travel Modes --->
								<div class="form-group">
									<div class="gmap-submit col-sm-offset-2 col-sm-9">
										<input class="btn btn-primary" type="submit" name="submit" value="Get Directions &raquo;" />
									</div>
								</div>
							</form>
						</div>
					<!--- /Directions Wrapper --->
					<div class="gmap-directions" id="#local.mapDirectionsID#"></div>
				</cfif>
			<!--- /Directions Form --->

		</div>
	<!--- /GMap Wrapper --->
</cfoutput>