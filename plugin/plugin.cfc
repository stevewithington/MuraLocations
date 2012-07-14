/**
* 
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
*/
component extends="mura.plugin.plugincfc" accessors=true output=false {
	
	public void function install() output=false {
		var local = {};
		// need to check and see if this is already installed ... if so, then abort!
		local.moduleid = variables.pluginConfig.getModuleID();
		// only if this is NOT installed
		if ( val(getInstallationCount()) eq 1 ) {
			// do something
		} else {
			variables.pluginConfig.getPluginManager().deletePlugin(local.moduleid);
		};
		application.appInitialized = false;
	}

	public void function update() output=false {
		var local = {};
		application.appInitialized = false;
	};
	
	public void function delete() output=false {
		var local = {};
		// don't delete the subTypes if this is being invoked by the deletePlugin() from install()
		if ( val(getInstallationCount()) eq 1 ) {
			// WARNING: deleting a subType will also delete any extended attributes associated with it!
			// try {
			// 	deleteSubType(type='Page', subType='MuraLocation');
			// } catch (any e) {};
			// try {
			// 	deleteSubType(type='Portal', subType='MuraLocation');
			// } catch (any e) {};
		};
		application.appInitialized = false;
	}
	
	/**
	* i check to see if this plugin has already been installed. if so, i delete the new one
	*/
	private any function getInstallationCount(boolean debug=false) output=false {
		var qs = '';
		var qoq = '';
		var rs = application.configBean.getPluginManager().getAllPlugins();
		var local = {};
		local.ret = 0;
		if ( rs.recordcount ) {
			qs = new query();
			qs.setDBType('query');
			qs.setName('qoq');
			qs.setAttributes(rs=rs); // need this for qoq to work in cfscript
			qs.addParam(name='package', value=getPackageName(), cfsqltype='cf_sql_varchar', maxlength=100);
			qs.setSQL('SELECT * FROM rs where package = :package');
			local.result = qs.execute();
			local.metaInfo = local.result.getPrefix();
			if ( local.metaInfo.recordcount ) {
				local.ret = val(local.metaInfo.recordcount);
			};
		};
		if ( arguments.debug ) {
			return local.result;
		} else {
			return local.ret;
		};
	}

	private void function deleteSubType(required string type, required string subType) output=false {
		var local = {};
		local.rsSites = variabls.pluginConfig.getAssignedSites();
		local.subType = application.classExtensionManager.getSubTypeBean();
		for ( local.i=1; local.i <= local.rsSites.recordcount; local.i++ ) {
			local.subType.setType(arguments.type);
			local.subType.setSubType(arguments.subType);
			local.subType.setSiteID(local.rsSites.siteid[local.i]);
			local.subType.load();
			local.subType.delete();
		};
	}

}