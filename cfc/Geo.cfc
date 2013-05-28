/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2013 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
component accessors=true output=false {

	/**
	* init()
	* Constructor
	*/
	public Geo function init() output=false {
		return this;
	}

	/**
	* getResponse()
	* Using Google Maps API v3 to get detailed location information
	* @q A geographical location
	* @debug Set to true to get the full response from Google
	*/
	public any function getResponse(string q='', boolean debug=false) output=false {
		var local = {};
		local.result = '';
		local.response = '';
		// google returns JSON by default. if you want XML, add 'o=xml' to the query string
		local.url = 'https://maps.googleapis.com/maps/api/geocode/json?address=' & arguments.q & '&sensor=true';
		local.httpService = new Http();
		local.httpService.setAttributes(method='get', resolveurl=true, url=local.url);

		try {
			local.result = local.httpService.send().getPrefix();
		} catch (any e) { // either Google Maps is down OR no internet connection
			return 'Service is currently unavailable. You may also want to check your internet connection.';
		}
	
		if ( local.result.statuscode == '200 OK' && StructKeyExists(local.result, 'filecontent') ) {
			if (  IsJSON(local.result.filecontent) ) {
				local.json = local.result.filecontent;
				local.response = DeSerializeJSON(local.json);
			} else {
				local.response = local.result.filecontent; // not JSON
			}
		} else if ( StructKeyExists(local.result, 'filecontent') && IsJSON(local.result.filecontent) ) {
			local.response = DeSerializeJSON(local.result.filecontent); // bad status code
		} else {
			local.response = local.result; // error
		}
		
		return arguments.debug ? local.result : local.response;
	}
	
	/**
	* getLatLng()
	* Returns the Latitude,Longitude of a geographical location
	* If more than one location is found, it returns the first result in the array
	* @q A geographical location
	*/
	public any function getLatLng(string q='', boolean debug=false) output=false { 
		var local = {};
		local.response = getResponse(q=arguments.q, debut=arguments.debug);
		if ( arguments.debug ) {
			return local.response;
		};
		if ( IsStruct(local.response) && StructKeyExists(local.response, 'results') && ArrayLen(local.response.results) ) {
			// we're good!
			local.g = local.response.results[1].geometry.location;
			return local.g.lat & ',' & local.g.lng;
		} else {
			// not good
			return '';
		}
	}
	
	/**
	* getAddress()
	* Returns the approximate address of a geographical location
	* If more than one location is found, it returns the first result in the array
	* @q A geographical location
	*/
	public any function getAddress(string q='', boolean debug=false) output=false { 
		var local = {};
		local.response = getResponse(arguments);
		if ( arguments.debug ) {
			return local.response;
		}
		if ( IsStruct(local.response) && StructKeyExists(local.response, 'results') && ArrayLen(local.response.results) ) {
			// we're good!
			return local.response.results[1].formatted_address;
		} else {
			// not good
			return '';
		}
	}
	
	/**
	* getVincentyDistance()
	* Calculates geodetic distance between two points specified by latitude/longitude using Vincenty inverse formula for ellipsoids
	* @lat1 first latitude in decimal degrees
	* @lon1 first lognitude in decimal degrees
	* @lat2 second latitude in decimal degrees
	* @lon2	second longitude in decimal degrees
	* @units sm=statute miles (default), m=meters, km=kilometers, nm=nautical miles, yd=yards, ft=feet, in=inches, cm=centimeters, mm=millimeters
	* @returns {Number} distance in selected units between points or {String} if error
	*/
	public any function getVincentyDistance(
		required lat1,
		required lon1,
		required lat2,
		required lon2,
		string units='sm'
	) output=false {
		/* 
		Vincenty Inverse Solution of Geodesics on the Ellipsoid
		http://www.movable-type.co.uk/scripts/latlong-vincenty.html
		This work is licensed under a Create Commons Attribution 3.0 Unported License.
		http://creativecommons.org/licenses/by/3.0/
		from: Vincenty inverse formula - T Vincenty, "Direct and Inverse Solutions of Geodesics on the
		Ellipsoid with application of nested equations", Survey Review, vol XXII no 176, 1975
		http://www.ngs.noaa.gov/PUBS_LIB/inverse.pdf
		*/

		// WGS-84 ellipsoid params
		var a = 6378137;
		var b = 6356752.314245;
		var f = 1 / 298.257223563;
		//var L = ( lon2 - lon1 ) * Pi() / 180;
		var L = IsNumeric( lon2 ) and IsNumeric( lon1 ) ? ( lon2 - lon1 ) * Pi() / 180 : 0;
		var U1 = IsNumeric( lat1 ) ? Atn( ( 1 - f ) * Tan( lat1 * Pi() / 180 ) ) : 0;
		var U2 = IsNumeric (lat2 ) ? Atn( ( 1 - f ) * Tan( lat2 * Pi() / 180 ) ) : 0;
		var sinU1 = Sin( U1 );
		var cosU1 = Cos( U1 );
		var sinU2 = Sin( U2 );
		var cosU2 = Cos( U2 );
		var lambda = L;
		var lambdaP = '';
		var iterLimit = 100;
		var sinLambda = '';
		var cosLambda = '';
		var sinSigma = '';
		var cosSigma = '';
		var sigma = '';
		var sinAlpha = '';
		var cosSqAlpha = '';
		var cos2SigmaM = '';
		var C = '';
		var uSq = '';
		var AA = '';
		var BB = '';
		var deltaSigma = '';
		var s = '';
		var Math = CreateObject( 'java', 'java.lang.Math' );
	
		if ( lat1 > 90 || lat1 < -90 || lon1 > 180 || lon1 < -180 || lat2 > 90 || lat2 < -90 || lon2 > 180 || lon2 < -180 ) {
			//return 'Latitude must be between 0&deg; and &plusmn; 90&deg;. (South Latitude is negative) Longitude mast be between 0&deg; and &plusmn; 180&deg;. (West Longitude is negative)';
			return 123456789;
		}
	
		if ( !StructKeyExists( arguments, 'units' ) || !ListFindNoCase( 'm,km,sm,nm,yd,ft,in,cm,mm', arguments.units ) ) {
			arguments.units = 'sm'; // default to statute miles
		}
	
		do {
			sinLambda = Sin( lambda );
			cosLambda = Cos( lambda );
			sinSigma = Sqr( ( cosU2 * sinLambda ) * ( cosU2 * sinLambda ) + ( cosU1 * sinU2 - sinU1 * cosU2 * cosLambda ) * ( cosU1 * sinU2 - sinU1 * cosU2 * cosLambda ) );
			if ( sinSigma == 0 ) { return 0; };  // co-incident points
			cosSigma = sinU1 * sinU2 + cosU1 * cosU2 * cosLambda;
			sigma = Math.atan2( JavaCast( 'double', sinSigma ), JavaCast( 'double', cosSigma ) ); // CFML doesn't have a native ATan2() method avail.
			sinAlpha = cosU1 * cosU2 * sinLambda / sinSigma;
			cosSqAlpha = 1 - sinAlpha * sinAlpha;
			cos2SigmaM = cosSigma - 2 * sinU1 * sinU2 / cosSqAlpha;
			if ( !IsNumeric( cos2SigmaM ) ) { cos2SigmaM = 0; }; // equatorial line: cosSqAlpha=0 (¤6)
			C = f / 16 * cosSqAlpha * ( 4 + f * ( 4 - 3 * cosSqAlpha ) );
			lambdaP = lambda;
			lambda = L + ( 1 - C ) * f * sinAlpha * ( sigma + C * sinSigma * ( cos2SigmaM + C * cosSigma * ( -1 + 2 * cos2SigmaM * cos2SigmaM ) ) );
		} while ( Abs( lambda - lambdaP ) > 0.000000000001 && --iterLimit > 0 );
	
		if ( iterLimit == 0 ) { return 'NaN'; }; // formula failed to converge
	
		uSq = cosSqAlpha * ( a * a - b * b ) / ( b * b );
		AA = 1 + uSq / 16384 * ( 4096 + uSq * ( -768 + uSq * ( 320 - 175 * uSq ) ) );
		BB = uSq / 1024 * ( 256 + uSq * ( -128 + uSq * ( 74 - 47 * uSq ) ) );
		deltaSigma = BB * sinSigma * ( cos2SigmaM + BB / 4 * ( cosSigma * ( -1 + 2 * cos2SigmaM * cos2SigmaM ) - BB / 6 * cos2SigmaM * ( -3 + 4 * sinSigma * sinSigma ) * ( -3 + 4 * cos2SigmaM * cos2SigmaM ) ) );
		s = b * AA * ( sigma - deltaSigma );
		s = NumberFormat( s, .999 ); // round to 1mm precision
		
		switch( arguments.units ) {
			case 'm' : // meters
				break;
			case 'km' : s = s * 0.001; // kilometers
				break;
			case 'nm' : s = s * 0.000539956803; // nautical miles
				break;
			case 'yd' : s = s * 1.0936133; // yards
				break;
			case 'ft' : s = s * 3.2808399; // feet
				break;
			case 'in' : s = s * 39.3700787; // inches
				break;
			case 'cm' : s = s * 100; // centimeters
				break;
			case 'mm' : s = s * 1000; // millimeters
				break;
			default : s = s * 0.000621371192; // statute miles
		};
	
		return s;
	}

}