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

class m8f_hn_Settings
{

  static
  m8f_hn_Settings from()
  {
    let result = new("m8f_hn_Settings");

    result._xStart             = hn_Cvar.from("m8f_hn_compass_x");
    result._yStart             = hn_Cvar.from("m8f_hn_compass_y");
    result._showCompass        = hn_Cvar.from("m8f_hn_compass_show");
    result._levelName          = hn_Cvar.from("m8f_hn_compass_level_name");
    result._showGridCoords     = hn_Cvar.from("m8f_hn_show_grid_coords");
    result._showOnAutomap      = hn_Cvar.from("m8f_hn_compass_automap");
    result._showAreaName       = hn_Cvar.from("m8f_hn_show_area");
    result._hideAutoAreaNames  = hn_Cvar.from("m8f_hn_hide_auto_names");
    result._showExplored       = hn_Cvar.from("m8f_hn_show_explored");
    result._showSwitches       = hn_Cvar.from("m8f_hn_show_switches");

    result._compassScale       = hn_Cvar.from("m8f_hn_compass_scale");
    result._compassDegrees     = hn_Cvar.from("m8f_hn_compass_degrees");
    result._compassStyle       = hn_Cvar.from("m8f_hn_compass_style");
    result._textAboveCompass   = hn_Cvar.from("m8f_hn_compass_under");

    result._showLockAccess     = hn_Cvar.from("m8f_hn_show_access");
    result._showIntroLevelName = hn_Cvar.from("m8f_hn_show_level_name");

    result._isTextSeparate     = hn_Cvar.from("m8f_hn_text_separate");
    result._textX              = hn_Cvar.from("m8f_hn_text_x");
    result._textY              = hn_Cvar.from("m8f_hn_text_y");

    result._revealExploredMap  = hn_Cvar.from("m8f_hn_reveal_when_explored");
    result._scannerExploredMap = hn_Cvar.from("m8f_hn_reveal_scanner");
    result._revealOnStart      = hn_Cvar.from("m8f_hn_reveal_on_start");
    result._scannerOnStart     = hn_Cvar.from("m8f_hn_scanner_start");

    result._nTranslocator      = hn_Cvar.from("m8f_hn_n_translocator");
    result._nTranslocatorExp   = hn_Cvar.from("m8f_hn_n_translocator_explored");

    result._nTunneling         = hn_Cvar.from("m8f_hn_n_tunneling");
    result._nTunnelingExp      = hn_Cvar.from("m8f_hn_n_tunneling_explored");

    result._showSpeed          = hn_Cvar.from("m8f_hn_show_speed");
    result._speedometerScale   = hn_Cvar.from("m8f_hn_speedometer_scale");
    result._speedometerX       = hn_Cvar.from("m8f_hn_speedometer_x");
    result._speedometerY       = hn_Cvar.from("m8f_hn_speedometer_y");

    return result;
  }

  double xStart            () { return _xStart.getDouble(); }
  double yStart            () { return _yStart.getDouble(); }
  bool   showCompass       () { return _showCompass.getBool(); }
  bool   levelName         () { return _levelName.getBool(); }
  bool   showGridCoords    () { return _showGridCoords.getBool(); }
  bool   showOnAutomap     () { return _showOnAutomap.getBool(); }
  bool   showAreaName      () { return _showAreaName.getBool(); }
  bool   hideAutoAreaNames () { return _hideAutoAreaNames.getBool(); }
  bool   showExplored      () { return _showExplored.getBool(); }
  bool   showSwitches      () { return _showSwitches.getBool(); }

  double compassScale      () { return _compassScale.getDouble(); }
  double compassDegrees    () { return _compassDegrees.getDouble(); }
  int    compassStyle      () { return _compassStyle.getInt(); }
  bool   textAboveCompass  () { return _textAboveCompass.getBool(); }

  bool   showLockAccess    () { return _showLockAccess.getBool(); }
  bool   showIntroLevelName() { return _showIntroLevelName.getBool(); }

  bool   isTextSeparate    () { return _isTextSeparate.getBool(); }
  double textX             () { return _textX.getDouble(); }
  double textY             () { return _textY.getDouble(); }

  bool   revealExploredMap () { return _revealExploredMap.getBool(); }
  bool   scannerExploredMap() { return _scannerExploredMap.getBool(); }
  bool   revealOnStart     () { return _revealOnStart.getBool(); }
  bool   scannerOnStart    () { return _scannerOnStart.getBool(); }

  int    nTranslocator     () { return _nTranslocator.getInt(); }
  int    nTranslocatorExp  () { return _nTranslocatorExp.getInt(); }

  int    nTunneling        () { return _nTunneling.getInt(); }
  int    nTunnelingExp     () { return _nTunnelingExp.getInt(); }

  bool   showSpeed         () { return _showSpeed.getBool(); }
  double speedometerScale  () { return _speedometerScale.getDouble(); }
  double speedometerX      () { return _speedometerX.getDouble(); }
  double speedometerY      () { return _speedometerY.getDouble(); }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private hn_Cvar _xStart;
  private hn_Cvar _yStart;
  private hn_Cvar _showCompass;
  private hn_Cvar _levelName;
  private hn_Cvar _showGridCoords;
  private hn_Cvar _showOnAutomap;
  private hn_Cvar _showAreaName;
  private hn_Cvar _hideAutoAreaNames;
  private hn_Cvar _showExplored;
  private hn_Cvar _showSwitches;

  private hn_Cvar _compassScale;
  private hn_Cvar _compassDegrees;
  private hn_Cvar _compassStyle;
  private hn_Cvar _textAboveCompass;

  private hn_Cvar _showLockAccess;
  private hn_Cvar _showIntroLevelName;

  private hn_Cvar _isTextSeparate;
  private hn_Cvar _textX;
  private hn_Cvar _textY;

  private hn_Cvar _revealExploredMap;
  private hn_Cvar _scannerExploredMap;
  private hn_Cvar _revealOnStart;
  private hn_Cvar _scannerOnStart;

  private hn_Cvar _nTranslocator;
  private hn_Cvar _nTranslocatorExp;

  private hn_Cvar _nTunneling;
  private hn_Cvar _nTunnelingExp;

  private hn_Cvar _showSpeed;
  private hn_Cvar _speedometerScale;
  private hn_Cvar _speedometerX;
  private hn_Cvar _speedometerY;

} // class m8f_hn_Settings
