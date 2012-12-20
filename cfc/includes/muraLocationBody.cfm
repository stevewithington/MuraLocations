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