#MuraLocations TM
This is a [Mura CMS](http://getmura.com) Plugin that allows content managers to add/edit Locations which can then be displayed on a Google Map. The plugin also allows for end-users to either use their current location or enter their address to obtain a list of the 'closest' locations.

##Description

This plugin creates two new content types in Mura:

* ###Folder / MuraLocation
This content type will display a Google Map to display any 'Page / MuraLocation' types that have been created on the site. There are a number of configurable options available on the 'Extended Attributes' tab such as Map Width, Map Height, Default Zoom, Map Type, Display Directions, Display Travel Mode Options, etc. Please refer to the help icons on the form for more information regarding these fields.

* ###Page / MuraLocation
This content type will display a Google Map of the location. The location information can be entered/updated by editing the 'Extended Attributes' tab. In addition to most of the same attributes available for 'Folder / MuraLocation' you can enter information such as Street Address, City/Locality, State/Region, Postal Code, Phone, Fax, Email, Latitude and Longitude. Please refer to the help icons on the form for more information regarding these fields.

###Plugin Display Objects

There are two display objects available:

* ####Locations Map
This is quite similar to the 'Folder / MuraLocation' with the exception that it will display a map of all content typed as 'Page / MuraLocation' as long as the 'Show on All Locations Map Display Object' setting is set to yes.

* ####Find Locations Form
This allows end-users the ability to find locations nearest them. Depending on the user's browser, they may be able to simply click Use Current Location.

To use these display objects, go to the 'Layout & Objects' tab > Select 'Plugins' from the 'Available Content Objects' select menu > Select 'MuraLocations' from the list of plugins > Then select a display object and assign it to your desired display region.

##Designers / Developers

The 'Plugin Display Objects' may also be added directly onto your template or even dropped into a content region using '[mura]' tags.

###Find Locations Form Example Code

####Mura Tag Method
```coldfusion
[mura]$.muraLocations.dspFindLocationsForm()[/mura]
```

####CFML Method
```coldfusion
#$.muraLocations.dspFindLocationsForm()#
```

Also, if your theme is using jQuery Mobile, then you will really enjoy the 'Find Locations Form' display object. Be sure to check it out in Mobile Format!

###Locations Map Example Code

####Mura Tag Method
```coldfusion
[mura]$.muraLocations.dspLocationsMap()[/mura]
```

####CFML Method
```coldfusion
#$.muraLocations.dspLocationsMap()#
```

You can optionally pass in some arguments to this method as well to control the display:

```coldfusion
boolean displayDirections=true
boolean displayTravelMode=true
string start=''
numeric mapHeight=400
string mapType='TERRAIN'
numeric mapWidth=0
string mapZoom='default'
```

####Example Using Arguments
```coldfusion
#$.muraLocations.dspLocationsMap(displayTravelMode=false, mapType='ROADMAP')#
```

##Recommended Setup

Probably the best way to use this plugin would be to setup your 'Locations' area like this:
```coldfusion
- Locations (Just a normal Page or Folder)
	- Find Locations (A Page with the 'Find Location Form' added to the main content area)
	- View All Locations (Folder / MuraLocation)
		- Location 1 (Page / MuraLocation)
		- Location 2 (Page / MuraLocation)
		- etc.
```

Technically, you could have 'Page / MuraLocation' content nodes scattered throughout your site and simply use the 'Find Location Form' display object on a 'Find Closest Location' page.

##Developer Notes

* The following default Mura CMS form fields are assumed to be unique properties of the Location and thus will be automatically marked up with microdata for SEO purposes:
	* The Title is assumed to be the name of the Location.
	* The primary associated image is assumed to be an image of the Location.
	* The Content is assumed to be a description of the Location.
* See http://schema.org/Place for details on microdata information used in this plugin.

##Tested With

* Mura CMS Core Version 6.0+
* Adobe ColdFusion 10.0.4
* Railo 4.0.2.002

###Should Also Work With

_Minimum Mura CMS Core Version required is 6.0+_

* ColdFusion 9.0.1+
* Railo 3.3.1+

## Need help?

If you're running into an issue, please let me know at https://github.com/stevewithington/MuraLocations/issues and I'll try to address it as soon as I can.

Cheers!
[Steve Withington](http://www.stephenwithington.com)

##License
Copyright 2012 Stephen J. Withington, Jr.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.