/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2015 Stephen J. Withington, Jr.
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
		local.image = get$().getURLForImage(
			fileid = get$().content('fileid')
			, size = 'small'
			, complete = true
		);

		// build the map, etc.
		local.places = [];
		local.rsCategories = get$().content().getCategoriesQuery();
		local.place = new Place(
			placeName = get$().content('title')
			, latitude = get$().content('latitude')
			, longitude = get$().content('longitude')
			, streetAddress = get$().content('streetAddress')
			, addressLocality = get$().content('addressLocality')
			, addressRegion = get$().content('addressRegion')
			, postalCode = get$().content('postalCode')
			, addressCountry = get$().content('addressCountry')
			, locationNotes = get$().content('locationNotes')
			, detailsURL = get$().content('url')
			, mapURL = getMapURL(latitude=get$().content('latitude'), longitude=get$().content('longitude'))
			, locationTelephone = get$().content('locationTelephone')
			, locationFaxNumber = get$().content('locationFaxNumber')
			, locationEmail = get$().content('locationEmail')
			, locationImage = local.image
			, infoWindow = get$().content('mapInfoWindow')
			, isMobile = local.isMobile
			, categories = ListToArray(ValueList(local.rsCategories.name))
		);
		
		ArrayAppend(local.places, local.place.gMapPoint());

		local.gMap = new GoogleMap(
			places=local.places
			, mapType = get$().content('mapType')
			, start = get$().event('start')
			, mapWidth = get$().content('mapWidth')
			, mapHeight = get$().content('mapHeight')
			//, mapZoom = get$().content('mapZoom')
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
			local.q = replace(local.bean.getValue('streetAddress'), chr(13) & chr(10), ",", "ALL") & ',' 
				& local.bean.getValue('addressLocality') & ',' 
				& local.bean.getValue('addressRegion') & ' ' 
				& local.bean.getValue('postalCode') & ',' 
				& local.bean.getValue('addressCountry');
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

		local.body = get$().renderEditableAttribute(
			attribute='body'
			, type='HTMLEditor'
			, label='Content'
			, enableMuraTag=true
		);
	
		local.objectKey = 'MURA-LOCATION-MAP-' & $.content('contentid');
		local.tp = $.initTracePoint('*** plugins.MuraLocations.cfc.EventHandler.onFolderMuraLocationsMapBodyRender: "#local.objectKey#"  ***');

		local.response = getCachedObject(local.objectKey);

		if ( !Len(local.response) ) {
			local.map = dspLocationsMap(
				mapType = get$().content('mapType')
				, start = get$().event('start')
				, mapWidth = get$().content('mapWidth')
				, mapHeight = get$().content('mapHeight')
				//, mapZoom = get$().content('mapZoom')
				, displayCategoryFilter = true
			);

			setCachedObject(local.objectKey, local.response);
		}

		$.commitTracePoint(local.tp);

		return local.body & local.map;
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
			get$().announceEvent('onFindLocations');
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
				}
				WriteOutput('<div class="subheading">Locations nearest: <em>#HTMLEditFormat($.event('start'))#</em></div>');
			}

			if ( local.isMobile ) {
				WriteOutput('<ul data-role="listview" data-inset="true" data-theme="b" data-content-theme="d">');
			} else {
				WriteOutput('<div data-role="collapsible-set" data-theme="b" data-content-theme="d">');
			}
		
			for (local.i=1; local.i <= local.rs.recordcount; local.i++) {
				local.expand = false;

				if ( local.i eq 1 ) { 
					local.expand = true;
				}

				local.item = get$().getBean('content').loadBy(contentid=local.rs.contentid[local.i]);
				// local.detailsURL = getMap(latitude=local.item.getValue('latitude'), longitude=local.item.getValue('longitude'));
				local.detailsURL = get$().createHREF(filename=local.item.getValue('filename'));
				local.image = get$().getURLForImage(
					fileid = local.item.getValue('fileid')
					, size = 'small'
					, complete = true
				);

				if ( len(trim(get$().event('start'))) ) {
					local.detailsURL = getMap(latitude=local.item.getValue('latitude'), longitude=local.item.getValue('longitude'), saddr=get$().event('start'));
				}

				local.rsCategories = local.item.getCategoriesQuery();

				local.place = new Place(
					placeName = local.item.getValue('title')
					, latitude = local.item.getValue('latitude')
					, longitude = local.item.getValue('longitude')
					, streetAddress = local.item.getValue('streetAddress')
					, addressLocality = local.item.getValue('addressLocality')
					, addressRegion = local.item.getValue('addressRegion')
					, postalCode = local.item.getValue('postalCode')
					, addressCountry = local.item.getValue('addressCountry')
					, locationTelephone = local.item.getValue('locationTelephone')
					, locationFaxNumber = local.item.getValue('locationFaxNumber')
					, locationEmail = local.item.getValue('locationEmail')
					, locationImage = local.image
					, detailsURL = local.detailsURL
					, mapURL = getMapURL(local.item.getValue('latitude'),local.item.getValue('longitude'))
					, locationDistance = local.rs.distance[local.i]
					, microDataFormat = local.microDataFormat
					, infoWindow = local.item.getValue('mapInfoWindow')
					, isMobile = local.isMobile
					, categories = ListToArray(ValueList(local.rsCategories.name))
				);
				WriteOutput(local.place.getMicrodata(expand=local.expand));
			}

			if ( getIsMobile() ) {
				WriteOutput('</ul>');
				WriteOutput('<a href="#get$().content('url')#" data-role="button" data-icon="search" data-theme="e" rel="external">Search Again</a>');

			} else {
				WriteOutput('</div>');
				WriteOutput('<div class="searchAgainWrapper"><a class="geoButton btn btn-primary" href="#get$().content('url')#">Search Again</a></div>');
			}

		}

		return local.str;
	}
	
	/**
	* dspLocationsMap()
	* Returns a Google Map of all of Page/MuraLocation's, etc.
	* @contentid pass in a contentid or filename, and we'll try to get any locations in that section
	* @locations an array of structs
	*/
	public any function dspLocationsMap(
		string start=''
		, numeric mapHeight=400
		, string mapType='ROADMAP'
		, numeric mapWidth=0
		, string mapZoom='default'
		, string contentid=''
		, array locations=[]
		, boolean displayCategoryFilter=true
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

		// container for 'places' that will be mapped
		local.places = [];

		if ( StructKeyExists(arguments, 'locations') && ArrayLen(arguments.locations) ) {

			// START : Using arguments.locations
				for ( var location in arguments.locations ) {
					if ( IsStruct(location) && StructKeyExists(location, 'placeName') && StructKeyExists(location, 'latitude') && StructKeyExists(location, 'longitude') ) {
						// if viewing via mobile device that may have mapping capabilities, try to provide a device-native link to view the map
						location.mapURL = getMapURL(latitude=location.latitude, longitude=location.longitude);
						location.isMobile = local.isMobile;
						local.place = new Place(argumentCollection=location);
						ArrayAppend(local.places, local.place.gMapPoint());
					}
				}
			// END: Using arguments.locations
		
		} else {

			// START: Using MuraLocations

				local.fBean = getMuraLocationsBean($=get$(), contentid=arguments.contentid);
				// get the feed's iterator
				local.it = local.fBean.getIterator();

				// if no locations, return empty string
				if ( !local.it.hasNext() ) { return ''; }
				
				// loop over each Page/MuraLocation and add it to the places array
				while ( local.it.hasNext() ) {
					local.item = local.it.next();

					//if ( ListFindNoCase('Portal,Folder', get$().content('type')) || YesNoFormat(local.item.getValue('displayOnAllLocationsMap')) ) {
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
							local.mapURL = getMapURL(latitude=local.item.getValue('latitude'), longitude=local.item.getValue('longitude'), saddr=get$().event('start'));
							local.detailsURL = local.detailsURL & '?start=' & URLEncodedFormat(arguments.start);
						}

						local.rsCategories = local.item.getCategoriesQuery();

						local.place = new Place(
							placeName = local.item.getValue('title')
							, latitude = local.lat
							, longitude = local.lng
							, streetAddress = local.item.getValue('streetAddress')
							, addressLocality = local.item.getValue('addressLocality')
							, addressRegion = local.item.getValue('addressRegion')
							, postalCode = local.item.getValue('postalCode')
							, addressCountry = local.item.getValue('addressCountry')
							, locationTelephone = local.item.getValue('locationTelephone')
							, locationFaxNumber = local.item.getValue('locationFaxNumber')
							, locationEmail = local.item.getValue('locationEmail')
							, locationImage = local.image
							, zIndex = local.it.currentRow()
							, detailsURL = local.detailsURL
							, mapURL = local.mapURL
							, infoWindow = local.item.getValue('mapInfoWindow')
							, isMobile = local.isMobile
							, categories = ListToArray(ValueList(local.rsCategories.name))
						);
						ArrayAppend(local.places, local.place.gMapPoint());
					//}
				}

			// END : Using MuraLocations
		}
		
		// create a new Google Map with the array of places
		local.gMap = new GoogleMap(
			places=local.places
			, mapType = arguments.mapType
			, start = arguments.start
			, mapWidth = arguments.mapWidth
			, mapHeight = arguments.mapHeight
			, mapZoom = arguments.mapZoom
			, displayCategoryFilter = arguments.displayCategoryFilter
		);

		return local.gMap.getMap();
	}

	/**
	* dspSimpleMap()
	* A simple method for devs to display a simple GMap.
	* Should pass in a location 'name', as well as the 'latitude' + 'longitude' of the place
	*/
	public any function dspSimpleMap(
		string name='Blue River Interactive Group, Inc.'
		, numeric latitude=38.58439200000001
		, numeric longitude=-121.284517
		, string start=''
		, numeric mapHeight=400
		, string mapType='ROADMAP'
		, numeric mapWidth=0
		, string infoWindow=''
		, string mapZoom='default'
	) output=false {
		var local = {};
		local.places = [];
		local.mapURL = getMapURL(latitude=arguments.latitude, longitude=arguments.longitude);
		local.detailsURL = $.content('url');

		if ( len(trim(arguments.start)) ) {
			local.mapURL = getMapURL(latitude=local.item.getValue('latitude'), longitude=local.item.getValue('longitude'), saddr=get$().event('start'));
			local.detailsURL = local.detailsURL & '?start=' & URLEncodedFormat(arguments.start);
		}

		local.place = new Place(
			placeName = arguments.name
			, latitude = arguments.latitude
			, longitude = arguments.longitude
			, zIndex = 1
			, detailsURL = local.detailsURL
			, mapURL = local.mapURL
			, infoWindow = arguments.infoWindow
			, isMobile = local.isMobile
		);

		ArrayAppend(local.places, local.place.gMapPoint());

		local.gMap = new GoogleMap(
			places=local.places
			, mapType = arguments.mapType
			, start = arguments.start
			, mapWidth = arguments.mapWidth
			, mapHeight = arguments.mapHeight
			, mapZoom = arguments.mapZoom
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

		local.objectKey = 'MURA-LOCATIONS-BEAN-' & local.contentid;
		local.tp = $.initTracePoint('*** plugins.MuraLocations.cfc.EventHandler.getMuraLocationsBean: "#local.objectKey#" ***');

		local.fBean = getCachedObject(local.objectKey);

		if ( IsSimpleValue(local.fBean) ) {

			local.args = IsValid('uuid', local.contentid) 
				? { contentid=local.contentid }
				: { filename=local.contentid };

			local.cBean = get$().getBean('content').loadBy(argumentCollection=local.args);

			// create a dynamic feed of all Page/MuraLocation subtypes
			local.fBean = get$().getBean('feed')
				.setSortBy('title')
				.setSortDirection('asc')
				.setMaxItems(0)
				.setNextN(10000)
				.setShowNavOnly(1); // set to 0 to include content even if it's not in the navigation
			
			// If we're on a Folder (formerly Portal): Folder/MuraLocationsMap, then check to see if we only want to display children of this Folder...otherwise, we'll include all locations.
			if ( 
				ListFindNoCase('Portal,Folder', local.cBean.getValue('type')) 
				&& ListFindNoCase('MuraLocation,MuraLocationsMap', local.cBean.getValue('subtype'))
			) {
				local.fBean.addParam(
					relationship='AND'
					, field='tcontent.parentid'
					, condition='EQ'
					, criteria=local.cBean.getValue('contentid')
				);
			} else if ( Len(arguments.contentid) ) {
				local.fBean.addParam(
					relationship='AND'
					, field='tcontent.path'
					, condition='CONTAINS'
					, criteria=local.cBean.getValue('contentid')
				);
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

			setCachedObject(local.objectKey, local.fBean);

		}

		$.commitTracePoint(local.tp);

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
   		, string saddr=''
   	) output=false {
    	var mobile = new MobileDetect();
    	var local = {};

    	local.baseURL = 'https://maps.google.com/?saddr=#URLEncodedFormat(arguments.saddr)#&daddr=';
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
    	} else { 
    		return local.baseURL & local.coords;
	    }
    }

	// Custom Plugin Application Cache  ----------------------------------------------------------

		private any function getCachedObject(required string objectKey) {
			var obj = '';
			var cache = getApplicationCache();
			if ( StructKeyExists(cache, 'objects') && StructKeyExists(cache.objects, arguments.objectKey) ) {
				obj = cache.objects[arguments.objectKey];
			}
			return obj;
		}

		private void function setCachedObject(required string objectKey, any objectValue='') {
			lock scope='application' type='exclusive' timeout=10 {
				application[variables.pluginConfig.getValue('packageName')].objects[arguments.objectKey] = arguments.objectValue;
			};
		}

		private boolean function isCacheExpired() {
			var p = variables.pluginConfig.getValue('packageName');
			return !StructKeyExists(application, p) 
					|| DateCompare(now(), application[p].expires, 's') == 1 
					|| DateCompare(application.appInitializedTime, application[p].created, 's') == 1
				? true : false;
		}

		private any function getApplicationCache() {
			var local = {};
			if ( isCacheExpired() ) {
				setApplicationCache();
			}
			lock scope='application' type='readonly' timeout=10 {
				local.cache = application[variables.pluginConfig.getValue('packageName')];
			};
			return local.cache;
		}

		private void function setApplicationCache() {
			var p = variables.pluginConfig.getValue('packageName');
			lock scope='application' type='exclusive' timeout=10 {
				StructDelete(application, p);
				application[p] = {
					created = Now()
					, expires = DateAdd('h', 1, Now())
					, applicationid = Hash(CreateUUID())
					, objects = {}
				};
			};
		}


}
