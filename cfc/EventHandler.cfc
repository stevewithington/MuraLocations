/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2012 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
component extends="mura.plugin.pluginGenericEventHandler" accessors=true output=false {

	property name='$' hint='mura scope';
	
	/**
	* onApplicationLoad()
	*/
	public void function onApplicationLoad(required struct $) output=false {
		var local = {};
		set$(arguments.$);
		variables.pluginConfig.addEventHandler(this);
	}

	/**
	* onSiteRequestStart()
	*/
	public void function onSiteRequestStart(required struct $) output=false {
		var local = {};
		arguments.$.setCustomMuraScopeKey('muraLocations', this);
		set$(arguments.$);
	}
	
	/**
	* onRenderStart()
	*/
	public void function onRenderStart(required struct $) output=false {
		var local = {};
		set$(arguments.$);
		arguments.$.loadJSLib();
		// we need to load the main scripts everytime especially if using jQuery Mobile
		variables.pluginConfig.addToHTMLFootQueue('scripts/inc.cfm');
	}
	
	/**
	* onPageMuraLocationBodyRender()
	* NOTE: This is the method that you would want to customize
	* for final output to the browser.
	*/
	public any function onPageMuraLocationBodyRender(required struct $) output=false {
		var local = {};
		set$(arguments.$);
		local.$ = arguments.$;
		local.body = local.$.setDynamicContent($.content('body'));
		
		// build the map, directions, etc.
		local.places = [];
		local.place = new Place(
			placeName = local.$.content('title')
			,latitude = local.$.content('latitude')
			,longitude = local.$.content('longitude')
			,streetAddress = local.$.content('streetAddress')
			,addressLocality = local.$.content('addressLocality')
			,addressRegion = local.$.content('addressRegion')
			,postalCode = local.$.content('postalCode')
			,locationNotes = local.$.content('locationNotes')
			,locationTelephone = local.$.content('locationTelephone')
			,locationFaxNumber = local.$.content('locationFaxNumber')
			,locationEmail = local.$.content('locationEmail')
		);
		
		ArrayAppend(local.places, local.place.gMapPoint());

		local.gMap = new GoogleMap(
			places=local.places
			, mapType = local.$.content('mapType')
			, displayDirections = local.$.content('displayDirections')
			, displayTravelMode = local.$.content('displayTravelMode')
			, start = local.$.event('start')
			, mapWidth = local.$.content('mapWidth')
			, mapHeight = local.$.content('mapHeight')
			, mapZoom = local.$.content('mapZoom')
		);
		
		// if you don't need anything fancy, just use this:
		//return local.body & local.gMap.getMap();

		local.outerWrapperClass = local.$.event('muraMobileRequest') ? 'muraLocationOuterWrapperMobile' : 'muraLocationOuterWrapper';

		savecontent variable='local.str' {
			include 'includes/muraLocationBody.cfm';
		}; // @END local.str

		return local.str;
	}

	/**
	* onBeforePageMuraLocationSave()
	*/
	public void function onBeforePageMuraLocationSave(required struct $) output=false {
		var local = {};
		set$(arguments.$);
		local.bean = get$().event('newBean');

		// check for missing latitude and longitude
		if ( !len(trim(local.bean.getValue('latitude'))) || !len(trim(local.bean.getValue('longitude'))) ) {
			
			// gather up the address
			local.q = local.bean.getValue('streetAddress') & ',' 
				& local.bean.getValue('addressLocality') & ',' 
				& local.bean.getValue('addressRegion') & ' ' 
				& local.bean.getValue('postalCode');
			// geoencode the address
			local.geo = new Geo();
			local.geoResponse = local.geo.getResponse(local.q);
			
			if ( StructKeyExists(local.geoResponse, 'results') ) {
				
				local.matches = ArrayLen(local.geoResponse.results);
				
				if ( !local.matches ) {
					// no results!
					local.errorMessage = 'The address you entered could not be converted to a usable location for mapping. Please check the address fields on the Extended Attributes Tab and try again.';
				} else if ( local.matches > 1 ) {
					// more than one match found for this address...need to narrow the results to get the right one
					local.results = local.geoResponse.results;
					
					// sometimes, identical formatted_addresses are returned, but with different
					// geographic centers
					if ( local.matches == 2 && local.results[1].formatted_address == local.results[2].formatted_address  ) {
						// if there are only 2 results, and the 'formatted_address' is the same,
						// we'll assume it's the first element in the array...so continue
					} else {
						local.errorMessage = 'There were #local.matches# possible matches found for the address you entered. Please review the following list of locations and re-enter your address accordingly on the Extended Attributes Tab:<br><br>';

						for ( local.i=1; local.i <= local.matches; local.i++ ) {
							local.errorMessage = local.errorMessage & '&bull;&nbsp;' & local.results[i].formatted_address & '<br>';
						};
					};
				};
			} else { // NO MATCHES!
				// Maybe user is not connected to the internet?
				local.errorMessage = 'Sorry...we were unable to connect to Google to geoencode the address you entered on the Extended Attributes Tab. Please check your internet connection and try again.';
			};

		};
		
		// Errors
		if ( StructKeyExists(local, 'errorMessage') ) {
			// Create a user-friendly error message to display on the Edit Content screen.
			// Requires Mura 5.6.xxxx
			local.v = get$().globalConfig('version');
			if ( ListFirst(local.v, '.') >= 6 || ListGetAt(local.v, 2, '.') >= 6 ) {
				get$().event('contentBean').getErrors().muraLocationError = local.errorMessage;
			} else {
				WriteDump(var=local.errorMessage, abort=true);
			};
		} else {
			// No Errors, so we're good!
			// If the content already has a Lat and Lng, then geoResponse won't be defined
			if ( StructKeyExists(local, 'geoResponse') ) {
				local.bean.setLatitude( local.geoResponse.results[1].geometry.location.lat );
				local.bean.setLongitude( local.geoResponse.results[1].geometry.location.lng );
			};
		};
	}

	/**
	* onPortalMuraLocationBodyRender()
	*/
	public any function onPortalMuraLocationBodyRender(required struct $) output=false {
		var local = {};
		set$(arguments.$);
		local.body = get$().setDynamicContent(get$().content('body'));
		return local.body & dspLocationsMap(
			mapType = get$().content('mapType')
			, displayDirections = get$().content('displayDirections')
			, displayTravelMode = get$().content('displayTravelMode')
			, start = get$().event('start')
			, mapWidth = get$().content('mapWidth')
			, mapHeight = get$().content('mapHeight')
			, mapZoom = get$().content('mapZoom')
		);
	}
	
	/**
	* onFindLocations()
	*/
	public any function onFindLocations(required struct $) output=false {
		var local = {};
		set$(arguments.$);
		if ( len(trim(get$().event('currentLocation'))) ) {
			local.geo = new Geo();
			local.response = local.geo.getResponse(get$().event('currentLocation'));
			get$().event('geoResponse', local.response);

			if (IsStruct(local.response) && StructKeyExists(local.response, 'results')) {
				get$().event('geoMatches',ArrayLen(local.response.results));
			} else {
				get$().event('geoMatches',0);
			};
		};		
	}

	/**
	* dspFindLocationsForm()
	*/
	public any function dspFindLocationsForm() output=false {
		var local = {};
		// this is necessary so that if being used as a display object
		if ( StructKeyExists(arguments, '$') ) {
			set$(arguments.$);
		};
		if (!IsBoolean(get$().event('findLocationRequestSubmitted'))){
			get$().event('findLocationRequestSubmitted',false);
		};
		if (get$().event('findLocationRequestSubmitted')){
			get$().announceEvent('onFindLocations',get$());
		};

		savecontent variable='local.str' {
			include 'includes/findLocationsForm.cfm';
		}; 
		return local.str;
	}
	
	/**
	* dspClosestLocations()
	*/
	public any function dspClosestLocations(required struct $) output=false {
		var local = {};
		set$($);
		local.isMobile = get$().event('muraMobileRequest');
		local.microDataFormat = local.isMobile ? 'li' : 'div';
		local.result = get$().event('geoResponse').results[1];
		local.currentAddress = local.result.formatted_address;
		get$().event('start',local.currentAddress);
		local.currentLatLng = local.result.geometry.location.lat & ',' & local.result.geometry.location.lng;
		local.rs = $.muraLocations.getClosestMuraLocations(currentLocation=local.currentLatLng);
	
		savecontent variable='local.str' {

			if ( !local.rs.recordcount ) {
				WriteOutput('<div class="subheading">Sorry, no locations were found near #HTMLEditFormat($.event('start'))#. Please try again.</div>');
			} else {
				if ( IsBoolean(get$().event('usingGeolocation')) && get$().event('usingGeolocation') ) {
					get$().event('currentLocation',local.currentAddress);
				};
				WriteOutput('<div class="subheading">Locations nearest: <em>#HTMLEditFormat($.event('start'))#</em></div>');
			};

			if ( local.isMobile ) {
				WriteOutput('<ul data-role="listview" data-inset="true" data-theme="b" data-content-theme="d">');
			} else {
				WriteOutput('<div data-role="collapsible-set" data-theme="b" data-content-theme="d">');
			};
		
			for (local.i=1; local.i <= local.rs.recordcount; local.i++) {
				local.expand = false;
				if ( local.i eq 1 ) { 
					local.expand = true;
				};
				local.item = get$().getBean('content').loadBy(contentid=local.rs.contentid[local.i]);
				local.detailsURL = get$().createHREF(filename=local.item.getValue('filename'));
				if ( len(trim(get$().event('start'))) ) {
					local.detailsURL = local.detailsURL & '?start=' & URLEncodedFormat(get$().event('start'));
				};
				local.place = new Place(
					placeName = local.item.getValue('title')
					,latitude = local.item.getValue('latitude')
					,longitude = local.item.getValue('longitude')
					,streetAddress = local.item.getValue('streetAddress')
					,addressLocality = local.item.getValue('addressLocality')
					,addressRegion = local.item.getValue('addressRegion')
					,postalCode = local.item.getValue('postalCode')
					,locationTelephone = local.item.getValue('locationTelephone')
					,locationFaxNumber = local.item.getValue('locationFaxNumber')
					,locationEmail = local.item.getValue('locationEmail')
					,detailsURL = local.detailsURL
					,mapURL = getMapURL(local.item.getValue('latitude'),local.item.getValue('longitude'))
					,locationDistance = local.rs.distance[local.i]
					,microDataFormat = local.microDataFormat
				);
				WriteOutput(local.place.getMicrodata(expand=local.expand));
			};
			if ( local.isMobile ) {
				WriteOutput('</ul>');
				WriteOutput('<a href="#get$().content('url')#" data-role="button" data-icon="search" data-theme="e" rel="external">Search Again</a>');

			} else {
				WriteOutput('</div>');
				WriteOutput('<div class="searchAgainWrapper"><a class="geoButton" href="#get$().content('url')#">Search Again</a></div>');
			};
		};
		return local.str;
	}
	
	/**
	* dspLocationsMap()
	* Returns a Google Map of all of Page/MuraLocation's along with the ability to get directions, etc.
	*/
	public any function dspLocationsMap(
		boolean displayDirections=true
		, boolean displayTravelMode=true
		, string start=''
		, numeric mapHeight=400
		, string mapType='TERRAIN'
		, numeric mapWidth=0
		, string mapZoom='default'
	) output=false {
		var local = {};

		// if being used as a display object, we need to set $ locally so we can use get$() in other methods
		if ( StructKeyExists(arguments, '$') ) {
			set$(arguments.$);
		};
		
		// used to populate the 'from' point on the form
		if ( !len(trim(arguments.start)) ) {
			if ( len(trim(get$().event('start'))) ) {
				arguments.start = get$().event('start');
			} else if ( len(trim(get$().event('currentLocation'))) ) {
				arguments.start = get$().event('currentLocation');
			};
		};

		local.places = ArrayNew(1);
		local.fBean = getMuraLocationsBean($=get$());
		// get the feed's iterator
		local.it = local.fBean.getIterator();
		// if no locations, return empty string
		if ( !local.it.hasNext() ) { return ''; };
		
		// loop over each Page/MuraLocation and add it to the places array
		while ( local.it.hasNext() ) {
			local.item = local.it.next();

			if ( get$().content('type') == 'Portal' || YesNoFormat(local.item.getValue('displayOnAllLocationsMap')) ) {
				local.lat = local.item.getValue('latitude');
				local.lng = local.item.getValue('longitude');
				// if viewing via mobile device that may have mapping capabilities, try to provide a device-native link to view the map
				local.mapURL = getMapURL(latitude=local.lat, longitude=local.lng);
				local.detailsURL = local.item.getValue('url');
				if ( len(trim(arguments.start)) ) {
					local.detailsURL = local.detailsURL & '?start=' & URLEncodedFormat(arguments.start);
				};

				local.place = new Place(
					placeName = local.item.getValue('title')
					,latitude = local.lat
					,longitude = local.lng
					,streetAddress = local.item.getValue('streetAddress')
					,addressLocality = local.item.getValue('addressLocality')
					,addressRegion = local.item.getValue('addressRegion')
					,postalCode = local.item.getValue('postalCode')
					,locationTelephone = local.item.getValue('locationTelephone')
					,locationFaxNumber = local.item.getValue('locationFaxNumber')
					,locationEmail = local.item.getValue('locationEmail')
					,zIndex = local.it.currentRow()
					,detailsURL = local.detailsURL
					,mapURL = local.mapURL
				);
				ArrayAppend(local.places, local.place.gMapPoint());
			};
		};
		
		// create a new Google Map with the array of places
		local.gMap = new GoogleMap(
			places=local.places
			,mapType = arguments.mapType
			,displayDirections = arguments.displayDirections
			,displayTravelMode = arguments.displayTravelMode
			,start = arguments.start
			,mapWidth = arguments.mapWidth
			,mapHeight = arguments.mapHeight
			,mapZoom = arguments.mapZoom
		);

		return local.gMap.getMap();
    }
    
    /**
	* getMuraLocationsBean()
	*/
	public any function getMuraLocationsBean() output=false {
		var local = {};
		if ( StructKeyExists(arguments, '$') ) {
			set$(arguments.$);
		};
		
		// create a dynamic feed of all Page/MuraLocation subtypes
		local.fBean = get$().getBean('feed');
		local.fBean.setName('');
		local.fBean.setSortBy('title');
		local.fBean.setSortDirection('asc');
		local.fBean.setMaxItems(0); // 0 = unlimited
		local.fBean.setShowNavOnly(true); // set to false to include content even if it's not in the navigation

		// If we're on a Portal: Mura/Location, then check to see if we only want to display children of this portal...otherwise, we'll include all locations.
		if ( get$().content('type') == 'Portal' && get$().content('subtype') == 'MuraLocation' && YesNoFormat(get$().content('showChildrenOnly')) ) {
			local.fBean.addAdvancedParam(
				relationship='AND'
				, field='tcontent.parentid'
				, condition='eq'
				, criteria=get$().content('contentid')
			);
		};

		local.fBean.addParam(
			relationship='AND'
			,field='tcontent.Type'
			,criteria='Page'
			,dataType='varchar'
		);
		local.fBean.addParam(
			relationship='AND'
			,field='tcontent.SubType'
			,criteria='MuraLocation'
			,dataType='varchar'
		);

		return local.fBean;
	}
	
	/**
	* getClosestMuraLocations()
	* @currentLocation the starting location
	* @maxLocations the maximum number of locations to return
	*/
	public any function getClosestMuraLocations(
		required currentLocation
		, numeric maxLocations=5
	) output=false {
		var q = '';
		var local = {};
		var rs = QueryNew('contentid,latitude,longitude,distance');

		local.geo = new Geo();
		local.currentLatLng = local.geo.getLatLng(q=arguments.currentLocation);
		local.it = getMuraLocationsBean().getIterator();

		while ( local.it.hasNext() ) {
			local.item = local.it.next();
			local.thisDistance = local.geo.getVincentyDistance(
				lat1 = ListFirst(local.currentLatLng)
				,lon1 = ListLast(local.currentLatLng)
				,lat2 = local.item.getValue('latitude')
				,lon2 = local.item.getValue('longitude')
				,units = 'sm'
			);
			QueryAddRow(rs);
			QuerySetCell(rs, 'contentid', local.item.getValue('contentid'));
			QuerySetCell(rs, 'latitude', local.item.getValue('latitude'));
			QuerySetCell(rs, 'longitude', local.item.getValue('longitude'));
			QuerySetCell(rs, 'distance', NumberFormat(local.thisDistance,.99));
		};
		
		q = new Query();
		q.setDBType('query');
		q.setAttributes(rs=rs);
		q.addParam(name='distance', value='123456789', cfsqltype='cf_sql_numeric');
		q.setSQL('SELECT * FROM rs WHERE distance <> :distance');
		rs = q.execute().getResult();
		
		q = new Query();
		q.setDBType('query');
		q.setAttributes(rs=rs);
		q.setMaxRows(arguments.maxLocations);
		q.setSQL('SELECT * FROM rs ORDER BY distance ASC');
		rs = q.execute().getResult();
		
		return local.rs;
	}

    /**
    * addScripts()
    */
    private void function addScripts() output=false {
		get$().loadJSLib();
		variables.pluginConfig.addToHTMLFootQueue('scripts/inc.cfm');
	}
    
    /**
	* getMapURL()
	*/
	public string function getMapURL(
   		required numeric latitude
   		, required numeric longitude
   	) output=false {
    	var mobile = new MobileDetect();
    	var local = {};

    	local.baseURL = 'https://maps.google.com/?q=';
    	local.coords = URLEncodedFormat(arguments.latitude & ',' & arguments.longitude);

    	if ( mobile.getIsIphone() ) { // iPhone
    		return 'https://maps.google.com/?saddr=Current%20Location&daddr=' & local.coords;
    	} else if ( mobile.getIsAndroid() ) { // android
    		return 'geo:' & local.coords;
    	} else if ( mobile.getIsWinPhone7() || mobile.getIsIEMobile() ) { // win
    		return 'maps:' & local.coords;
    	} else if ( mobile.getIsBlackberry() ) { // blackberry
    		local.lat = arguments.latitude * 100000;
    		local.lng = arguments.longitude * 100000;
    		return 'javascript:blackberry.launch.newMap({"latitude":#local.lat#,"longitude":#local.lng#})';
    	} else if ( get$().event('muraMobileRequest') ) { // if viewing as mobile on browser
    		return local.baseURL & local.coords;
    	} else {
	    	return '';
	    };
    }

}