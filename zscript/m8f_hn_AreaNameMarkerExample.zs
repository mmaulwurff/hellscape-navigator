/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2018-2019
 *
 * This file is part of Hellscape Navigator.
 *
 * Hellscape Navigator is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Hellscape Navigator is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Hellscape Navigator.  If not, see <https://www.gnu.org/licenses/>.
 */

// This is an example of Area Name Marker
// To make Hellscape Navigator display the custom area name:
//
// 1. Copy this class to your wad/pk3 ZScript code;
// 2. Give the class a unique name, e.g. my_own_hn_AreaNameMarker_something
//    The name can by anything, but it must contain substring "hn_AreaNameMarker"
//    to be recognized by Hellscape Navigator.
// 3. Area name is stored in "Tag" property, so put it there.
// 4. Area radius is stored in "Health" property, so put it there.
// 5. Put an object of this class on the map.
//
// Notes:
// - You can create as many AreaMarker classes as you want, each of them can
//   carry its own area name.
// - AreaNameMarker detection is dynamic, so if actor moves on the map, area name
//   moves with it.
//
class m8f_hn_AreaNameMarker_Example : Actor
{
  Default
  {
    Tag    "Area Name of AreaMarker Example";
    Health 128;

    +NOBLOCKMAP;
    +NOGRAVITY;
    +DONTSPLASH;
    +NOTONAUTOMAP;
    +DONTTHRUST;
  }
}
