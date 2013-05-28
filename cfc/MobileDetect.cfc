/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2013 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
* Mobile Detection Resources:
*			http://detectmobilebrowsers.com/
*			http://code.google.com/p/mobileesp/source/browse/Java/UAgentInfo.java
*
*/
component accessors=true output=false {
	
	property name='isIphone' type='boolean' default=false;
	property name='isAndroid' type='boolean' default=false;
	property name='isWinPhone7' type='boolean' default=false;
	property name='isIEMobile' type='boolean' default=false;
	property name='isBlackberry' type='boolean' default=false;

	//public MobileDetect function init() {
	public any function init() {
		setIsIphone(getIsIphone());
		setIsAndroid(getIsAndroid());
		setIsWinPhone7(getIsWinPhone7());
		setIsIEMobile(getIsIEMobile());
		setIsBlackberry(getIsBlackberry());
		return this;
	}

	public boolean function getIsIphone() output=false {
    	return REFindNoCase('ip(hone|od|ad)',CGI.HTTP_USER_AGENT);
	}

	public boolean function getIsAndroid() output=false {
		//return REFindNoCase('android.+mobile',CGI.HTTP_USER_AGENT);
		return REFindNoCase('android',CGI.HTTP_USER_AGENT);
	}

	public boolean function getIsWinPhone7() output=false {
		return REFindNoCase('windows phone os 7',CGI.HTTP_USER_AGENT);
	}

	public boolean function getIsIEMobile() output=false {
		return REFindNoCase('iemobile',CGI.HTTP_USER_AGENT);
	}

	public boolean function getIsBlackberry() output=false {
		//return REFindNoCase('blackberry|vnd.rim',CGI.HTTP_USER_AGENT);
		return REFindNoCase('blackberry',CGI.HTTP_USER_AGENT);
	}

	public any function getProperties() output=false {
		var local = {};
		local.properties = {};
		local.data = getMetaData(this).properties;
		for ( local.i=1; local.i <= ArrayLen(local.data); local.i++ ) {
			local.properties[local.data[local.i].name] = Evaluate('get#local.data[local.i].name#()');
		};
		return local.properties;
	}

}