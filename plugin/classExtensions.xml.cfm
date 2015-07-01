<cfsilent><cfscript>
/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2015 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
* NOTES: 
* Valid Types: Text, TextBox, TextArea, HTMLEditor, SelectBox, MultiSelectBox, RadioGroup, File, Hidden
* 
*/
</cfscript></cfsilent>
<cfoutput>
	<extensions>
		<!-- PAGE: Mura / Location -->
		<extension type="Page" subType="MuraLocation" iconClass="icon-pushpin" hasSummary="false" hasBody="false" hasAssocFile="false" hasConfigurator="false">
			<attributeset name="MuraLocation Options" container="Basic">
				<attribute 
					name="streetAddress"
					label="Street Address"
					hint="The street address of the location."
					type="TextArea"
					defaultValue=""
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				<attribute 
					name="addressLocality"
					label="City / Locality"
					hint="The City or locality of the location."
					type="TextBox"
					defaultValue=""
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				<attribute 
					name="addressRegion"
					label="State / Region"
					hint="The State or Region of the location (e.g., CA for California, etc.)"
					type="TextBox"
					defaultValue=""
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				<attribute 
					name="postalCode"
					label="Postal Code"
					hint="The Postal/Zip Code of the location."
					type="TextBox"
					defaultValue=""
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				<attribute 
					name="addressCountry"
					label="Country"
					hint="The Country of the location"
					type="TextBox"
					defaultValue=""
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				<attribute 
					name="locationTelephone"
					label="Phone"
					hint="The telephone number for this location."
					type="TextBox"
					defaultValue=""
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				<attribute 
					name="locationFaxNumber"
					label="Fax"
					hint="The fax number for this location."
					type="TextBox"
					defaultValue=""
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				<attribute 
					name="locationEmail"
					label="Email"
					hint="The email address for this location."
					type="TextBox"
					defaultValue=""
					required="false"
					validation="email"
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				<attribute 
					name="locationURL"
					label="External URL (include 'http://')"
					hint="If this location has an external URL, enter it here including 'http://'"
					type="TextBox"
					defaultValue=""
					required="false"
					validation=""
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				<attribute 
					name="latitude"
					label="Latitude"
					hint="The Latitude of the location."
					type="TextBox"
					defaultValue=""
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				<attribute 
					name="longitude"
					label="Longitude"
					hint="The Longitude of the location."
					type="TextBox"
					defaultValue=""
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				<attribute 
					name="mapWidth"
					label="Map Width"
					hint="Map width in pixels. Set to 0 for full width!"
					type="TextBox"
					defaultValue="0"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLabelList="" />

				<attribute 
					name="mapHeight"
					label="Map Height"
					hint="Map height in pixels."
					type="TextBox"
					defaultValue="400"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLabelList="" />

				<attribute 
					name="mapZoom"
					label="Default Zoom"
					hint="You can override the default behaviour of auto-fit the location here."
					type="SelectBox"
					defaultValue="default"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="default^0^1^2^3^4^5^6^7^8^9^10^11^12^13^14^15^16^17^18"
					optionLabelList="Auto Fit To Viewport^0 (Fully Zoomed Out-Earth Map)^1^2^3^4^5^6^7^8^9^10^11^12^13^14^15^16^17^18 (Fully Zoomed In)" />

				<attribute 
					name="mapType"
					label="Map Type"
					hint="Type of Google Map to be displayed."
					type="SelectBox"
					defaultValue="ROADMAP"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="ROADMAP^SATELLITE^HYBRID^TERRAIN"
					optionLabelList="Roadmap^Satellite^Hybrid^Terrain" />

				<attribute 
					name="mapInfoWindow"
					label="Info Window"
					hint="If you enter anything here, it will show in the Info Window, otherwise, the Info Window will use the address information entered above."
					type="HTMLEditor"
					defaultValue=""
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLableList="" />

				<attribute 
					name="displayDirections"
					label="Display Directions"
					hint="Should users be able to see directions to the location(s)?"
					type="RadioGroup"
					defaultValue="true"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

				<attribute 
					name="displayTravelMode"
					label="Display Travel Mode Options"
					hint="Should the various travel mode options be displayed when showing directions (e.g. Driving, Walking or Bicycling)?"
					type="RadioGroup"
					defaultValue="true"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

				<attribute 
					name="displayOnAllLocationsMap"
					label="Show on 'All Locations Map' Display Object?"
					hint="Should this location appear on the 'Locations Map' display object? NOTE: If this location is a child of a Folder/MuraLocation, then this location WILL appear on the Folder's map IF the 'Display' setting on the Basic Tab is set to Yes."
					type="RadioGroup"
					defaultValue="true"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />
			</attributeset>
		</extension>

		<!-- FOLDER: Mura / LocationsMap -->
		<extension type="Folder" subType="MuraLocationsMap" availableSubTypes="Page/MuraLocation" iconClass="icon-globe" hasSummary="false" hasBody="false" hasAssocFile="false" hasConfigurator="false">
			<attributeset name="MuraLocationsMap Options" container="Basic">
				<attribute
					name="mapWidth"
					label="Map Width"
					hint="Map width in pixels. Set to 0 for full width!"
					type="TextBox"
					defaultValue="0"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLabelList="" />

				<attribute
					name="mapHeight"
					label="Map Height"
					hint="Map height in pixels."
					type="TextBox"
					defaultValue="400"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList=""
					optionLabelList="" />

				<attribute
					name="mapZoom"
					label="Default Zoom"
					hint="You can override the default behaviour of auto-fit all locations here."
					type="SelectBox"
					defaultValue="default"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="default^0^1^2^3^4^5^6^7^8^9^10^11^12^13^14^15^16^17^18"
					optionLabelList="Auto Fit All Locations To Viewport^0 (Fully Zoomed Out-Earth Map)^1^2^3^4^5^6^7^8^9^10^11^12^13^14^15^16^17^18 (Fully Zoomed In)" />

				<attribute
					name="mapType"
					label="Map Type"
					hint="Type of Google Map to be displayed."
					type="SelectBox"
					defaultValue="ROADMAP"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="ROADMAP^SATELLITE^HYBRID^TERRAIN"
					optionLabelList="Roadmap^Satellite^Hybrid^Terrain" />

				<attribute 
					name="displayCategoryFilter"
					label="Display Category Filter"
					hint="If locations are categorized, should the map filter display?"
					type="RadioGroup"
					defaultValue="true"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

				<attribute
					name="displayDirections"
					label="Display Directions"
					hint="Should users be able to see directions to the location(s)?"
					type="RadioGroup"
					defaultValue="true"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

				<attribute
					name="displayTravelMode"
					label="Display Travel Mode Options"
					hint="Should the various travel mode options be displayed when showing directions (e.g. Driving, Walking or Bicycling)?"
					type="RadioGroup"
					defaultValue="true"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />

				<attribute 
					name="showChildrenOnly"
					label="Show only children of this Folder?"
					hint="Should this map ONLY show MuraLocations that are direct children of this Folder?"
					type="RadioGroup"
					defaultValue="false"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="false^true"
					optionLabelList="No^Yes" />
			</attributeset>
		</extension>
	</extensions>
</cfoutput>