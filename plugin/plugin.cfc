/**
* 
* This file is part of MuraLocations TM
*
* Copyright 2010-2013 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
component extends="mura.plugin.plugincfc" accessors=true output=false {
	
	public void function install() output=false {
		application.appInitialized = false;
	}

	public void function update() output=false {
		application.appInitialized = false;
	}
	
	public void function delete() output=false {
		application.appInitialized = false;
	}

}