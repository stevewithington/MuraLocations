/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2014 Stephen J. Withington, Jr.
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
		local.isMobile = getIsMobile();
		local.body = get$().setDynamicContent($.content('body'));
		local.image = get$().getURLForImage(
			fileid = get$().content('fileid')
			, size = 'small'
			, complete = true
		);

		// build the map, directions, etc.
		local.places = [];
		local.place = new Place(
			placeName = get$().content('title')
			, latitude = get$().content('latitude')
			, longitude = get$().content('longitude')
			, streetAddress = get$().content('streetAddress')
			, addressLocality = get$().content('addressLocality')
			, addressRegion = get$().content('addressRegion')
			, postalCode = get$().content('postalCode')
			, locationNotes = get$().content('locationNotes')
			, locationTelephone = get$().content('locationTelephone')
			, locationFaxNumber = get$().content('locationFaxNumber')
			, locationEmail = get$().content('locationEmail')
			, locationImage = local.image
			, isMobile = local.isMobile
		);
		
		ArrayAppend(local.places, local.place.gMapPoint());

		local.gMap = new GoogleMap(
			places=local.places
			, mapType = get$().content('mapType')
			, displayDirections = get$().content('displayDirections')
			, displayTravelMode = get$().content('displayTravelMode')
			, start = get$().event('start')
			, mapWidth = get$().content('mapWidth')
			, mapHeight = get$().content('mapHeight')
			, mapZoom = get$().content('mapZoom')
		);
		
		// if you don't need anything fancy, just use this:
		// return local.body & local.gMap.getMap();

		local.outerWrapperClass = local.isMobile ? 'muraLocationOuterWrapperMobile' : 'muraLocationOuterWrapper';

		local.$ = get$();
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
					local.errorMessage = 'The address you entered could not be converted to a usable location for mapping. Please check the address fields on the Basic Tab and try again.';
				} else if ( local.matches > 1 ) {
					// more than one match found for this address...need to narrow the results to get the right one
					local.results = local.geoResponse.results;
					
					// sometimes, identical formatted_addresses are returned, but with different
					// geographic centers
					if ( local.matches == 2 && local.results[1].formatted_address == local.results[2].formatted_address  ) {
						// if there are only 2 results, and the 'formatted_address' is the same,
						// we'll assume it's the first element in the array...so continue
					} else {
						local.errorMessage = 'There were #local.matches# possible matches found for the address you entered. Please review the following list of locations and re-enter your address accordingly on the Basic Tab:<br><br>';

						for ( local.i=1; local.i <= local.matches; local.i++ ) {
							local.errorMessage = local.errorMessage & '&bull;&nbsp;' & local.results[i].formatted_address & '<br>';
						};
					};
				};
			} else { // NO MATCHES!
				// Maybe user is not connected to the internet?
				local.errorMessage = 'Sorry...we were unable to connect to Google to geoencode the address you entered on the Basic Tab. Please check your internet connection and try again.';
			}

		}
		
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
			}
		}
	}

	/**
	* onFolderMuraLocationsMapBodyRender()
	*/
	public any function onFolderMuraLocationsMapBodyRender(required struct $) output=false {
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

	// Backwards compatibility
	public any function onFolderMuraLocationBodyRender(required struct $) output=false {
		return onFolderMuraLocationsMapBodyRender(arguments.$);
	}

	// Mura 5.x compatibility
	public any function onPortalMuraLocationBodyRender(required struct $) output=false {
		return onFolderMuraLocationsMapBodyRender(arguments.$);
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
		}
		if (!IsBoolean(get$().event('findLocationRequestSubmitted'))){
			get$().event('findLocationRequestSubmitted',false);
		}
		if (get$().event('findLocationRequestSubmitted')){
			get$().announceEvent('onFindLocations', get$());
		}

		savecontent variable='local.str' {
			include 'includes/findLocationsForm.cfm';
		} 
		return local.str;
	}
	
	/**
	* dspClosestLocations()
	*/
	public any function dspClosestLocations(required struct $) output=false {
		var local = {};
		set$($);
		local.microDataFormat = getIsMobile() ? 'li' : 'div';
		local.result = get$().event('geoResponse').results[1];
		local.currentAddress = local.result.formatted_address;
		get$().event('start',local.currentAddress);
		local.currentLatLng = local.result.geometry.location.lat & ',' & local.result.geometry.location.lng;
		local.rs = get$().muraLocations.getClosestMuraLocations(currentLocation=local.currentLatLng);
		local.isMobile = getIsMobile();
	
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
				}
				local.item = get$().getBean('content').loadBy(contentid=local.rs.contentid[local.i]);
				local.detailsURL = get$().createHREF(filename=local.item.getValue('filename'));
				local.image = get$().getURLForImage(
					fileid = local.item.getValue('fileid')
					, size = 'small'
					, complete = true
				);
				if ( len(trim(get$().event('start'))) ) {
					local.detailsURL = local.detailsURL & '?start=' & URLEncodedFormat(get$().event('start'));
				}
				local.place = new Place(
					placeName = local.item.getValue('title')
					, latitude = local.item.getValue('latitude')
					, longitude = local.item.getValue('longitude')
					, streetAddress = local.item.getValue('streetAddress')
					, addressLocality = local.item.getValue('addressLocality')
					, addressRegion = local.item.getValue('addressRegion')
					, postalCode = local.item.getValue('postalCode')
					, locationTelephone = local.item.getValue('locationTelephone')
					, locationFaxNumber = local.item.getValue('locationFaxNumber')
					, locationEmail = local.item.getValue('locationEmail')
					, locationImage = local.image
					, detailsURL = local.detailsURL
					, mapURL = getMapURL(local.item.getValue('latitude'),local.item.getValue('longitude'))
					, locationDistance = local.rs.distance[local.i]
					, microDataFormat = local.microDataFormat
					, isMobile = local.isMobile
				);
				WriteOutput(local.place.getMicrodata(expand=local.expand));
			};
			if ( getIsMobile() ) {
				WriteOutput('</ul>');
				WriteOutput('<a href="#get$().content('url')#" data-role="button" data-icon="search" data-theme="e" rel="external">Search Again</a>');

			} else {
				WriteOutput('</div>');
				WriteOutput('<div class="searchAgainWrapper"><a class="geoButton btn btn-primary" href="#get$().content('url')#">Search Again</a></div>');
			};
		};
		return local.str;
	}
	
	/**
	* dspLocationsMap()
	* Returns a Google Map of all of Page/MuraLocation's along with the ability to get directions, etc.
	* @contentid pass in a contentid or filename, and we'll try to get any locations in that section
	*/
	public any function dspLocationsMap(
		boolean displayDirections=true
		, boolean displayTravelMode=true
		, string start=''
		, numeric mapHeight=400
		, string mapType='TERRAIN'
		, numeric mapWidth=0
		, string mapZoom='default'
		, string contentid=''
	) output=false {
		var local = {};

		// if being used as a display object, we need to set $ locally so we can use get$() in other methods
		if ( StructKeyExists(arguments, '$') ) {
			set$(arguments.$);
		}

		local.isMobile = getIsMobile();
		
		// used to populate the 'from' point on the form
		if ( !len(trim(arguments.start)) ) {
			if ( len(trim(get$().event('start'))) ) {
				arguments.start = get$().event('start');
			} else if ( len(trim(get$().event('currentLocation'))) ) {
				arguments.start = get$().event('currentLocation');
			}
		}

		local.places = ArrayNew(1);
		local.fBean = getMuraLocationsBean($=get$(), contentid=arguments.contentid);
		// get the feed's iterator
		local.it = local.fBean.getIterator();

		// if no locations, return empty string
		if ( !local.it.hasNext() ) { return ''; }
		
		// loop over each Page/MuraLocation and add it to the places array
		while ( local.it.hasNext() ) {
			local.item = local.it.next();

			if ( ListFindNoCase('Portal,Folder', get$().content('type')) || YesNoFormat(local.item.getValue('displayOnAllLocationsMap')) ) {
				local.lat = local.item.getValue('latitude');
				local.lng = local.item.getValue('longitude');
				// if viewing via mobile device that may have mapping capabilities, try to provide a device-native link to view the map
				local.mapURL = getMapURL(latitude=local.lat, longitude=local.lng);
				local.detailsURL = local.item.getValue('url');
				local.image = get$().getURLForImage(
					fileid = local.item.getValue('fileid')
					, size = 'small'
					, complete = true
				);
				if ( len(trim(arguments.start)) ) {
					local.detailsURL = local.detailsURL & '?start=' & URLEncodedFormat(arguments.start);
				}

				local.place = new Place(
					placeName = local.item.getValue('title')
					, latitude = local.lat
					, longitude = local.lng
					, streetAddress = local.item.getValue('streetAddress')
					, addressLocality = local.item.getValue('addressLocality')
					, addressRegion = local.item.getValue('addressRegion')
					, postalCode = local.item.getValue('postalCode')
					, locationTelephone = local.item.getValue('locationTelephone')
					, locationFaxNumber = local.item.getValue('locationFaxNumber')
					, locationEmail = local.item.getValue('locationEmail')
					, locationImage = local.image
					, zIndex = local.it.currentRow()
					, detailsURL = local.detailsURL
					, mapURL = local.mapURL
					, isMobile = local.isMobile
				);
				ArrayAppend(local.places, local.place.gMapPoint());
			}
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
	* dspMap()
	* A simple method for devs to display a simple GMap.
	* Should pass in a location 'name', as well as the 'latitude' + 'longitude' of the place
	*/
	public any function dspSimpleMap(
		string name='Blue River Interactive Group, Inc.'
		, numeric latitude=38.58439200000001
		, numeric longitude=-121.284517
		, boolean displayDirections=true
		, boolean displayTravelMode=true
		, string start=''
		, numeric mapHeight=400
		, string mapType='TERRAIN'
		, numeric mapWidth=0
		, string mapZoom='default'
	) output=false {
		var local = {};
		local.places = [];

		local.mapURL = getMapURL(latitude=arguments.latitude, longitude=arguments.longitude);
		local.detailsURL = $.content('url');
		if ( len(trim(arguments.start)) ) {
			local.detailsURL = local.detailsURL & '?start=' & URLEncodedFormat(arguments.start);
		}
		local.isMobile = getIsMobile();

		local.place = new Place(
			placeName = arguments.name
			, latitude = arguments.latitude
			, longitude = arguments.longitude
			, zIndex = 1
			, detailsURL = local.detailsURL
			, mapURL = local.mapURL
			, isMobile = local.isMobile
		);

		ArrayAppend(local.places, local.place.gMapPoint());

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
	* @contentid filter on specific section of the site
	*/
	public any function getMuraLocationsBean(struct $=get$(), string contentid='') output=false {
		var local = {};

		if ( StructKeyExists(arguments, '$') ) {
			set$(arguments.$);
		}

		local.contentid = Len(arguments.contentid) 
			? arguments.contentid 
			: get$().content('contentid');

		local.args = IsValid('uuid', local.contentid) 
			? { contentid=local.contentid }
			: { filename=local.contentid };

		local.cBean = get$().getBean('content').loadBy(argumentCollection=local.args);

		// create a dynamic feed of all Page/MuraLocation subtypes
		local.fBean = get$().getBean('feed');
		local.fBean.setName('');
		local.fBean.setSortBy('title');
		local.fBean.setSortDirection('asc');
		local.fBean.setMaxItems(0); // 0 = unlimited
		local.fBean.setNextN(10000); // max locations to display
		local.fBean.setShowNavOnly(true); // set to false to include content even if it's not in the navigation
		
		// If we're on a Folder (formerly Portal): Mura/Location, then check to see if we only want to display children of this Folder...otherwise, we'll include all locations.
		if ( 
			ListFindNoCase('Portal,Folder', local.cBean.getValue('type')) 
			&& ListFindNoCase('MuraLocation,MuraLocationsMap', local.cBean.getValue('subtype'))
			&& YesNoFormat(local.cBean.getValue('showChildrenOnly')) 
		) {
			local.fBean.addAdvancedParam(
				relationship='AND'
				, field='tcontent.parentid'
				, condition='EQ'
				, criteria=local.cBean.getValue('contentid')
			);
		} else if ( Len(arguments.contentid) ) {
			local.fBean.setContentID(local.cBean.getValue('contentid'));
		}

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

	public boolean function getIsMobile() {
		return IsBoolean(get$().event('muraMobileRequest')) ? get$().event('muraMobileRequest') : false;
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
	    }
    }

}
