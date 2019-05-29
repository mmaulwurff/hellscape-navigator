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

class m8f_hn_Settings
{

  double xStart;
  double yStart;
  bool   showCompass;
  bool   levelName;
  bool   showGridCoords;
  bool   showOnAutomap;
  bool   showAreaName;
  bool   hideAutoAreaNames;
  bool   showExplored;
  bool   showSwitches;

  double compassScale;
  int    compassStyle;
  bool   textAboveCompass;

  bool   showLockAccess;
  bool   showIntroLevelName;

  bool   isTextSeparate;
  double textX;
  double textY;

  bool   revealExploredMap;
  bool   scannerExploredMap;
  bool   revealOnStart;
  bool   scannerOnStart;

  int    nTranslocator;
  int    nTranslocatorExp;

  int    nTunneling;
  int    nTunnelingExp;

  bool   showSpeed;
  double speedometerScale;
  double speedometerX;
  double speedometerY;

  void read(PlayerInfo player)
  {
    xStart             = CVar.GetCVar("m8f_hn_compass_x"          , player).GetFloat();
    yStart             = CVar.GetCVar("m8f_hn_compass_y"          , player).GetFloat();
    showCompass        = CVar.GetCVar("m8f_hn_compass_show"       , player).GetInt();
    levelName          = CVar.GetCVar("m8f_hn_compass_level_name" , player).GetInt();
    showGridCoords     = CVar.GetCVar("m8f_hn_show_grid_coords"   , player).GetInt();
    showOnAutomap      = CVar.GetCVar("m8f_hn_compass_automap"    , player).GetInt();
    showAreaName       = CVar.GetCVar("m8f_hn_show_area"          , player).GetInt();
    hideAutoAreaNames  = CVar.GetCVar("m8f_hn_hide_auto_names"    , player).GetInt();
    showExplored       = CVar.GetCVar("m8f_hn_show_explored"      , player).GetInt();
    showSwitches       = CVar.GetCVar("m8f_hn_show_switches"      , player).GetInt();

    compassScale       = CVar.GetCVar("m8f_hn_compass_scale"      , player).GetFloat();
    compassStyle       = CVar.GetCVar("m8f_hn_compass_style"      , player).GetInt();
    textAboveCompass   = CVar.GetCVar("m8f_hn_compass_under"      , player).GetInt();

    showLockAccess     = CVar.GetCVar("m8f_hn_show_access"        , player).GetInt();
    showIntroLevelName = CVar.GetCVar("m8f_hn_show_level_name"    , player).GetInt();

    isTextSeparate     = CVar.GetCVar("m8f_hn_text_separate"      , player).GetInt();
    textX              = CVar.GetCVar("m8f_hn_text_x"             , player).GetFloat();
    textY              = CVar.GetCVar("m8f_hn_text_y"             , player).GetFloat();

    revealExploredMap  = CVar.GetCVar("m8f_hn_reveal_when_explored", player).GetInt();
    scannerExploredMap = CVar.GetCVar("m8f_hn_reveal_scanner"      , player).GetInt();

    revealOnStart      = CVar.GetCVar("m8f_hn_reveal_on_start"     , player).GetInt();
    scannerOnStart     = CVar.GetCVar("m8f_hn_scanner_start"       , player).GetInt();

    nTranslocator      = CVar.GetCVar("m8f_hn_n_translocator"      , player).GetInt();
    nTranslocatorExp   = CVar.GetCVar("m8f_hn_n_translocator_explored", player).GetInt();

    nTunneling         = CVar.GetCVar("m8f_hn_n_tunneling"         , player).GetInt();
    nTunnelingExp      = CVar.GetCVar("m8f_hn_n_tunneling_explored", player).GetInt();

    showSpeed          = CVar.GetCVar("m8f_hn_show_speed"          , player).GetInt();
    speedometerScale   = CVar.GetCVar("m8f_hn_speedometer_scale"   , player).GetFloat();
    speedometerX       = CVar.GetCVar("m8f_hn_speedometer_x"       , player).GetFloat();
    speedometerY       = CVar.GetCVar("m8f_hn_speedometer_y"       , player).GetFloat();
  }

  m8f_hn_Settings init(PlayerInfo player)
  {
    read(player);
    return self;
  }

} // class m8f_hn_Settings
