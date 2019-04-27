# MuraLocations TM

This is a [Mura CMS](http://getmura.com) Plugin that allows content managers to add/edit Locations which can then be displayed on a Google Map. The plugin also allows for end-users to either use their current location or enter their address to obtain a list of the 'closest' locations.

## Description

This plugin creates two new content types in Mura:

* ### Folder / MuraLocationsMap

This content type will display a Google Map to display any 'Page / MuraLocation' types that have been created on the site. There are a number of configurable options available on the 'Extended Attributes' tab such as Map Width, Map Height, Default Zoom, Map Type, Display Directions, Display Travel Mode Options, etc. Please refer to the help icons on the form for more information regarding these fields.

* ### Page / MuraLocation

This content type will display a Google Map of the location. The location information can be entered/updated by editing the 'Extended Attributes' tab. In addition to most of the same attributes available for 'Folder / MuraLocationsMap' you can enter information such as Street Address, City/Locality, State/Region, Postal Code, Phone, Fax, Email, Latitude and Longitude. Please refer to the help icons on the form for more information regarding these fields.

### Plugin Display Objects

There are two display objects available:

* #### Locations Map

This is quite similar to the 'Folder / MuraLocationsMap' with the exception that it will display a map of all content typed as 'Page / MuraLocation' as long as the 'Show on All Locations Map Display Object' setting is set to yes.

* #### Find Locations Form

This allows end-users the ability to find locations nearest them. Depending on the user's browser, they may be able to simply click Use Current Location.

To use these display objects, go to the 'Layout & Objects' tab > Select 'Plugins' from the 'Available Content Objects' select menu > Select 'MuraLocations' from the list of plugins > Then select a display object and assign it to your desired display region.

## Designers / Developers

The 'Plugin Display Objects' may also be added directly onto your template or even dropped into a content region using '[mura]' tags.

### Find Locations Form Example Code

#### Mura Tag Method

```
[mura]$.muraLocations.dspFindLocationsForm()[/mura]
```

#### CFML Method

```
#$.muraLocations.dspFindLocationsForm()#
```

Also, if your theme is using jQuery Mobile, then you will really enjoy the 'Find Locations Form' display object. Be sure to check it out in Mobile Format!

### Locations Map Example Code

#### Mura Tag Method

```
[mura]$.muraLocations.dspLocationsMap()[/mura]
```

#### CFML Method

```
#$.muraLocations.dspLocationsMap()#
```

You can optionally pass in some arguments to this method as well to control the display:

```
boolean displayDirections=true
boolean displayTravelMode=true
string start=''
numeric mapHeight=400
string mapType='TERRAIN'
numeric mapWidth=0
string mapZoom='default'
string contentID='' // will accept a valid contentid or filename to narrow down the section of a site you wish to display locations from
```

#### Example Using Arguments

```
#$.muraLocations.dspLocationsMap(displayTravelMode=false, mapType='ROADMAP')#
```

### Simple Map Example Code

A method has been included with this plugin to quickly and easily display a simple Google Map based on just a location name, it's latitude, and longitude. This method is not tied to any content types in Mura. Whereas the ```dspLocationsMap()``` method only displays locations that have been added to Mura as ```Page/MuraLocation```.

#### Mura Tag Method

```
[mura]$.muraLocations.dspSimpleMap(name='Location Name', latitude=38.58439200000001, longitude=-121.284517)[/mura]
```

#### CFML Method

```
#$.muraLocations.dspSimpleMap(name='Location Name', latitude=38.58439200000001, longitude=-121.284517)#
```

## Recommended Setup

Probably the best way to use this plugin would be to setup your 'Locations' area like this:

```
- Locations (Just a normal Page or Folder)
	- Find Locations (A Page with the 'Find Location Form' display object added to the main content area)
	- View All Locations (Folder / MuraLocationsMap)
		- Location 1 (Page / MuraLocation)
		- Location 2 (Page / MuraLocation)
		- etc.
```

Technically, you could have 'Page / MuraLocation' content nodes scattered throughout your site and simply use the 'Find Location Form' display object on a 'Find Closest Location' page.

## Developer Notes

* The following default Mura CMS form fields are assumed to be unique properties of the Location and thus will be automatically marked up with microdata for SEO purposes:
  * The Title is assumed to be the name of the Location.
  * The primary associated image is assumed to be an image of the Location.
  * The Content is assumed to be a description of the Location.
* See http://schema.org/Place for details on microdata information used in this plugin.

## Tested With

* Mura CMS Core Version 6.2+
* Adobe ColdFusion 11.0.4
* Lucee 4.5

## Need help?

If you're running into an issue, please let me know at https://github.com/stevewithington/MuraLocations/issues and I'll try to address it as soon as I can.

Cheers!
[Steve Withington](http://www.stephenwithington.com)

## License

Copyright 2010-2019 Stephen J. Withington, Jr.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this work except in compliance with the License. You may obtain a copy of the License in the LICENSE file, or at:

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.