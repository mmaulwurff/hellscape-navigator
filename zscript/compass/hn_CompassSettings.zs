/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2021
 *
 * This file is part of Hellscape Navigator.
 *
 * Hellscape Navigator is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by the Free
 * Software Foundation, either version 3 of the License, or (at your option) any
 * later version.
 *
 * Hellscape Navigator is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with
 * Hellscape Navigator.  If not, see <https://www.gnu.org/licenses/>.
 */

class hn_CompassSettings
{

  static
  hn_CompassSettings from()
  {
    let result = new("hn_CompassSettings");

    result._isShowingOnAutomap = hn_Cvar.from("m8f_hn_compass_automap");

    return result;
  }

  bool isShowingOnAutomap() const { return _isShowingOnAutomap.getBool(); }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private hn_Cvar _isShowingOnAutomap;

} // class hn_CompassSettings
