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
	<#local.e# itemprop="location" itemscope itemtype="http://schema.org/Place" class="locationPlace">
		<cfif len(trim(getDetailsURL()))>
			<a class="locationDetailsURL" href="#getDetailsURL()#" itemprop="url" rel="external">
		</cfif>

		<h3 class="locationName"><span itemprop="name">#HTMLEditFormat(getPlaceName())#</span></h3>

		<cfif len(trim(getLocationDistance()))>
			<p class="ui-li-aside"><strong>#getLocationDistance()#</strong> miles</p>
		</cfif>
		<div class="locationAddressWrapper" itemprop="address" itemscope itemtype="http://schema.org/PostalAddress">
			<cfif len(trim(getStreetAddress()))>
				<div class="locationStreetAddress" itemprop="streetAddress">#HTMLEditFormat(getStreetAddress())#</div>
			</cfif>
			<cfif len(trim(getAddressLocality()))>
				<span class="locationAddressLocality" itemprop="addressLocality">#HTMLEditFormat(getAddressLocality())#</span>, 
			</cfif>
			<cfif len(trim(getAddressRegion()))>
				<span class="locationAddressRegion" itemprop="addressRegion">#HTMLEditFormat(getAddressRegion())#</span>
			</cfif>
			<cfif len(trim(getPostalCode()))>
				 <span class="locationPostalCode" itemprop="postalCode">#HTMLEditFormat(getPostalCode())#</span>
			</cfif>
			<cfif len(trim(getLocationNotes()))>
				<div class="locationNotes">#getLocationNotes()#</div>
			</cfif>
		</div><!-- /PostalAddress -->
		<cfif arguments.displayPhone && len(trim(getLocationTelephone()))>
			<div class="locationTelephone"><span itemprop="telephone">#HTMLEditFormat(getLocationTelephone())#</span> <strong>Phone</strong></div>
		</cfif>
		<cfif arguments.displayFax && len(trim(getLocationFaxNumber()))>
			<div class="locationFaxNumber"><span itemprop="faxNumber">#HTMLEditFormat(getLocationFaxNumber())#</span> <strong>Fax</strong></div>
		</cfif>
		<cfif len(trim(getLocationEmail())) && IsValid('email', getLocationEmail())>
			<div class="locationEmail"><a itemprop="email" href="mailto:#HTMLEditFormat(getLocationEmail())#">#HTMLEditFormat(getLocationEmail())#</a></div>
		</cfif>
		<div itemprop="geo" itemscope itemtype="http://schema.org/GeoCoordinates"><meta itemprop="latitude" content="#getLatitude()#" /><meta itemprop="longitude" content="#getLongitude()#" /></div>
		<cfif len(trim(getDetailsURL()))></a></cfif>
	</#local.e#>
</cfoutput>