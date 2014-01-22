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
	<div class="#local.outerWrapperClass#">
		<!--- Content --->
		#local.body#
		<div class="locationInfoWrapper">
			<cfif len(local.$.content('fileID')) && local.$.showImageInList(local.$.content('fileEXT'))>
				<div class="locationImageWrapper"><img class="locationImage imgMed" src="#local.$.content().getImageURL(size='medium')#" alt="#HTMLEditFormat(local.$.content('title'))#" /></div>
			</cfif>
			#local.place.getMicrodata()#
		</div><!-- /.locationInfoWrapper -->
		#local.gMap.getMap()#
	</div><!-- /.muraLocationOuterWrapper -->
</cfoutput>