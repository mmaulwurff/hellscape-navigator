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

class m8f_hn_Pointer
{

  enum PointerTypes
  {
    POINTER_WHITE,
    POINTER_BLUE,
    POINTER_GOLD,
    POINTER_GREEN,
    POINTER_ICE,
    POINTER_RED,
    POINTER_SKIP
  };

  m8f_hn_Pointer init(double x, double y, int type, int id)
  {
    _position.x = x;
    _position.y = y;
    _type       = type;
    _id         = id;

    return self;
  }

  double x()    { return _position.x; }
  double y()    { return _position.y; }
  int    type() { return _type;       }
  int    id()   { return _id;         }

  private vector2 _position;
  private int     _type;
  private int     _id;

} // m8f_hn_Pointer
