/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2018-2021
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

class hn_Level
{

  static
  bool isTitlemap()
  {
    return (level.mapname == "TITLEMAP");
  }

  ui static
  bool isSwitch(Line l)
  {
    bool activation = (l.activation & ( SPAC_Use
                                      | SPAC_Impact
                                      | SPAC_Push
                                      | SPAC_UseThrough
                                      | SPAC_UseBack
                                      ));
    return (activation);
  }

  ui static
  bool hasLock(Line l)
  {
    int  special     = l.special;
    bool lineHasLock = (special == 13 || special == 83 || special == 85);

    return lineHasLock;
  }

  static
  bool isExit(Sector s)
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

  /// This function is not static because of line trace is in play scope.
  play
  bool getPlayerViewLine(PlayerInfo player, double range, out FLineTraceData data) const
  {
    Actor  playerActor   = player.mo;
    double angle         = playerActor.angle;
    double pitch         = playerActor.pitch;
    int    flags         = 0;
    double offsetz       = player.viewheight;
    double offsetforward = 0.0;
    double offsetside    = 0.0;

    return playerActor.LineTrace( angle
                                , range
                                , pitch
                                , flags
                                , offsetz
                                , offsetforward
                                , offsetside
                                , data
                                );
  }

} // class hn_Level
