<cfcomponent>
<cfscript>
/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2014 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
	public any function init() output=false { 
		return this; 
	}
</cfscript>
	
	<cffunction name="htmlHead" output="false" returntype="void">
		<cfargument name="text" type="string" default="" />
		<cfhtmlhead text="#arguments.text#" />
	</cffunction>
</cfcomponent>