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
*/
component accessors=true output=false {
	
	property name='placeName' type='string';
	property name='latitude' type='numeric';
	property name='longitude' type='numeric';
	property name='zIndex' default=99 type='numeric';
	property name='icon' default='' type='string' hint='future: allow for custom icon to be uploaded for each location.';
	property name='streetAddress' default='' type='string' hint='street';
	property name='addressLocality' default='' type='string' hint='city';
	property name='addressRegion' default='' type='string' hint='state';
	property name='postalCode' default='' type='string' hint='zip';
	property name='locationNotes' default='' type='string' hint='notes';
	property name='detailsURL' default='' type='string';
	property name='mapURL' default='' type='string';
	property name='locationTelephone' default='' type='string';
	property name='locationFaxNumber' default='' type='string';
	property name='locationEmail' default='' type='string';
	property name='locationDistance' default='' type='any';
	property name='microDataFormat' default='li' type='string';
	property name='infoWindow' default='' type='string';

	/**
	* init()
	* @latitude latitude in decimal degrees
	* @longitude longitude in decimal degrees
	* @streetAddress street
	* @addressLocality city
	* @addressRegion state
	* @postalCode zip
	* @locationNotes brief notes or information to listed beneath the location address (e.g., Located inside Walmart)
	* @microdataFormat getMicrodata() will return each Place wrapped in either 'li', 'span' or 'div'...the only valid options at this time
	*/
	public Place function init(
		required string placeName
		, required numeric latitude
		, required numeric longitude
		, numeric zIndex=99
		, string icon=''
		, string streetAddress=''
		, string addressLocality=''
		, string addressRegion=''
		, string postalCode=''
		, string locationNotes=''
		, string detailsURL=''
		, string mapURL=''
		, string locationTelephone=''
		, string locationFaxNumber=''
		, string locationEmail=''
		, any locationDistance=''
		, string microDataFormat='div'
		, string infoWindow=''
	) output=false {
		setPlaceName(arguments.placeName);
		setLatitude(arguments.latitude);
		setLongitude(arguments.longitude);
		setZIndex(arguments.zIndex);
		setIcon(arguments.icon);
		setStreetAddress(arguments.streetAddress);
		setAddressLocality(arguments.addressLocality);
		setAddressRegion(arguments.addressRegion);
		setPostalCode(arguments.postalCode);
		setLocationNotes(arguments.locationNotes);
		setDetailsURL(arguments.detailsURL);
		setMapURL(arguments.mapURL);
		setLocationTelephone(arguments.locationTelephone);
		setLocationFaxNumber(arguments.locationFaxNumber);
		setLocationEmail(arguments.locationEmail);
		setLocationDistance(arguments.locationDistance);
		setMicroDataFormat(arguments.microDataFormat);
		setInfoWindow(arguments.infoWindow);
		return this;
	};
	
	/**
	* setInfoWindow()
	* Auto-generated infoWindow content, if none passed in
	*/
	public any function setInfoWindow(string infoWindow='') output=false {
		var local = {};
		// future implementation could allow for custom infoWindow contents
		if ( len(trim(arguments.infoWindow)) ) {
			variables.infoWindow = arguments.infoWindow;
		} else {
			variables.infoWindow = getMicrodata();
		};
	};
	
	/**
	* gMapPoint()
	* Used for populating a Google Map...will be serialized as JSON array first
	*/
	public any function gMapPoint() output=false {
		return [getPlaceName(),getLatitude(),getLongitude(),getZIndex(),getIcon(),getInfoWindow()];
	};
	
	/**
	* getMicrodata()
	* Get microdata/schema formatted html for SEO
	*/
	public any function getMicrodata(
		boolean displayPhone=true
		, boolean displayFax=true
	) output=false {
		var local = {};
		
		switch( getMicroDataFormat() ) {
			case 'li' :
				local.e = 'li';
				break;
			case 'span' : 
				local.e = 'span';
				break;
			default :
				local.e = 'div';
		};
		
		savecontent variable='local.str' {
			WriteOutput('<#local.e# itemprop="location" itemscope itemtype="http://schema.org/Place" class="locationPlace">');

				if ( len(trim(getDetailsURL())) ){
					WriteOutput('<a class="locationDetailsURL" href="#getDetailsURL()#" itemprop="url" rel="external">');	
				};

				WriteOutput('<h3 class="locationName"><span itemprop="name">#HTMLEditFormat(getPlaceName())#</span></h3>');
				if ( len(trim(getLocationDistance())) ) {
					WriteOutput('<p class="ui-li-aside"><strong>#getLocationDistance()#</strong> miles</p>');
				};
				WriteOutput('<div class="locationAddressWrapper" itemprop="address" itemscope itemtype="http://schema.org/PostalAddress">');
					if ( len(trim(getStreetAddress())) ) {
						WriteOutput('<div class="locationStreetAddress" itemprop="streetAddress">#HTMLEditFormat(getStreetAddress())#</div>');
					};
					if ( len(trim(getAddressLocality())) ) {
						WriteOutput('<span class="locationAddressLocality" itemprop="addressLocality">#HTMLEditFormat(getAddressLocality())#</span>, ');
					}; 
					if ( len(trim(getAddressRegion())) ) {
						WriteOutput('<span class="locationAddressRegion" itemprop="addressRegion">#HTMLEditFormat(getAddressRegion())#</span>');
					};
					if ( len(trim(getPostalCode())) ) {
						WriteOutput(' <span class="locationPostalCode" itemprop="postalCode">#HTMLEditFormat(getPostalCode())#</span>');
					};
					if ( len(trim(getLocationNotes())) ) {
						WriteOutput('<div class="locationNotes">#getLocationNotes()#</div>');
					};
				WriteOutput('</div>'); // @end PostalAddress
				if ( arguments.displayPhone && len(trim(getLocationTelephone())) ) {
					WriteOutput('<div class="locationTelephone"><span itemprop="telephone">#HTMLEditFormat(getLocationTelephone())#</span> <strong>Phone</strong></div>');
				};
				if ( arguments.displayFax && len(trim(getLocationFaxNumber())) ) {
					WriteOutput('<div class="locationFaxNumber"><span itemprop="faxNumber">#HTMLEditFormat(getLocationFaxNumber())#</span> <strong>Fax</strong></div>');
				};

				if ( len(trim(getLocationEmail())) && IsValid('email', getLocationEmail()) ) {
					WriteOutput('<div class="locationEmail"><a itemprop="email" href="mailto:#HTMLEditFormat(getLocationEmail())#">#HTMLEditFormat(getLocationEmail())#</a></div>');
				};
			
				WriteOutput('<div itemprop="geo" itemscope itemtype="http://schema.org/GeoCoordinates"><meta itemprop="latitude" content="#getLatitude()#" /><meta itemprop="longitude" content="#getLongitude()#" /></div>');

				if ( len(trim(getDetailsURL())) ){
					WriteOutput('</a>');	
				};
			WriteOutput('</#local.e#>');
		};
		return Trim(local.str);
	};

	/**
	* getProperties()
	* Metadata property inspector
	*/
	public any function getProperties() output=false {
		var local = {};
		local.properties = {};
		local.data = getMetaData(this).properties;
		for ( local.i=1; local.i <= ArrayLen(local.data); local.i++ ) {
			local.properties[local.data[local.i].name] = Evaluate('get#local.data[local.i].name#()');
		};
		return local.properties;
	};

}