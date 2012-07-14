/*
* This file is part of MuraLocations TM
* (c) Stephen J. Withington, Jr. | www.stephenwithington.com
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License along
* with this program; if not, write to the Free Software Foundation, Inc.,
* 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
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