/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2018-2019
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

class m8f_hn_UseMarker : m8f_hn_FadingMarker
{

  States
  {
    Spawn:
      HNUM B -1;
      Stop;
  }

} // class m8f_hn_UseMarker

class m8f_hn_UseMarkerEventHandler : EventHandler
{

  // override section //////////////////////////////////////////////////////////

  override void WorldLoaded(WorldEvent e)
  {
    _settings = new("m8f_hn_FootstepSettings");
    _settings.init(players[consolePlayer]);
  }

  override void NetworkProcess(ConsoleEvent event)
  {
    if (event.name == "m8f_hn_use") { SetUseMarker(players[event.player]); }
  }

  // private methods section ///////////////////////////////////////////////////

  private void SetUseMarker(PlayerInfo player)
  {
    double         useRange = player.mo.useRange;
    FLineTraceData lineData;
    bool           success  = _utils.getPlayerViewLine(player, useRange, lineData);

    if (!success) { return; }

    Vector3 pos = lineData.HitLocation;

    let marker = Actor.Spawn("m8f_hn_UseMarker", pos);
    m8f_hn_FadingMarker(marker).init( _settings.markerLifetime()
                                    , _settings.markerAlpha()
                                    , _settings.markerForever()
                                    , _settings.markerScale()
                                    );
  }

  // private attributes section ////////////////////////////////////////////////

  m8f_hn_Utils            _utils;
  m8f_hn_FootstepSettings _settings;

} // class m8f_hn_UseMarkerEventHandler
