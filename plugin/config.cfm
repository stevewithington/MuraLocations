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
if ( !IsDefined('$') ) {
	$ = application.serviceFactory.getBean('$');
	if ( StructKeyExists(session, 'siteid') ) {
		$.init(session.siteid);
	} else {
		$.init('default');
	}
}

if ( !IsDefined('pluginConfig') ) {
	pluginConfig = $.getBean('pluginManager').getConfig('MuraLocations');
}

if ( !$.currentUser().isSuperUser() ) {
	location($.globalConfig('context') & '/admin/', false);
}
</cfscript></cfsilent>