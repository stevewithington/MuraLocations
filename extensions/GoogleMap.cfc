/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2015 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
component accessors=true output=false {

	property name='places' type='array' hint='an array of places with each one formatted as an array of structs [{"placename"="PlaceName","lat"="Lat","lng"="Lng","zindex"="ZIndex","icon"="Icon","infowindow"="InfoWindow"}]';
	property name='displayDirections' type='boolean' default=true;
	property name='displayTravelMode' type='boolean' default=true;
	property name='mapHeight' type='numeric' default=400;
	property name='mapType' type='string' default='TERRAIN';
	property name='mapWidth' type='numeric' default=0;
	property name='mapZoom' type='string' default='default';
	property name='start' type='string' default='';
	property name='map';
	property name='displayCategoryFilter' type='boolean' default=true;

	/**
	* init()
	* Constructor
	* @places each place should be formatted as an array of structs: [{'placename'="PlaceName",'lat'="Lat",'lng'="Lng",'zindex'="ZIndex",'icon'="Icon",'infowindow'="InfoWindow"}]
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
		, boolean displayCategoryFilter=true
	) output=false {
		setPlaces(arguments.places);
		setDisplayDirections(arguments.displayDirections);
		setDisplayTravelMode(arguments.displayTravelMode);
		setMapHeight(arguments.mapHeight);
		setMapType(arguments.mapType);
		setMapWidth(arguments.mapWidth);
		setMapZoom(arguments.mapZoom);
		setStart(arguments.start);
		setDisplayCategoryFilter(arguments.displayCategoryFilter);
		setMap(
			places=getPlaces()
			, displayDirections=getDisplayDirections()
			, displayTravelMode=getDisplayTravelMode()
			, mapHeight=getMapHeight()
			, mapType=getMapType()
			, mapWidth=getMapWidth()
			, mapZoom=getMapZoom()
			, start=getStart()
			, displayCategoryFilter=getDisplayCategoryFilter()
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
		, boolean displayCategoryFilter=true
	) output=false {
		var local = {};
		local.str = '';
		local.thisID = Right(LCase(REReplace(CreateUUID(), '-', '', 'all')),11);
		local.mapCanvasID = 'gmap-canvas-' & thisID;
		local.mapDirectionsID = 'gmap-directions-' & thisID;
		local.formID = 'frm-directions-' & thisID;
		arguments.mapWidth = Val(arguments.mapWidth);
		arguments.mapHeight = Val(arguments.mapHeight);

		// validation
		if ( !ListFindNoCase('default^0^1^2^3^4^5^6^7^8^9^10^11^12^13^14^15^16^17^18', arguments.mapZoom, '^') ) {
			arguments.mapZoom = 'default';
		}

		if ( !IsBoolean(arguments.displayDirections) ) {
			arguments.displayDirections = true;
		}

		if ( !IsBoolean(arguments.displayTravelMode) ) {
			arguments.displayTravelMode = true;
		}

		// validate mapType
		local.validMapTypes = 'ROADMAP,SATELLITE,HYBRID,TERRAIN';
		if ( !ListFindNoCase(local.validMapTypes, arguments.mapType) ) {
			arguments.mapType = 'TERRAIN';
		} else {
			arguments.mapType = UCase(arguments.mapType);
		}

		// minimum map width and height attributes
		if ( arguments.mapWidth == 0 ) {
			local.mapWidth = '100%';
		} else if ( arguments.mapWidth > 150 ) {
			local.mapWidth = arguments.mapWidth & 'px';
		} else {
			local.mapWidth = '150px';
		}

		if ( arguments.mapHeight == 0 ) {
			local.mapHeight = '100%';
		} else if ( arguments.mapHeight > 100 ) {
			local.mapHeight = arguments.mapHeight & 'px';
		} else {
			local.mapHeight = '100px';
		}

		savecontent variable='local.str' {
			include 'includes/gmap.cfm';
			include 'includes/gmap-css-scripts.cfm';
		};
		variables.map = local.str;
	}

}