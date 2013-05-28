<cfsilent><cfscript>
/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2013 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript></cfsilent>
<cfoutput>
	<style type="text/css">
		.gmapWrapper .gmapCanvas {width:#local.mapWidth#;height:#local.mapHeight# !important;}
		.gmapWrapper .gmapDirectionsFormWrapper {width:#local.mapWidth# !important;}
		.gmapWrapper .gmapDirections {width:#local.mapWidth# !important;}
		/* there's an issue with Bootstrap interferring with GMap's infoWindow https://github.com/twitter/bootstrap/issues/2410 */
		img[src*="gstatic.com/"], img[src*="googleapis.com/"] {max-width: 99999px;}
	</style>
	<script>!window.google && document.write('<script src="https://maps.google.com/maps/api/js?sensor=false"><\/script>');</script>
	<script type="text/javascript">
	/* <![CDATA[ */
		// each place should be formatted as: ["PlaceName","Lat","Lng","ZIndex","Icon","InfoWindow"]
		var locations = #SerializeJSON(arguments.places)#;
		var infoWindow = new google.maps.InfoWindow();
		var bounds = new google.maps.LatLngBounds();
		var L = locations.length;
		for (i=0; i<L; i++) { bounds.extend(new google.maps.LatLng(locations[i][1], locations[i][2])); }

		var map = new google.maps.Map(document.getElementById('#local.mapCanvasID#'), {
			center: bounds.getCenter()
			, mapTypeId: google.maps.MapTypeId.#UCase(arguments.mapType)#
			<cfif mapZoom neq 'default'>, zoom: #arguments.mapZoom#</cfif>
		});
		<cfif mapZoom eq 'default'>map.fitBounds(bounds);</cfif>

		// MARKERS
		var marker, i;
		for (i=0; i<L; i++) {
			// marker
			marker = new google.maps.Marker({
				position: new google.maps.LatLng(locations[i][1], locations[i][2])
				, map: map
				, title: locations[i][0]
				, zIndex: Math.round(parseFloat(locations[i][3]))
				, icon: locations[i][4]
			});
			// infoWindow
			google.maps.event.addListener(marker, 'click'
				, (function(marker, i) {
					return function() {
						infoWindow.setOptions({
							content: '<div class="infoWindowWrapper">'+locations[i][5]+'</div>'
						});
						infoWindow.open(map, marker);
					}
				})(marker, i)
			);
		}

		// DIRECTIONS
		var directionsService = new google.maps.DirectionsService();
		var directionsDisplay = new google.maps.DirectionsRenderer();
		directionsDisplay.setMap(map);
		directionsDisplay.setPanel(document.getElementById('#local.mapDirectionsID#'));
		function calcRoute(start,end,mode) {
			if(mode===undefined){mode='DRIVING';};
			var request={origin:start,destination:end,travelMode:google.maps.DirectionsTravelMode[mode]};
			directionsService.route(request, function(response, status){
				if(status==google.maps.DirectionsStatus.OK){directionsDisplay.setDirections(response);};
			});
		}
	/* ]]> */
	</script>
</cfoutput>
