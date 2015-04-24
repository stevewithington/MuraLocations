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
	<!-- gmap-wrapper -->
	<div class="gmap-wrapper" id="gmap-wrapper-#local.mapCanvasID#">

		<!--- Category Filter --->
			<cfif YesNoFormat(arguments.displayCategoryFilter)>
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
					<div class="category-filters" id="category-filters-#local.mapCanvasID#">
						<cfloop array="#cats#" index="cat">
							<div class="category-filter-wrapper">
								<label class="category-filter-label">
									<input type="checkbox" class="category-filter-option" name="category-filter-option" value="#cat#" checked> #cat#
								</label>
							</div>
						</cfloop>
					</div>
				</cfif>
			</cfif>
		<!--- /Category Filter --->

		<!--- GMap Canvas --->
			<div class="gmap-canvas" id="gmap-canvas-#local.mapCanvasID#">
				<cfloop array="#arguments.places#" index="place">
					<div class="marker" data-categories="#ArrayToList(place.categories)#" data-lat="#place.lat#" data-lng="#place.lng#" data-icon="#place.icon#" data-zindex="#place.zindex#">
						<div class="marker-info">
							#place.infowindow#
						</div>
					</div>				
				</cfloop>
			</div>
		<!--- /GMap Canvas --->

	</div>
	<!-- /.gmap-wrapper -->
</cfoutput>