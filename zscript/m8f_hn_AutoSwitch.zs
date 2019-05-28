/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2018
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

class m8f_hn_AutoSwitchEventHandler : EventHandler
{

  // override section //////////////////////////////////////////////////////////

  override void OnRegister()
  {
    _lastLineIndex = -1;
  }

  override void PlayerEntered(PlayerEvent event)
  {
    if (event.playerNumber != consolePlayer) { return; }

    PlayerInfo player = players[consolePlayer];
    PlayerPawn pawn   = player.mo;

    _settings = new("m8f_hn_AutoSwitchSettings").init(player);

    FLineTraceData lineData;
    bool           isLineFound = LookLine(player, pawn, lineData);
  }

  override void WorldTick()
  {
    PlayerInfo player = players[consolePlayer];
    if (player == null) { return; }

    int optionsUpdatePeriod = CVar.GetCVar("m8f_hn_update_period", player).GetInt();

    if (optionsUpdatePeriod == 0) { _settings.read(player); }
    else if (optionsUpdatePeriod != -1
             && (level.time % optionsUpdatePeriod) == 0)
    {
      _settings.read(player);
    }

    if (_settings.isEnabled)
    {
      PlayerUseLine(player);
    }
  }

  // private methods section ///////////////////////////////////////////////////

  private bool LookLine(PlayerInfo player, PlayerPawn pawn, out FLineTraceData lineData)
  {
    double useRange = pawn.useRange;
    bool   success  = _utils.getPlayerViewLine(player, useRange, lineData);

    if (!success || lineData.hitLine == null) { return false; }

    int lineIndex = lineData.hitLine.Index();

    if (_lastLineIndex == lineIndex) { return false; }
    _lastLineIndex = lineIndex;

    return true;
  }

  private void PlayerUseLine(PlayerInfo player)
  {
    PlayerPawn pawn = player.mo;
    if (pawn == null) { return; }

    FLineTraceData lineData;
    bool           isLineFound = LookLine(player, pawn, lineData);

    if (!isLineFound) { return; }

    bool useSuccess = lineData.hitLine.activate(pawn, lineData.lineside, 2);

    if (_settings.isMarkEnabled && useSuccess)
    {
        EventHandler.SendNetworkEvent("m8f_hn_use");
    }
  }

  // private attributes section ////////////////////////////////////////////////

  m8f_hn_Utils _utils;
  int          _lastLineIndex;

  m8f_hn_AutoSwitchSettings _settings;

} // class m8f_hn_AutoSwitchEventHandler

class m8f_hn_AutoSwitchSettings
{

  bool isEnabled;
  bool isMarkEnabled;

  void read(PlayerInfo player)
  {
    isEnabled     = CVar.GetCVar("m8f_hn_auto_switch_enabled" , player).GetInt();
    isMarkEnabled = CVar.GetCVar("m8f_hn_auto_switch_mark"    , player).GetInt();
  }

  m8f_hn_AutoSwitchSettings init(PlayerInfo player)
  {
    read(player);
    return self;
  }

} // class m8f_hn_AutoSwitchSettings
