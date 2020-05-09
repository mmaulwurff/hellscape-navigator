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

class m8f_hn_FootstepSettings : m8f_hn_SettingsPack
{

  // public: ///////////////////////////////////////////////////////////////////

  enum FootstepMarkerTypes
  {
    MARKER_FOOTSTEP,
    MARKER_CIRCLE,
    MARKER_ARROW,
    MARKER_OFF,
  }

  // public: ///////////////////////////////////////////////////////////////////

  int    footstepPeriod() { checkInit(); return _footstepPeriod.value()     ; } // tics
  int    markerType    () { checkInit(); return _markerType.value()         ; } // FootstepMarkerTypes
  int    markerLifetime() { checkInit(); return _markerLifetime.value() * 35; } // tics
  double markerAlpha   () { checkInit(); return _markerAlpha.value()        ; }
  bool   markerForever () { checkInit(); return _markerForever.value()      ; }
  double markerScale   () { checkInit(); return _markerScale.value()        ; }

  // private: //////////////////////////////////////////////////////////////////

  private
  void checkInit()
  {
    if (_isInitialized) { return; }

    clear();

    push(_footstepPeriod = new("m8f_hn_IntSetting"   ).init("m8f_hn_marker_spawn_period", _player));
    push(_markerType     = new("m8f_hn_IntSetting"   ).init("m8f_hn_marker_type"        , _player));
    push(_markerLifetime = new("m8f_hn_IntSetting"   ).init("m8f_hn_marker_lifetime"    , _player));
    push(_markerAlpha    = new("m8f_hn_DoubleSetting").init("m8f_hn_marker_alpha"       , _player));
    push(_markerForever  = new("m8f_hn_BoolSetting"  ).init("m8f_hn_marker_forever"     , _player));
    push(_markerScale    = new("m8f_hn_DoubleSetting").init("m8f_hn_marker_scale"       , _player));

    _isInitialized = true;
  }

  // private: //////////////////////////////////////////////////////////////////

  private m8f_hn_IntSetting    _footstepPeriod;
  private m8f_hn_IntSetting    _markerType    ;
  private m8f_hn_IntSetting    _markerLifetime;
  private m8f_hn_DoubleSetting _markerAlpha   ;
  private m8f_hn_BoolSetting   _markerForever ;
  private m8f_hn_DoubleSetting _markerScale   ;

} // class m8f_hn_FootstepSettings

class m8f_hn_FootstepHandler : EventHandler
{

  // override section //////////////////////////////////////////////////////////

  override void OnRegister()
  {
    _left          = false;

    _isFirstTick   = true;
    _isWorldLoaded = false;
  }

  override void WorldLoaded(WorldEvent e)
  {
    _settings = new("m8f_hn_FootstepSettings");
    _settings.init(players[consolePlayer]);
  }

  override void WorldTick()
  {
    makeFootstepMarks();
  }

  override void NetworkProcess(ConsoleEvent event)
  {
    if (event.name == "m8f_hn_remove_footsteps") { removeFootsteps(); }
  }

  override void PlayerEntered(PlayerEvent event)
  {
    PlayerInfo player = players[event.playerNumber];
    Actor playerActor = player.mo;

    if (playerActor == NULL) { return; }

    if (CVar.GetCvar("m8f_hn_mark_start", player).getBool())
    {
      Actor.Spawn("hn_StartMarker", playerActor.pos);
    }
  }

  // private methods section ///////////////////////////////////////////////////

  private void makeFootstepMarks()
  {
    if (_settings.markerType() == _settings.MARKER_OFF) { return; }
    if (level.time % _settings.footstepPeriod() != 0)  { return; }

    if (!_isFirstTick) { _isWorldLoaded = true; }
    _isFirstTick = false;

    PlayerInfo player      = players[consolePlayer];
    Actor      playerActor = player.mo;
    vector3    pos         = playerActor.pos;
    if (_oldPos == pos) { return; }

    double xdiff = _oldPos.x - pos.x;
    double ydiff = _oldPos.y - pos.y;
    double dist  = xdiff * xdiff + ydiff * ydiff;
    if (dist < 400) { return; }

    _oldPos = pos;

    string markerClass;
    switch (_settings.markerType())
      {
      case _settings.MARKER_FOOTSTEP:
        {
          double angle  = playerActor.angle;
          string letter = AngleLetter(angle);
          markerClass   = _left ? "m8f_hn_FadingLeft" : "m8f_hn_FadingRight";
          markerClass.AppendFormat(letter);
          _left = !_left;
        }
        break;

      case _settings.MARKER_CIRCLE:
        markerClass = "m8f_hn_FadingCircle";
        break;

      case _settings.MARKER_ARROW:
        {
          double angle  = playerActor.angle;
          string letter = AngleLetter(angle);
          markerClass   = "m8f_hn_FadingArrow";
          markerClass.AppendFormat(letter);
        }
        break;
      }

    let marker = Actor.Spawn(markerClass, pos);
    m8f_hn_FadingMarker(marker).init( _settings.markerLifetime()
                                    , _settings.markerAlpha()
                                    , _settings.markerForever()
                                    , _settings.markerScale()
                                    );
  }

  private static void removeFootsteps()
  {
    let   iterator = ThinkerIterator.Create("m8f_hn_FadingMarker");
    Actor sign;
    while (sign = Actor(iterator.Next()))
      {
        sign.Destroy();
      }
  }

  private static string AngleLetter(double angle)
  {
    static const string letters[] =
      {
        "3", "A", "2", "9", "1", "G", "8", "F",
        "7", "E", "6", "D", "5", "C", "4", "B"
      };

    angle += 45.0 / 4;
    angle %= 360.0;
    return letters[int(angle / 22.5)];
  }

  // private attributes section ////////////////////////////////////////////////

  private m8f_hn_FootstepSettings _settings;

  private bool    _left;
  private vector3 _oldPos;
  private bool    _isFirstTick;
  private bool    _isWorldLoaded;

} // class m8f_hn_FootstepHandler

class m8f_hn_FadingMarker : MapMarker
{

  Default
    {
      RenderStyle "Translucent";
      XScale 0.04;
      YScale 0.04;
      +NOTONAUTOMAP;
    }

  double fadeStep;
  bool   forever;

  m8f_hn_FadingMarker init(int lifetime, double initAlpha, bool f, double s)
  {
    alpha    = initAlpha;
    fadeStep = alpha / lifetime;
    forever  = f;
    scale.x *= s;
    scale.y *= s;
    return self;
  }

  override void Tick()
  {
    if (forever) { return; }

    alpha -= fadeStep;
    if (alpha <= 0.0) { Destroy(); }
  }

  States
    {
    Spawn:
      HNF1 A -1;
      Stop;
    }

} // class m8f_hn_FadingMarker

class m8f_hn_FadingLeft1 : m8f_hn_FadingMarker {States{ Spawn: HNL1 A -1; Stop; }}
class m8f_hn_FadingLeft2 : m8f_hn_FadingMarker {States{ Spawn: HNL2 A -1; Stop; }}
class m8f_hn_FadingLeft3 : m8f_hn_FadingMarker {States{ Spawn: HNL3 A -1; Stop; }}
class m8f_hn_FadingLeft4 : m8f_hn_FadingMarker {States{ Spawn: HNL4 A -1; Stop; }}
class m8f_hn_FadingLeft5 : m8f_hn_FadingMarker {States{ Spawn: HNL5 A -1; Stop; }}
class m8f_hn_FadingLeft6 : m8f_hn_FadingMarker {States{ Spawn: HNL6 A -1; Stop; }}
class m8f_hn_FadingLeft7 : m8f_hn_FadingMarker {States{ Spawn: HNL7 A -1; Stop; }}
class m8f_hn_FadingLeft8 : m8f_hn_FadingMarker {States{ Spawn: HNL8 A -1; Stop; }}
class m8f_hn_FadingLeft9 : m8f_hn_FadingMarker {States{ Spawn: HNL9 A -1; Stop; }}
class m8f_hn_FadingLeftA : m8f_hn_FadingMarker {States{ Spawn: HNLA A -1; Stop; }}
class m8f_hn_FadingLeftB : m8f_hn_FadingMarker {States{ Spawn: HNLB A -1; Stop; }}
class m8f_hn_FadingLeftC : m8f_hn_FadingMarker {States{ Spawn: HNLC A -1; Stop; }}
class m8f_hn_FadingLeftD : m8f_hn_FadingMarker {States{ Spawn: HNLD A -1; Stop; }}
class m8f_hn_FadingLeftE : m8f_hn_FadingMarker {States{ Spawn: HNLE A -1; Stop; }}
class m8f_hn_FadingLeftF : m8f_hn_FadingMarker {States{ Spawn: HNLF A -1; Stop; }}
class m8f_hn_FadingLeftG : m8f_hn_FadingMarker {States{ Spawn: HNLG A -1; Stop; }}

class m8f_hn_FadingRight1 : m8f_hn_FadingMarker {States{ Spawn: HNR1 A -1; Stop; }}
class m8f_hn_FadingRight2 : m8f_hn_FadingMarker {States{ Spawn: HNR2 A -1; Stop; }}
class m8f_hn_FadingRight3 : m8f_hn_FadingMarker {States{ Spawn: HNR3 A -1; Stop; }}
class m8f_hn_FadingRight4 : m8f_hn_FadingMarker {States{ Spawn: HNR4 A -1; Stop; }}
class m8f_hn_FadingRight5 : m8f_hn_FadingMarker {States{ Spawn: HNR5 A -1; Stop; }}
class m8f_hn_FadingRight6 : m8f_hn_FadingMarker {States{ Spawn: HNR6 A -1; Stop; }}
class m8f_hn_FadingRight7 : m8f_hn_FadingMarker {States{ Spawn: HNR7 A -1; Stop; }}
class m8f_hn_FadingRight8 : m8f_hn_FadingMarker {States{ Spawn: HNR8 A -1; Stop; }}
class m8f_hn_FadingRight9 : m8f_hn_FadingMarker {States{ Spawn: HNR9 A -1; Stop; }}
class m8f_hn_FadingRightA : m8f_hn_FadingMarker {States{ Spawn: HNRA A -1; Stop; }}
class m8f_hn_FadingRightB : m8f_hn_FadingMarker {States{ Spawn: HNRB A -1; Stop; }}
class m8f_hn_FadingRightC : m8f_hn_FadingMarker {States{ Spawn: HNRC A -1; Stop; }}
class m8f_hn_FadingRightD : m8f_hn_FadingMarker {States{ Spawn: HNRD A -1; Stop; }}
class m8f_hn_FadingRightE : m8f_hn_FadingMarker {States{ Spawn: HNRE A -1; Stop; }}
class m8f_hn_FadingRightF : m8f_hn_FadingMarker {States{ Spawn: HNRF A -1; Stop; }}
class m8f_hn_FadingRightG : m8f_hn_FadingMarker {States{ Spawn: HNRG A -1; Stop; }}

class m8f_hn_FadingArrow1 : m8f_hn_FadingMarker {States{ Spawn: HNA1 A -1; Stop; }}
class m8f_hn_FadingArrow2 : m8f_hn_FadingMarker {States{ Spawn: HNA2 A -1; Stop; }}
class m8f_hn_FadingArrow3 : m8f_hn_FadingMarker {States{ Spawn: HNA3 A -1; Stop; }}
class m8f_hn_FadingArrow4 : m8f_hn_FadingMarker {States{ Spawn: HNA4 A -1; Stop; }}
class m8f_hn_FadingArrow5 : m8f_hn_FadingMarker {States{ Spawn: HNA5 A -1; Stop; }}
class m8f_hn_FadingArrow6 : m8f_hn_FadingMarker {States{ Spawn: HNA6 A -1; Stop; }}
class m8f_hn_FadingArrow7 : m8f_hn_FadingMarker {States{ Spawn: HNA7 A -1; Stop; }}
class m8f_hn_FadingArrow8 : m8f_hn_FadingMarker {States{ Spawn: HNA8 A -1; Stop; }}
class m8f_hn_FadingArrow9 : m8f_hn_FadingMarker {States{ Spawn: HNA9 A -1; Stop; }}
class m8f_hn_FadingArrowA : m8f_hn_FadingMarker {States{ Spawn: HNAA A -1; Stop; }}
class m8f_hn_FadingArrowB : m8f_hn_FadingMarker {States{ Spawn: HNAB A -1; Stop; }}
class m8f_hn_FadingArrowC : m8f_hn_FadingMarker {States{ Spawn: HNAC A -1; Stop; }}
class m8f_hn_FadingArrowD : m8f_hn_FadingMarker {States{ Spawn: HNAD A -1; Stop; }}
class m8f_hn_FadingArrowE : m8f_hn_FadingMarker {States{ Spawn: HNAE A -1; Stop; }}
class m8f_hn_FadingArrowF : m8f_hn_FadingMarker {States{ Spawn: HNAF A -1; Stop; }}
class m8f_hn_FadingArrowG : m8f_hn_FadingMarker {States{ Spawn: HNAG A -1; Stop; }}

class m8f_hn_FadingCircle : m8f_hn_FadingMarker {States{ Spawn: HNCR A -1; Stop; }}

class hn_StartMarker : MapMarker
{

  override void BeginPlay()
  {
    double mapScale = CVar.GetCVar("m8f_hn_marker_scale", players[consolePlayer]).GetFloat();
    scale.x = mapScale * 0.1;
    scale.y = mapScale * 0.1;
    super.BeginPlay();
  }

  States
    {
    Spawn:
      HNSP A -1;
      Stop;
    }

} // class m8f_hn_QuestPointer_Example
