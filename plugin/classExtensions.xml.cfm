<cfsilent><cfscript>
/**
* 
* This file is part of MuraLocations TM
* (c) Stephen J. Withington, Jr. | www.stephenwithington.com
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
*
* 
* Valid Types: Text, TextBox, TextArea, HTMLEditor, SelectBox, MultiSelectBox, RadioGroup, File, Hidden
* 
*/
</cfscript></cfsilent>
<cfoutput>
	<extensions>
		<!-- PAGE: Mura / Location -->
		<extension type="Page" subType="MuraLocation">
			<attributeset name="MuraLocation Options">

				<attribute 
					name="streetAddress"
					label="Street Address"
					hint="The street address of the location."
					type="TextBox"
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
					hint="The State or Region of the location (e.g., CA for California, UK for United Kingdom, etc.)"
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

				<!--
				<attribute 
					name="locationNotes"
					label="Location Notes"
					hint="Notes to appear in the map's Info Window."
					type="HTMLEditor"
					defaultValue=""
					required="false"
					validation=""
					regex=""
					message=""
					optionList=""
					optionLableList="" />
				-->

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
					defaultValue="TERRAIN"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="ROADMAP^SATELLITE^HYBRID^TERRAIN"
					optionLabelList="Roadmap^Satellite^Hybrid^Terrain" />

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
					hint="Should this location appear on the 'Locations Map' display object? NOTE: If this location is a child of a Portal/MuraLocation, then this location WILL appear on the Portal's map IF the 'Display' setting on the Basic Tab is set to Yes."
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

		<!-- PORTAL: Mura / Location -->
		<extension type="Portal" subType="MuraLocation">
			<attributeset name="MuraLocation Options">

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
					defaultValue="TERRAIN"
					required="false"
					validation="None"
					regex=""
					message=""
					optionList="ROADMAP^SATELLITE^HYBRID^TERRAIN"
					optionLabelList="Roadmap^Satellite^Hybrid^Terrain" />

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
					label="Show only children of this Portal?"
					hint="Should this map ONLY show MuraLocations that are direct children of this Portal?"
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