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
local.$.loadShadowboxJS(); // for primary image
</cfscript></cfsilent>
<cfoutput>
	<div class="#local.outerWrapperClass#">

		<!--- Primary Associated Image --->
		<cfif Len(local.$.getURLForImage(local.$.content('fileid')))>
			<cfset local.img = local.$.getURLForImage(fileid = local.$.content('fileid'),size = 'medium') />
			<a id="svAsset" class="mura-asset" href="#local.$.getURLForImage(local.$.content('fileid'))#" title="#HTMLEditFormat(local.$.content('title'))#" rel="shadowbox[body]">
				<img class="imgMed thumbnail" src="#local.img#" alt="#HTMLEditFormat(local.$.content('title'))#">
			</a>
		</cfif>

		<!--- Content --->
		#local.$.renderEditableAttribute(
			attribute='body'
			, type='HTMLEditor'
			, label='Content'
			, enableMuraTag=true
		)#
		
		<!--- Location Info --->
		<!--- <div class="locationInfoWrapper">
			<cfif len(local.$.content('fileID')) && local.$.showImageInList(local.$.content('fileEXT'))>
				<div class="locationImageWrapper"><img class="locationImage imgMed" src="#local.$.content().getImageURL(size='medium')#" alt="#HTMLEditFormat(local.$.content('title'))#" /></div>
			</cfif>
			#local.place.getMicrodata()#
		</div> ---><!-- /.locationInfoWrapper -->

		<!--- GMap --->
		#local.gMap.getMap()#

	</div><!-- /.muraLocationOuterWrapper -->
</cfoutput>