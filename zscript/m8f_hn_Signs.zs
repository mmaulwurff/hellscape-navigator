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

class m8f_hn_Sign : Actor
{

  // public: ///////////////////////////////////////////////////////////////////

  Default
  {
    Health 30;
    Height 10;
    Radius  3;
    Tag    "Sign";

    +NOBLOOD
    +NOTONAUTOMAP
    +DONTTHRUST
    +WALLSPRITE
  }

  // public: ///////////////////////////////////////////////////////////////////

  m8f_hn_SignMarker marker;
  string areaName;
  double areaRadiusSq;
  double mapMarkerScale;
  int    id;

  // private: //////////////////////////////////////////////////////////////////

  private string note;
  private int    spawnTime;

  // public: ///////////////////////////////////////////////////////////////////

  override
  void BeginPlay()
  {
    string line1 = CVar.GetCVar("m8f_hn_sign_note1").GetString();
    string line2 = CVar.GetCVar("m8f_hn_sign_note2").GetString();
    string line3 = CVar.GetCVar("m8f_hn_sign_note3").GetString();

    note = line1;
    if (line2.Length() != 0) { note.AppendFormat("\n%s", line2); }
    if (line3.Length() != 0) { note.AppendFormat("\n%s", line3); }

    spawnTime = level.time;

    bool shootable = CVar.GetCVar("m8f_hn_sign_shootable").GetInt();
    bSHOOTABLE = shootable;

    CVar areaNameCVar = CVar.GetCVar("m8f_hn_area_name");
    areaName          = areaNameCVar.GetString();
    areaNameCVar.setString("");

    double areaRadius = CVar.GetCVar("m8f_hn_area_radius").GetFloat();
    areaRadiusSq      = areaRadius * areaRadius;

    mapMarkerScale = Cvar.GetCVar("m8f_hn_sign_map_scale").GetFloat();
    marker = null;

    id = 0;

    A_SetAngle(players[consolePlayer].mo.angle);
  }

  override
  bool Used(Actor user)
  {
    string text    = note;
    int    sec     = Thinker.Tics2Seconds(spawnTime);
    bool   addTime = CVar.GetCVar("m8f_hn_sign_add_time").GetInt();
    if (addTime)
      {
        text.AppendFormat("\n\n        %02d:%02d:%02d",
                          sec / 3600, (sec % 3600) / 60, sec % 60);
      }
    user.A_Print(text);
    return true;
  }

  override
  void Die(Actor source, Actor inflictor, int dmgflags)
  {
    if (marker != null) { marker.Destroy(); }
    super.Die(source, inflictor, dmgflags);

    if (id != 0)
    {
      let eventHandler = m8f_hn_EventHandler(EventHandler.Find("m8f_hn_EventHandler"));
      eventHandler.RemovePointer(id);
    }
  }

} // m8f_hn_Sign

class m8f_hn_WoodenSign : m8f_hn_Sign
{

  States
  {
    Spawn:
      HNWS B -1;
      Stop;
  }

  override
  void BeginPlay()
  {
    super.BeginPlay();
    marker = m8f_hn_SignMarker(Spawn("m8f_hn_WoodenSignMarker", pos));
    marker.init(mapMarkerScale, self);

    bool addToCompass = CVar.GetCVar("m8f_hn_sign_with_pointer").GetInt();
    if (addToCompass)
    {
      let eventHandler = m8f_hn_EventHandler(EventHandler.Find("m8f_hn_EventHandler"));
      id = eventHandler.AddPointer(pos.x, pos.y, m8f_hn_Pointer.POINTER_RED);
    }
  }

} // class m8f_hn_WoodenSign

class m8f_hn_TransparentSign : m8f_hn_Sign
{
  Default
  {
    FloatBobStrength 0.3;

    +NOGRAVITY
    +FLOAT
    +FLOATBOB
  }

  States
  {
    Spawn:
      HNTS B 15
      {
        A_SpawnParticle( "88BBFF"
                       , SPF_FULLBRIGHT | SPF_RELATIVE
                       , 30
                       ,  8
                       ,  0
                       ,  0
                       , 13
                       , 21 + GetBobOffset()
                       , velz    : -0.5
                       , sizestep: -0.05
                       );
        A_SpawnParticle( "88BBFF"
                       , SPF_FULLBRIGHT | SPF_RELATIVE
                       ,  30
                       ,   8
                       ,   0
                       ,   0
                       , -13
                       , 21 + GetBobOffset()
                       , velz    : -0.5
                       , sizestep: -0.05
                       );
      }
      Loop;
  }

  override
  void BeginPlay()
  {
    super.BeginPlay();
    marker = m8f_hn_SignMarker(Spawn("m8f_hn_TransparentSignMarker", pos));
    marker.init(mapMarkerScale, self);

    bool addToCompass = CVar.GetCVar("m8f_hn_sign_with_pointer").GetInt();
    if (addToCompass)
    {
      let eventHandler = m8f_hn_EventHandler(EventHandler.Find("m8f_hn_EventHandler"));
      id = eventHandler.AddPointer(pos.x, pos.y, m8f_hn_Pointer.POINTER_WHITE);
    }
  }

} // class m8f_hn_TransparentSign

class m8f_hn_MetalSign : m8f_hn_Sign
{

  States
  {
    Spawn:
      HNMS B -1;
      Stop;
  }

  override
  void BeginPlay()
  {
    super.BeginPlay();
    marker = m8f_hn_SignMarker(Spawn("m8f_hn_MetalSignMarker", pos));
    marker.init(mapMarkerScale, self);

    bool addToCompass = CVar.GetCVar("m8f_hn_sign_with_pointer").GetInt();
    if (addToCompass)
    {
      let eventHandler = m8f_hn_EventHandler(EventHandler.Find("m8f_hn_EventHandler"));
      id = eventHandler.AddPointer(pos.x, pos.y, m8f_hn_Pointer.POINTER_BLUE);
    }
  }

} // class m8f_hn_MetalSign

class m8f_hn_SignMarker : MapMarker
{

  // public: ///////////////////////////////////////////////////////////////////

  Default
  {
    XScale 0.2;
    YScale 0.2;
  }

  void init(double mapScale, m8f_hn_Sign sign)
  {
    scale.x *= mapScale;
    scale.y *= mapScale;

    _sign = sign;
  }

  // public: ///////////////////////////////////////////////////////////////////

  override
  void Tick()
  {
    if (_sign) { SetOrigin(_sign.pos, true); }
    super.Tick();
  }

  // private: //////////////////////////////////////////////////////////////////

  private m8f_hn_Sign _sign;

} // m8f_hn_SignMarker


class m8f_hn_WoodenSignMarker : m8f_hn_SignMarker
{

  States
  {
    Spawn:
      HNWS M -1;
      Stop;
  }

} // m8f_hn_WoodenSignMarker

class m8f_hn_TransparentSignMarker : m8f_hn_SignMarker
{

  States
  {
    Spawn:
      HNTS M -1;
      Stop;
  }

} // m8f_hn_TransparentSignMarker

class m8f_hn_MetalSignMarker : m8f_hn_SignMarker
{

  States
  {
    Spawn:
      HNMS M -1;
      Stop;
  }

} // m8f_hn_MetalSignMarker
