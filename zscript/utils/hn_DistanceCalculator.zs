/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2021
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

class hn_DistanceCalculator
{

  // returns:
  // double distance
  // bool   true if distance is less then radius, false otherwise.
  //
  // if second return values is false, distance is undefined.
  //
  static double, bool calculateDistance( vector3 pos1
                                       , vector3 pos2
                                       , double  radiusSq
                                       )
  {
    double dx         = pos1.x - pos2.x;
    double dy         = pos1.y - pos2.y;
    double dz         = pos1.z - pos2.z;
    double distance   = dx * dx + dy * dy + dz * dz;
    bool   isInRadius = distance < radiusSq;

    return distance, isInRadius;
  }

} // hn_DistanceCalculator
