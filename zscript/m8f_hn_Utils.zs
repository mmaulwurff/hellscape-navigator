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

class m8f_hn_Utils
{

  // public methods section ////////////////////////////////////////////////////

  bool getPlayerViewLine(PlayerInfo player, double range, out FLineTraceData data)
  {
    Actor  playerActor   = player.mo;
    double angle         = playerActor.angle;
    double pitch         = playerActor.pitch;
    int    flags         = 0;
    double offsetz       = player.viewheight;
    double offsetforward = 0.0;
    double offsetside    = 0.0;

    bool success = LineTraceConst( playerActor
                                 , angle
                                 , range
                                 , pitch
                                 , flags
                                 , offsetz
                                 , offsetforward
                                 , offsetside
                                 , data
                                 );

    return success;
  }

  static bool isExit(Sector s)
  {
    int nLines = s.lines.size();
    for (int i = 0; i < nLines; ++i)
    {
      Line l = s.lines[i];
      int  s = l.special;
      if (s == 74 || s == 75 || s == 243 || s == 244)
      {
        return true;
      }
    }

    return false;
  }

  // private methods section ///////////////////////////////////////////////////

  private play bool LineTraceConst( Actor  player
                                  , double angle
                                  , double distance
                                  , double pitch
                                  , int    flags
                                  , double offsetz
                                  , double offsetforward
                                  , double offsetside
                                  , out FLineTraceData data
                                  ) const
  {
    return player.LineTrace(angle, distance, pitch, flags, offsetz, offsetforward, offsetside, data);
  }


} // class m8f_hn_Utils
