/**
* 
* This file is part of MuraLocations
*
* Copyright 2010-2015 Stephen J. Withington, Jr.
* Licensed under the Apache License, Version v2.0
* http://www.apache.org/licenses/LICENSE-2.0
*
*/
component accessors=true output=false {

  property name='$';

  this.pluginPath = GetDirectoryFromPath(GetCurrentTemplatePath());
	this.muraroot = Left(this.pluginPath, Find('plugins', this.pluginPath) - 1);
	this.depth = ListLen(RemoveChars(this.pluginPath,1, Len(this.muraroot)), '\/');  
	this.includeroot = RepeatString('../', this.depth);


  include 'plugin/settings.cfm';
  this.muraAppConfigPath = this.includeroot & 'core/';
	include this.muraAppConfigPath & 'appcfc/applicationSettings.cfm';

  try {
    include this.includeroot & 'config/mappings.cfm';
    include this.includeroot & 'plugins/mappings.cfm';
  } catch(any e) {}

  public any function onApplicationStart() {
    include this.muraAppConfigPath &  '/appcfc/onApplicationStart_include.cfm';
    var $ = get$();
    return true;
  }

  public any function onRequestStart(required string targetPage) {
    var $ = get$();
    include this.muraAppConfigPath &  '/appcfc/onRequestStart_include.cfm';

    if ( StructKeyExists(url, $.globalConfig('appreloadkey')) ) {
      onApplicationStart();
    }

    // You may want to change the methods being used to secure the request
    secureRequest();
    return true;
  }

  public void function onRequest(required string targetPage) {
    var $ = get$();
    var pluginConfig = $.getPlugin(variables.settings.pluginName);
    include arguments.targetPage;
  }


  // ----------------------------------------------------------------------
  // HELPERS

  public struct function get$() {
    return IsDefined('session') && StructKeyExists(session, 'siteid') 
      ? application.serviceFactory.getBean('$').init(session.siteid) 
      : application.serviceFactory.getBean('$').init('default');
  }

  public any function secureRequest() {
    var $ = get$();
    return !inPluginDirectory() || $.currentUser().isSuperUser() 
      ? true 
      : ( inPluginDirectory() && !structKeyExists(session, 'siteid') ) 
        || ( inPluginDirectory() && !$.getBean('permUtility').getModulePerm($.getPlugin(variables.settings.pluginName).getModuleID(),session.siteid) )
        ? goToLogin() 
        : true;
  }

  public boolean function inPluginDirectory() {
    return ListFindNoCase(getPageContext().getRequest().getRequestURI(), 'plugins', '/');
  }

  private void function goToLogin() {
    var $ = get$();
    location(url='#$.globalConfig('context')#/admin/index.cfm?muraAction=clogin.main&returnURL=#$.globalConfig('context')#/plugins/#$.getPlugin(variables.settings.pluginName).getPackage()#/', addtoken=false);
  }

}