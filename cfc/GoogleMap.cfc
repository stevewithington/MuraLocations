/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2012 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
component accessors=true output=false {

	property name='places' type='array' hint='an array of places with each one formatted as ["PlaceName","Lat","Lng","ZIndex","Icon","InfoWindow"]';
	property name='displayDirections' type='boolean' default=true;
	property name='displayTravelMode' type='boolean' default=true;
	property name='mapHeight' type='numeric' default=400;
	property name='mapType' type='string' default='TERRAIN';
	property name='mapWidth' type='numeric' default=0;
	property name='mapZoom' type='string' default='default';
	property name='start' type='string' default='';
	property name='map';

	/**
	* init()
	* Constructor
	* @places each place should be formatted as: ["PlaceName","Lat","Lng","ZIndex","Icon","InfoWindow"]
	*/
	public GoogleMap function init(
		required array places
		, boolean displayDirections=true
		, boolean displayTravelMode=true
		, numeric mapHeight=400
		, string mapType='TERRAIN'
		, numeric mapWidth=0
		, string mapZoom='default'
		, string start=''
	) output=false {
		setPlaces(arguments.places);
		setDisplayDirections(arguments.displayDirections);
		setDisplayTravelMode(arguments.displayTravelMode);
		setMapHeight(arguments.mapHeight);
		setMapType(arguments.mapType);
		setMapWidth(arguments.mapWidth);
		setMapZoom(arguments.mapZoom);
		setStart(arguments.start);
		setMap(
			places=getPlaces()
			, displayDirections=getDisplayDirections()
			, displayTravelMode=getDisplayTravelMode()
			, mapHeight=getMapHeight()
			, mapType=getMapType()
			, mapWidth=getMapWidth()
			, mapZoom=getMapZoom()
			, start=getStart()
		);
		return this;
	}

	/**
	* setMap()
	*/
	private void function setMap(
		required array places
		, boolean displayDirections=true
		, boolean displayTravelMode=true
		, numeric mapHeight=400
		, numeric mapInfoWindowMaxWidth=300
		, string mapType='TERRAIN'
		, numeric mapWidth=0
		, string mapZoom='default'
		, string start=''
	) output=false {
		var local = {};
		local.str = '';
		local.thisID = Right(LCase(REReplace(CreateUUID(), '-', '', 'all')),11);
		local.mapCanvasID = 'gmapCanvas_' & thisID;
		local.mapDirectionsID = 'gmapDirections_' & thisID;
		local.formID = 'frmDirections_' & thisID;
		arguments.mapWidth = Val(arguments.mapWidth);
		arguments.mapHeight = Val(arguments.mapHeight);

		// validation
		if ( !ListFindNoCase('default^0^1^2^3^4^5^6^7^8^9^10^11^12^13^14^15^16^17^18', arguments.mapZoom, '^') ) {
			arguments.mapZoom = 'default';
		};

		if ( !IsBoolean(arguments.displayDirections) ) {
			arguments.displayDirections = true;
		};

		if ( !IsBoolean(arguments.displayTravelMode) ) {
			arguments.displayTravelMode = true;
		};

		// validate mapType
		local.validMapTypes = 'ROADMAP,SATELLITE,HYBRID,TERRAIN';
		if ( !ListFindNoCase(local.validMapTypes, arguments.mapType) ) {
			arguments.mapType = 'TERRAIN';
		} else {
			arguments.mapType = UCase(arguments.mapType);
		};

		// minimum map width and height attributes
		if ( arguments.mapWidth == 0 ) {
			local.mapWidth = '100%';
		} else if ( arguments.mapWidth > 150 ) {
			local.mapWidth = arguments.mapWidth & 'px';
		} else {
			local.mapWidth = '150px';
		};

		if ( arguments.mapHeight == 0 ) {
			local.mapHeight = '100%';
		} else if ( arguments.mapHeight > 100 ) {
			local.mapHeight = arguments.mapHeight & 'px';
		} else {
			local.mapHeight = '100px';
		};

		savecontent variable='local.str' {
			include 'includes/gmap.cfm';
			include 'includes/gmapScript.cfm';
		};
		variables.map = local.str;
	}

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