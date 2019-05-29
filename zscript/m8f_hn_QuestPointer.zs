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

// This is an example of Quest Pointer
// To make Hellscape Navigator Compass display the quest marker:
//
// 1. Copy this class to your wad/pk3 ZScript code;
// 2. Give the class a unique name, e.g. my_own_hn_QuestPointer_something
//    The name can by anything, but it must contain substring "hn_QuestPointer"
//    to be recognized by Hellscape Navigator.
// 3. Put an object of this class on the map.
//
// Notes:
// - You can create as many QuestPointer classes as you want.
// - QuestPointer detection is dynamic, so if actor moves on the map,
//   the position change is reflected on Compass.
//
class m8f_hn_QuestPointer_Example : MapMarker
{

  override void BeginPlay()
  {
    double mapScale = CVar.GetCVar("m8f_hn_quest_marker_scale").GetFloat();
    scale.x = mapScale * 0.2;
    scale.y = mapScale * 0.2;
    super.BeginPlay();
  }

  States
    {
    Spawn:
      HNQU B -1;
      Stop;
    }

} // class m8f_hn_QuestPointer_Example
