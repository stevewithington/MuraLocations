/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2014 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
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
	property name='locationImage' default='' type='string';
	property name='locationDistance' default='' type='any';
	property name='microDataFormat' default='li' type='string';
	property name='infoWindow' default='' type='string';
	property name='isMobile' default=false type='boolean';

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
	* @locationImage URL to an image of the location
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
		, string locationImage=''
		, any locationDistance=''
		, string microDataFormat='div'
		, string infoWindow=''
		, boolean isMobile=false
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
		setLocationImage(arguments.locationImage);
		setLocationDistance(arguments.locationDistance);
		setMicroDataFormat(arguments.microDataFormat);
		setInfoWindow(arguments.infoWindow);
		setIsMobile(arguments.isMobile);
		return this;
	}
	
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
	}
	
	/**
	* gMapPoint()
	* Used for populating a Google Map...will be serialized as JSON array first
	*/
	public any function gMapPoint() output=false {
		return [getPlaceName(),getLatitude(),getLongitude(),getZIndex(),getIcon(),getInfoWindow()];
	}
	
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
			if ( getIsMobile() ) {
				include 'includes/place-mobile.cfm';
			} else {
				include 'includes/place.cfm';
			}
		};

		return Trim(local.str);
	}

	public any function getPlaceName() output=false { return variables.placeName; }
	public any function getLatitude() output=false { return variables.latitude; }
	public any function getLongitude() output=false { return variables.longitude; }
	public any function getZIndex() output=false { return variables.ZIndex; }
	public any function getIcon() output=false { return variables.icon; }
	public any function getStreetAddress() output=false { return variables.streetAddress; }
	public any function getAddressLocality() output=false { return variables.addressLocality; }
	public any function getAddressRegion() output=false { return variables.addressRegion; }
	public any function getPostalCode() output=false { return variables.postalCode; }
	public any function getLocationNotes() output=false { return variables.locationNotes; }
	public any function getDetailsURL() output=false { return variables.detailsURL; }
	public any function getMapURL() output=false { return variables.mapURL; }
	public any function getLocationTelephone() output=false { return variables.locationTelephone; }
	public any function getLocationFaxNumber() output=false { return variables.locationFaxNumber; }
	public any function getLocationEmail() output=false { return variables.locationEmail; }
	public any function getLocationImage() output=false { return variables.locationImage; }
	public any function getLocationDistance() output=false { return variables.locationDistance; }
	public any function getMicroDataFormat() output=false { return variables.microDataFormat; }
	public any function getInfoWindow() output=false { return variables.infoWindow; }
	public any function getIsMobile() output=false { return StructKeyExists(variables, 'isMobile') ?variables.isMobile : false; }

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
	}

}