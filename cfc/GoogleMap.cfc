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
	};

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

		savecontent variable="local.gmapHtmlHeadContent" {
			WriteOutput('
				<style type="text/css">
					.gmapWrapper .gmapCanvas {width:#local.mapWidth#;height:#local.mapHeight#;}
					.gmapWrapper .gmapDirectionsFormWrapper {width:#local.mapWidth#;}
					.gmapWrapper .gmapDirections {width:#local.mapWidth#;}
				</style>
				<!--<meta name="viewport" content="width=device-width, initial-scale=1">-->
				<script>!window.jQuery && document.write(''<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"><\/script>'');</script>
				<script type="text/javascript" src="https://maps.google.com/maps/api/js?sensor=false"></script>
				<script type="text/javascript">
				/* <![CDATA[ */
					window.onload=function(){initGmap();};
					// each place should be formatted as: ["PlaceName","Lat","Lng","ZIndex","Icon","InfoWindow"]
					var places = #SerializeJSON(arguments.places)#;
					var directionDisplay;
					var directionsService;
					var map;
					var marker;
					var markersArray = new Array();
					var infoWindow;
		
					// INIT
					function initGmap(){
						directionsDisplay = new google.maps.DirectionsRenderer();
						directionsService = new google.maps.DirectionsService();
		
						// let the map auto-zoom to fit all places in the viewport
						var bounds = new google.maps.LatLngBounds();
						for (var i=0; i<places.length; i++) {
							var place = places[i];
							var point = new google.maps.LatLng(place[1],place[2]);
							bounds.extend(point);};
		
						// gather up map options for the constructor				
						var mapOptions = {
							center: bounds.getCenter()');
							if ( arguments.mapZoom != 'default' ) {
								WriteOutput(', zoom: #arguments.mapZoom#');
							};
							WriteOutput(', mapTypeId: google.maps.MapTypeId.#arguments.mapType#
						};
		
						// GMap v3 Constructor
						map = new google.maps.Map(document.getElementById("#local.mapCanvasID#"), mapOptions);');
						if ( arguments.mapZoom == 'default' ) {
							WriteOutput('map.fitBounds(bounds);');
						};
		
						WriteOutput('// Directions
						directionsDisplay.setMap(map);
						directionsDisplay.setPanel(document.getElementById("#local.mapDirectionsID#"));
		
						// Markers/Icons and Info Windows
						setMarkers(map, places);
					};
		
					// Markers/Icons
					function setMarkers(map, places) {
						for (var i=0;i<places.length;i++) {
							var place = places[i];
							// get the 2nd and 3rd positions of the place array (latitude, longitude)
							var iLatLng = new google.maps.LatLng(place[1], place[2]);
							var zIndex = Math.round(parseFloat(place[3]));
							var marker = new google.maps.Marker({
								position: iLatLng
								, map: map
								, title: place[0]
								, zIndex: zIndex
								, icon: place[4]
							});
							// add an InfoWindow to the marker
							addInfoWindow(marker, place[5]);
						};
					};
		
					// Info Window
					function addInfoWindow(marker, content) {
						var infowindow = new google.maps.InfoWindow({
							content: ''<div class="infoWindowWrapper">'' + content + ''</div>''
							// constrain the width of the infoWindow, otherwise it can expand to the full width of the page
							, maxWidth: #val(arguments.mapInfoWindowMaxWidth)#
						});
						google.maps.event.addListener(marker, "click", function() {
							infowindow.open(map,marker);
						});
					};
		
					// Directions
					function calcRoute(start, end, mode) {
						if ( mode === undefined ) {
							mode = "DRIVING";
						};
						var request = {
							origin:start
							, destination:end
							, travelMode:google.maps.DirectionsTravelMode[mode]
						};
						directionsService.route(
							request
							, function(response, status) {
								if (status == google.maps.DirectionsStatus.OK) {
									directionsDisplay.setDirections(response);
								};
							}
						);
					};
				/* ]]> */
				</script>
			');
		};

		savecontent variable="local.str" {
			local.lib = new Lib();
			lib.htmlhead(local.gmapHtmlHeadContent);
			WriteOutput('<div class="gmapWrapper"><div class="gmapCanvas" id="#local.mapCanvasID#"></div>');
			// Directions Form
			if ( arguments.displayDirections ) {
				WriteOutput('<div class="gmapDirectionsFormWrapper">
					<form data-ajax="false" class="gmapDirectionsForm" name="frmDirections" id="#local.formID#" action="javascript:void();" method="post" onSubmit="calcRoute(this.start.value,this.end.value,this.mode.value); return false;">
						<div class="gmapStart gmapField">
							<label for="start">From:</label>
							<input type="text" size="40" id="start" name="start" value="#arguments.start#" />
						</div>
						<div class="gmapEnd gmapField">
							<label for="end">To:</label>');
							if ( ArrayLen(arguments.places) > 1 ) {
								WriteOutput('<select name="end" id="end">');
								for ( local.i=1; local.i <= ArrayLen(arguments.places); local.i++ ) {
									WriteOutput('<option value="#arguments.places[local.i][2]#,#arguments.places[local.i][3]#">#arguments.places[local.i][1]#</option>');
								};
								WriteOutput('</select>');
							} else {
								for ( local.i=1; local.i <= ArrayLen(arguments.places); local.i++ ) {
									WriteOutput(' #arguments.places[local.i][1]# <input type="hidden" name="end" value="#arguments.places[local.i][2]#,#arguments.places[local.i][3]#" />');
								};
							};
						WriteOutput('</div>');
						// Travel Modes
						if ( arguments.displayTravelMode ) {
							WriteOutput('<div class="gmapTravelMode gmapField"><label for="mode">Travel Mode:</label>
								<select name="mode" id="mode">
									<option value="DRIVING">Driving</option>
									<option value="BICYCLING">Bicycling</option>
									<option value="WALKING">Walking</option>
								</select></div>');
						} else {
							WriteOutput('<input type="hidden" name="mode" id="mode" value="DRIVING" />');
						};
						WriteOutput('<div class="gmapSubmit gmapField">
							<input type="submit" name="submit" value="Get Directions &raquo;" />
						</div>
					</form>
				</div>
				<div class="gmapDirections" id="#local.mapDirectionsID#"></div></div>');
			}; // @end if displayDirections
		};
		variables.map = local.str;
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