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

class m8f_hn_StrafeRunAimEventHandler : EventHandler
{

  // public: ///////////////////////////////////////////////////////////////////

  override void WorldTick()
  {
    if (!_settings.isStrafeRunAimEnabled()) { return; }

    if (isStrafe())
    {
      DrawRunAim();
    }

    //debug();
  }

  override void PlayerEntered(PlayerEvent event)
  {
    int playerNumber = event.playerNumber;

    _settings = new("m8f_hn_StrafeRunAimSettings");
    _settings.init(players[playerNumber]);
  }

  override void OnRegister()
  {
    _isForwardPressed   = false;
    _isMoveRightPressed = false;
    _isMoveLeftPressed  = false;
  }

  override bool InputProcess(InputEvent event)
  {
    if (event.type == InputEvent.Type_Mouse) { return false; }

    bool isPressed = (event.type == InputEvent.Type_KeyDown);

    if (isPressed)
    {
      if      (isForwardKey  (event)) { EventHandler.SendNetworkEvent("m8f_hn_forward_down"); }
      else if (isMoveRightKey(event)) { EventHandler.SendNetworkEvent("m8f_hn_right_down"  ); }
      else if (isMoveLeftKey (event)) { EventHandler.SendNetworkEvent("m8f_hn_left_down"   ); }
    }
    else
    {
      if      (isForwardKey  (event)) { EventHandler.SendNetworkEvent("m8f_hn_forward_up"); }
      else if (isMoveRightKey(event)) { EventHandler.SendNetworkEvent("m8f_hn_right_up"  ); }
      else if (isMoveLeftKey (event)) { EventHandler.SendNetworkEvent("m8f_hn_left_up"   ); }
    }

    return false;
  }

  override void NetworkProcess(ConsoleEvent event)
  {
    if      (event.name == "m8f_hn_forward_down") { _isForwardPressed   = true;  }
    else if (event.name == "m8f_hn_forward_up"  ) { _isForwardPressed   = false; }
    else if (event.name == "m8f_hn_right_down"  ) { _isMoveRightPressed = true;  }
    else if (event.name == "m8f_hn_right_up"    ) { _isMoveRightPressed = false; }
    else if (event.name == "m8f_hn_left_down"   ) { _isMoveLeftPressed  = true;  }
    else if (event.name == "m8f_hn_left_up"     ) { _isMoveLeftPressed  = false; }
  }

  // private: //////////////////////////////////////////////////////////////////

  private void DrawRunAim()
  {
    PlayerInfo player = players[consolePlayer];
    if (player == null) { return; }

    Actor playerActor = player.mo;
    if (playerActor == null) { return; }

    double angle = playerActor.angle;
    if (_isMoveRightPressed) { angle -= _sr40Angle; }
    else                     { angle += _sr40Angle; }
    angle %= 360.0;
    double xStep = cos(angle) * 15;
    double yStep = sin(angle) * 15;

    for (int i = 5; i < 40; ++i)
    {
      double xOffset = xStep * i;
      double yOffset = yStep * i;
      playerActor.A_SpawnParticle( _aimColor, _aimFlags, _aimLifetime, _aimSize, 0
                                 , xOffset, yOffset, _aimZOffset, 0, 0, 0, 0, 0, 0, 1.0
                                 );
    }
  }

  private static ui bool isForwardKey  (InputEvent event) { return isKeyForCommand(event, "+forward"  ); }
  private static ui bool isMoveRightKey(InputEvent event) { return isKeyForCommand(event, "+moveright"); }
  private static ui bool isMoveLeftKey (InputEvent event) { return isKeyForCommand(event, "+moveleft" ); }

  private static ui bool isKeyForCommand(InputEvent event, String command)
  {
    int key1;
    int key2;
    [key1, key2] = bindings.GetKeysForCommand(command);

    bool isKey = (key1 == event.keyScan) || (key2 == event.keyScan);

    return isKey;
  }

  private bool isStrafe()
  {
    bool isStrafe = (_isForwardPressed && (_isMoveRightPressed || _isMoveLeftPressed));

    return isStrafe;
  }

  private void debug()
  {
    console.printf("f: %d, r: %d, l: %d", _isForwardPressed, _isMoveRightPressed, _isMoveLeftPressed);
  }

  // private: //////////////////////////////////////////////////////////////////

  private bool _isForwardPressed;
  private bool _isMoveRightPressed;
  private bool _isMoveLeftPressed;

  private m8f_hn_StrafeRunAimSettings _settings;

  // private: //////////////////////////////////////////////////////////////////

  const _aimColor    = "00 00 ff";
  const _aimFlags    = SPF_FULLBRIGHT;
  const _aimLifetime = 1;
  const _aimSize     = 3.0;
  const _aimZOffset  = _aimSize / 2 + 24;
  const _sr40Angle   = 38.6598082540901;

} // class m8f_hn_StrafeRunAimEventHandler
