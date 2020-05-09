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

    // cases when a map has no Player 1 start.
    if (pawn == NULL) { return; }

    _settings = new("m8f_hn_AutoSwitchSettings");
    _settings.init(player);

    FLineTraceData lineData;
    bool           isLineFound = LookLine(player, pawn, lineData);
  }

  override void WorldTick()
  {
    PlayerInfo player = players[consolePlayer];
    if (player == null) { return; }

    if (_settings.isEnabled())
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

    if (_settings.isMarkEnabled() && useSuccess)
    {
        EventHandler.SendNetworkEvent("m8f_hn_use");
    }
  }

  // private attributes section ////////////////////////////////////////////////

  m8f_hn_Utils _utils;
  int          _lastLineIndex;

  m8f_hn_AutoSwitchSettings _settings;

} // class m8f_hn_AutoSwitchEventHandler

class m8f_hn_AutoSwitchSettings : m8f_hn_SettingsPack
{

  // public: ///////////////////////////////////////////////////////////////////

  bool isEnabled    () { checkInit(); return _isEnabled    .value(); }
  bool isMarkEnabled() { checkInit(); return _isMarkEnabled.value(); }

  // private: //////////////////////////////////////////////////////////////////

  private
  void checkInit()
  {
    if (_isInitialized) { return; }

    clear();

    push(_isEnabled     = new("m8f_hn_BoolSetting").init("m8f_hn_auto_switch_enabled" , _player));
    push(_isMarkEnabled = new("m8f_hn_BoolSetting").init("m8f_hn_auto_switch_mark"    , _player));

    _isInitialized = true;
  }

  // private: //////////////////////////////////////////////////////////////////

  private m8f_hn_BoolSetting _isEnabled;
  private m8f_hn_BoolSetting _isMarkEnabled;

} // class m8f_hn_AutoSwitchSettings
