<cfsilent><cfscript>
/**
* 
* This file is part of Muralocations TM
*
* Copyright 2010-2014 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript></cfsilent>
<cfoutput>
	<style type="text/css">
		##gmapWrapper_#local.thisid#.gmapWrapper .gmapCanvas {width:#local.mapWidth#;height:#local.mapHeight# !important;}
		##gmapWrapper_#local.thisid#.gmapWrapper .gmapDirectionsFormWrapper {width:#local.mapWidth# !important;}
		##gmapWrapper_#local.thisid#.gmapWrapper .gmapDirections {width:#local.mapWidth# !important;}
		/* there's an issue with Bootstrap interferring with GMap's infoWindow https://github.com/twitter/bootstrap/issues/2410 */
		img[src*="gstatic.com/"], img[src*="googleapis.com/"] {max-width: 99999px;}
	</style>
	<script>!window.google && document.write('<script src="https://maps.google.com/maps/api/js?sensor=false"><\/script>');</script>
	<script type="text/javascript">
	/* <![CDATA[ */
		// each place should be formatted as: ["PlaceName","Lat","Lng","ZIndex","Icon","InfoWindow"]
		var locations_#local.thisid# = #SerializeJSON(arguments.places)#;
		var infoWindow_#local.thisid# = new google.maps.InfoWindow();
		var bounds_#local.thisid# = new google.maps.LatLngBounds();
		var L_#local.thisid# = locations_#local.thisid#.length;
		for (i=0; i<L_#local.thisid#; i++) { bounds_#local.thisid#.extend(new google.maps.LatLng(locations_#local.thisid#[i][1], locations_#local.thisid#[i][2])); }

		var map_#local.thisid# = new google.maps.Map(document.getElementById('#local.mapCanvasID#'), {
			center: bounds_#local.thisid#.getCenter()
			, mapTypeId: google.maps.MapTypeId.#UCase(arguments.mapType)#
			<cfif mapZoom neq 'default'>, zoom: #arguments.mapZoom#</cfif>
		});
		<cfif mapZoom eq 'default'>map_#local.thisid#.fitBounds(bounds_#local.thisid#);</cfif>

		// MARKERS
		var marker_#local.thisid#, i;
		for (i=0; i<L_#local.thisid#; i++) {
			// marker
			marker_#local.thisid# = new google.maps.Marker({
				position: new google.maps.LatLng(locations_#local.thisid#[i][1], locations_#local.thisid#[i][2])
				, map: map_#local.thisid#
				, title: locations_#local.thisid#[i][0]
				, zIndex: Math.round(parseFloat(locations_#local.thisid#[i][3]))
				, icon: locations_#local.thisid#[i][4]
			});
			// infoWindow
			google.maps.event.addListener(marker_#local.thisid#, 'click'
				, (function(marker_#local.thisid#, i) {
					return function() {
						infoWindow_#local.thisid#.setOptions({
							content: '<div class="infoWindowWrapper">'+locations_#local.thisid#[i][5]+'</div>'
						});
						infoWindow_#local.thisid#.open(map_#local.thisid#, marker_#local.thisid#);
					}
				})(marker_#local.thisid#, i)
			);
		}

		// DIRECTIONS
		var directionsService_#local.thisid# = new google.maps.DirectionsService();
		var directionsDisplay_#local.thisid# = new google.maps.DirectionsRenderer();
		directionsDisplay_#local.thisid#.setMap(map_#local.thisid#);
		directionsDisplay_#local.thisid#.setPanel(document.getElementById('#local.mapDirectionsID#'));
		function calcRoute_#local.thisid#(start,end,mode) {
			if(mode===undefined){mode='DRIVING';};
			var request={origin:start,destination:end,travelMode:google.maps.DirectionsTravelMode[mode]};
			directionsService_#local.thisid#.route(request, function(response, status){
				if(status==google.maps.DirectionsStatus.OK){directionsDisplay_#local.thisid#.setDirections(response);};
			});
		}
	/* ]]> */
	</script>
</cfoutput>
