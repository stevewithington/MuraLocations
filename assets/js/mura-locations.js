/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2012 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
* props: http://markdalgleish.com/2011/04/document-ready-for-jquery-mobile/
* depending on how the user is accessing the site, we need to be able to run essentially the same
* scripts regardless of whether they're using a mobile device or a regular browser.
* 
*/
if ($.mobile != null) {
	//console.log("jqm is running.");
	function pageScript(func){
		var $context = $("div:jqmData(role='page'):last");
		func($context);
	};
	pageScript(function($context){
		$context.bind('pagecreate', function(event, ui){
			runScripts(event, ui);
		});
	});
} else {
	jQuery(document).ready(function($){
		//console.log("jqm is NOT running.");
		runScripts(jQuery.event, jQuery.ui);
	});
};

function runScripts(event,ui){

	// this helps prevent a number of issues when navigating to dynamic pages
	// the key is to have this script loaded when a user initially visits the site
	$('#navPrimary a,#navSub a').attr({'data-ajax': false});

	//console.log('runScripts running.');
	
	var defaultMessage = '<p>Enter your Street Address, City/Locality, State/Region and/or Postal/Zip Code and click Find to display locations near you.</p>';
		
	// don't forget to trigger('updatelayout') when doing things like hide(), etc.
	initialize();
	function initialize(){

		if ($.mobile != null){
			$.mobile.ajaxFormsEnabled = false;
		};
		if (navigator.geolocation != null) {
			showGeoForm();
		} else { // geolocation NOT supported
			updateStatus(defaultMessage);
			showManualForm();
		};
	};

	$('#btnDoGeo').on('click', function(event){
		event.preventDefault();
		hideGeoForm();
		updateStatus('<p>You may be prompted by your browser to share your location...please do so to proceed.</p>');
		if ($.mobile != null) {
			$.mobile.showPageLoadingMsg();
		};
		doGeolocation();
	});
	;
	$('#btnDoForm').on('click', function(event){
		event.preventDefault();
		hideGeoForm();
		updateStatus(defaultMessage);
		showManualForm();
	});
	
	function showGeoForm(){
		$('#geoOptions').show();
	};
	function hideGeoForm(){
		$('#geoOptions').hide();
	};
	function showManualForm(){
		$('#initialFormWrapper').show();
		$('#geoOptions').hide();
	};
	function updateStatus(message){
		$('#status').html(message);
	};
	function doGeolocation(){
		navigator.geolocation.getCurrentPosition(handleGeoSuccess, handleGeoError, {
			timeout: 10000
		});
	};
	
	// SUCCESS
	function handleGeoSuccess(position){
		var lat = position.coords.latitude;
		var lng = position.coords.longitude;
		var location = location = lat + ',' + lng;
		var accuracy = position.coords.accuracy;
		//console.log(location);
		if ($.mobile != null) {
			$.mobile.hidePageLoadingMsg();
		};
		//showGeoForm();
		if (accuracy >= 1000) { // if accuracy is too large, don't try to calculate
			updateStatus('<p>The results obtained are not accurate enough for meaningful calculations. Try refreshing your page or manually enter your current location.</p>' + defaultMessage);
			//console.log('Accuracy: ' + accuracy);
			return;
		}
		else { // accuracy is good enough
			updateStatus('');
			$('#currentLocation').val(location);
			$('#usingGeolocation').val(true);
			$('#initialForm').submit();
		};
	};
	
	// ERROR
	function handleGeoError(error){
		var msg = '';
		if ($.mobile != null) {
			$.mobile.hidePageLoadingMsg();
		};
		console.log('Geolocation ERROR (' + error.code + '):' + error.message);
		switch (error.code) {
			case 0: // unknown error
				msg = '<p class="error">There was an error while retrieving your location:<br />' + error.message + '</p>';
				break;
			case 1: // permission denied
				msg = '<p class="notice">You prevented this page from retrieving your location.</p>';
				break;
			case 2: // position unavailable
				msg = '<p class="notice">The browser was unable to determine your location.</p>';
				break;
			case 3: // timeout
				msg = '<p class="notice">The browser timed out before retrieving the location.</p>';
				break;
			default: // not documented
				msg = '<p class="error">An unknown error has occurred:<br />' + error.message + '</p>';
		};
		updateStatus(msg + defaultMessage);
		showManualForm();
	};
	
};
