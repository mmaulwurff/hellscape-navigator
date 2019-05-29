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

class m8f_hn_Data
{

  Array<Sector>  secretSectors;
  Array<int>     itemAreaPosX;
  Array<int>     itemAreaPosY;
  Array<int>     itemAreaPosZ;
  Array<string>  itemAreaNames;
  Array<string>  areaItems;
  Array<Actor>   areaNameMarkers;
  Array<Actor>   questPointers;

  Array<m8f_hn_Pointer> pointers;
  int pointerId;

  m8f_hn_Data init()
  {
    int nSectors = level.sectors.size();
    for (int i = 0; i < nSectors; ++i)
      {
        Sector s        = level.sectors[i];
        bool   isSecret = (s.Flags & (Sector.SECF_SECRET | Sector.SECF_WASSECRET));
        if (isSecret)
          {
            secretSectors.push(s);
          }
      }

    areaItems.push("Key");
    areaItems.push("Weapon"); // weapons
    areaItems.push("Goonades");
    areaItems.push("SPAMMineItem");
    areaItems.push("PowerupGiver"); // powerups
    areaItems.push("MegaSphere");
    areaItems.push("SoulSphere");
    areaItems.push("GreenArmor");
    areaItems.push("BlueArmor");
    areaItems.push("TBPowerupBase");
    areaItems.push("MapRevealer");
    areaItems.push("Berserk");
    areaItems.push("Speeders");
    areaItems.push("IcarusMk8");
    areaItems.push("ProtectoBand");
    areaItems.push("BigSPAMMine");
    areaItems.push("GuardBoi");
    areaItems.push("BadassGlasses");
    areaItems.push("Mapisto");
    areaItems.push("LovebirdTag");
    areaItems.push("BigScorePresent");
    areaItems.push("BackpackItem"); // backpacks
    areaItems.push("Backpack2");
    areaItems.push("BlueprintItem");
    areaItems.push("NetronianBackpack");
    areaItems.push("Big_Coin_pickup"); // other

    pointerId = 0;

    return self;
  }

} // class m8f_hn_Data
