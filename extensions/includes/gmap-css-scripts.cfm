<cfsilent><cfscript>
/**
* 
* This file is part of Muralocations TM
*
* Copyright 2010-2015 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
</cfscript></cfsilent>
<cfoutput>
	<style type="text/css">
		/* categories */
		.category-filters { width: auto; float:right; }
		.category-filters .category-filter-wrapper { width: auto; float:left; padding: 0.5em 0 0.5em 0.5em; margin: 0.5em 0 0.5em 0.5em; }
		.category-filters .category-filter-wrapper label.category-filter-label {}
		.category-filters .category-filter-wrapper label.category-filter-label input.category-filter-option {}

		/* gmap */
		.gmap-wrapper .gmap-canvas .marker { visibility: hidden; }
		.gmap-wrapper .gmap-canvas { width: #local.mapWidth#; height: #local.mapHeight# !important; }

		/* Bootstrap + GMap's infoWindow issue - https://github.com/twitter/bootstrap/issues/2410 */
		img[src*="gstatic.com/"], img[src*="googleapis.com/"] { max-width: 99999px; }
	</style>

	<script type="text/javascript">
	/* <![CDATA[ */ 

		// polyfill for some()
		if (!Array.prototype.some) {
			Array.prototype.some = function(fun/*, thisArg*/) {
				'use strict';

				if (this == null) {
					throw new TypeError('Array.prototype.some called on null or undefined');
				}

				if (typeof fun !== 'function') {
					throw new TypeError();
				}

				var t = Object(this);
				var len = t.length >>> 0;
				var thisArg = arguments.length >= 2 ? arguments[1] : void 0;
				for (var i = 0; i < len; i++) {
					if (i in t && fun.call(thisArg, t[i], i, t)) {
						return true;
					}
				}

				return false;
			};
		}

		var findOne = function (haystack, arr) {
			return arr.some(function (v) {
				return haystack.indexOf(v) >= 0;
			});
		};


		jQuery(document).ready(function($) {

			var render_map = function ($el) {
				var $markers = $el.find('.marker');
				var args = {
						center: new google.maps.LatLng(0, 0)
						, backgroundColor: '##ffffff'
						, mapTypeId: google.maps.MapTypeId.#UCase(arguments.mapType)#
				};

				// Create map	        	
				var map = new google.maps.Map($el[0], args);
				
				// Add a markers reference
				map.markers = [];

				// Add markers
				$markers.each(function () {
						add_marker($(this), map);
				});

				center_map(map);

				return map;
			}
			
			var add_marker = function ($marker, map) {
				var infoWindow = new google.maps.InfoWindow();
				var latlng = new google.maps.LatLng($marker.attr('data-lat'), $marker.attr('data-lng'));
				var icon = null;

				var marker = new google.maps.Marker({
						position: latlng
						, animation: google.maps.Animation.DROP
						, map: map
						, filter: {
							categories: $marker.data('categories').toString()
						}
				});

				if ( $marker.html() ) {
					google.maps.event.addListener(marker, 'click'
						, (function(marker) {
							return function() {
								infoWindow.setOptions({
									content: $marker.children().html()
								});
								infoWindow.open(map, marker);
							}
						})(marker)
					);
				}

				// Add to array
				map.markers.push(marker);
			}

			var center_map = function (map) {
					var bounds = new google.maps.LatLngBounds();

					// Loop through all markers and create bounds
					$.each(map.markers, function (i, marker) {
							var latlng = new google.maps.LatLng(marker.position.lat(), marker.position.lng());
							bounds.extend(latlng);
					});
					map.fitBounds(bounds);
			}

			var map = null;
			
			$('.gmap-canvas').each(function () {
					map = render_map($(this));
			});

			$('input.category-filter-option').on('click', function () {
				var categories = [];

				$('input.category-filter-option:checked').each(function() {
					categories.push($(this).val());
				});
	
				$.each(map.markers, function () {
					var thisMarkerVisible = findOne(this.filter.categories, categories) ? true : false;
					this.setVisible(thisMarkerVisible);
				});

			});

			$(window).resize(function() {
				// resize the map to fit the window when being resized
				center_map(map);
			});

		});

	/* ]]> */
	</script>
</cfoutput>
