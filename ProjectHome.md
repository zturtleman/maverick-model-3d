Maverick Model 3D is a 3D modeling application based on [Misfit Model 3D](http://misfitcode.com/misfitmodel3d/). It is not under active development at this time.

## Goals ##
The main goals were to maintain and improve the Misfit Model 3D codebase.

Other Goals;
  * Add support for plugins on Windows.
  * Improve MD3 player support.
  * Add support for more formats, such as Elite Force MDR and [IQM](http://sauerbraten.org/iqm/).

## Changes ##
_See [Changes](Changes.md) for details._
  * Improved MD3 player model support.
    * Animations are no longer hardcoded, now players can be created for Quake III: Team Arena, Smokin' Guns, Turtle Arena, and other games which use different animations than Quake III Arena.
    * Unknown tags are now saved to all models instead of ignored.
    * Added head animations with "HEAD" prefix.
    * Added animation prefix "ALL" for animating legs, torso, and head.
    * ...and more
  * Started MDR importing/exporting (in md3filter.cc/h), doesn't work yet.