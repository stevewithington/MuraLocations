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

	<!--- Category Filter --->
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
	<cfif ArrayLen(cats)>
		<div class="category-filters">
			<cfloop array="#cats#" index="cat">
				<div class="category-filter-wrapper">
					<label class="category-filter-label">
						<input type="checkbox" class="category-filter-option" name="category-filter-option" value="#cat#" checked> #cat#
					</label>
				</div>
			</cfloop>
		</div>
	</cfif>

	<!-- START: gmapWrapper -->
	<div id="gmapWrapper_#local.thisID#" class="gmapWrapper">
		<div class="gmapCanvas" id="#local.mapCanvasID#">
			<cfloop array="#arguments.places#" index="place">
				<div class="marker" data-categories="#ArrayToList(place.categories)#" data-lat="#place.lat#" data-lng="#place.lng#" data-icon="#place.icon#" data-zindex="#place.zindex#">
					<div class="marker-info">
						#place.infowindow#
					</div>
				</div>				
			</cfloop>
		</div>
	</div><!-- /.gmapWrapper -->
</cfoutput>