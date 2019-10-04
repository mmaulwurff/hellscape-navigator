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

class m8f_hn_Settings : m8f_hn_SettingsPack
{

  // public: ///////////////////////////////////////////////////////////////////

  double xStart            () { checkInit(); return _xStart            .value(); }
  double yStart            () { checkInit(); return _yStart            .value(); }
  bool   showCompass       () { checkInit(); return _showCompass       .value(); }
  bool   levelName         () { checkInit(); return _levelName         .value(); }
  bool   showGridCoords    () { checkInit(); return _showGridCoords    .value(); }
  bool   showOnAutomap     () { checkInit(); return _showOnAutomap     .value(); }
  bool   showAreaName      () { checkInit(); return _showAreaName      .value(); }
  bool   hideAutoAreaNames () { checkInit(); return _hideAutoAreaNames .value(); }
  bool   showExplored      () { checkInit(); return _showExplored      .value(); }
  bool   showSwitches      () { checkInit(); return _showSwitches      .value(); }

  double compassScale      () { checkInit(); return _compassScale      .value(); }
  double compassDegrees    () { checkInit(); return _compassDegrees    .value(); }
  int    compassStyle      () { checkInit(); return _compassStyle      .value(); }
  bool   textAboveCompass  () { checkInit(); return _textAboveCompass  .value(); }

  bool   showLockAccess    () { checkInit(); return _showLockAccess    .value(); }
  bool   showIntroLevelName() { checkInit(); return _showIntroLevelName.value(); }

  bool   isTextSeparate    () { checkInit(); return _isTextSeparate    .value(); }
  double textX             () { checkInit(); return _textX             .value(); }
  double textY             () { checkInit(); return _textY             .value(); }

  bool   revealExploredMap () { checkInit(); return _revealExploredMap .value(); }
  bool   scannerExploredMap() { checkInit(); return _scannerExploredMap.value(); }
  bool   revealOnStart     () { checkInit(); return _revealOnStart     .value(); }
  bool   scannerOnStart    () { checkInit(); return _scannerOnStart    .value(); }

  int    nTranslocator     () { checkInit(); return _nTranslocator     .value(); }
  int    nTranslocatorExp  () { checkInit(); return _nTranslocatorExp  .value(); }

  int    nTunneling        () { checkInit(); return _nTunneling        .value(); }
  int    nTunnelingExp     () { checkInit(); return _nTunnelingExp     .value(); }

  bool   showSpeed         () { checkInit(); return _showSpeed         .value(); }
  double speedometerScale  () { checkInit(); return _speedometerScale  .value(); }
  double speedometerX      () { checkInit(); return _speedometerX      .value(); }
  double speedometerY      () { checkInit(); return _speedometerY      .value(); }

  // private: //////////////////////////////////////////////////////////////////

  private
  void checkInit()
  {
    if (_isInitialized) { return; }
    clear();
    _isInitialized = true;

    push(_xStart             = new("m8f_hn_DoubleSetting").init("m8f_hn_compass_x"              , _player));
    push(_yStart             = new("m8f_hn_DoubleSetting").init("m8f_hn_compass_y"              , _player));
    push(_showCompass        = new("m8f_hn_BoolSetting"  ).init("m8f_hn_compass_show"           , _player));
    push(_levelName          = new("m8f_hn_BoolSetting"  ).init("m8f_hn_compass_level_name"     , _player));
    push(_showGridCoords     = new("m8f_hn_BoolSetting"  ).init("m8f_hn_show_grid_coords"       , _player));
    push(_showOnAutomap      = new("m8f_hn_BoolSetting"  ).init("m8f_hn_compass_automap"        , _player));
    push(_showAreaName       = new("m8f_hn_BoolSetting"  ).init("m8f_hn_show_area"              , _player));
    push(_hideAutoAreaNames  = new("m8f_hn_BoolSetting"  ).init("m8f_hn_hide_auto_names"        , _player));
    push(_showExplored       = new("m8f_hn_BoolSetting"  ).init("m8f_hn_show_explored"          , _player));
    push(_showSwitches       = new("m8f_hn_BoolSetting"  ).init("m8f_hn_show_switches"          , _player));

    push(_compassScale       = new("m8f_hn_DoubleSetting").init("m8f_hn_compass_scale"          , _player));
    push(_compassDegrees     = new("m8f_hn_DoubleSetting").init("m8f_hn_compass_degrees"        , _player));
    push(_compassStyle       = new("m8f_hn_IntSetting"   ).init("m8f_hn_compass_style"          , _player));
    push(_textAboveCompass   = new("m8f_hn_BoolSetting"  ).init("m8f_hn_compass_under"          , _player));

    push(_showLockAccess     = new("m8f_hn_BoolSetting"  ).init("m8f_hn_show_access"            , _player));
    push(_showIntroLevelName = new("m8f_hn_BoolSetting"  ).init("m8f_hn_show_level_name"        , _player));

    push(_isTextSeparate     = new("m8f_hn_BoolSetting"  ).init("m8f_hn_text_separate"          , _player));
    push(_textX              = new("m8f_hn_DoubleSetting").init("m8f_hn_text_x"                 , _player));
    push(_textY              = new("m8f_hn_DoubleSetting").init("m8f_hn_text_y"                 , _player));

    push(_revealExploredMap  = new("m8f_hn_BoolSetting"  ).init("m8f_hn_reveal_when_explored"   , _player));
    push(_scannerExploredMap = new("m8f_hn_BoolSetting"  ).init("m8f_hn_reveal_scanner"         , _player));
    push(_revealOnStart      = new("m8f_hn_BoolSetting"  ).init("m8f_hn_reveal_on_start"        , _player));
    push(_scannerOnStart     = new("m8f_hn_BoolSetting"  ).init("m8f_hn_scanner_start"          , _player));

    push(_nTranslocator      = new("m8f_hn_IntSetting"   ).init("m8f_hn_n_translocator"         , _player));
    push(_nTranslocatorExp   = new("m8f_hn_IntSetting"   ).init("m8f_hn_n_translocator_explored", _player));

    push(_nTunneling         = new("m8f_hn_IntSetting"   ).init("m8f_hn_n_tunneling"            , _player));
    push(_nTunnelingExp      = new("m8f_hn_IntSetting"   ).init("m8f_hn_n_tunneling_explored"   , _player));

    push(_showSpeed          = new("m8f_hn_BoolSetting"  ).init("m8f_hn_show_speed"             , _player));
    push(_speedometerScale   = new("m8f_hn_DoubleSetting").init("m8f_hn_speedometer_scale"      , _player));
    push(_speedometerX       = new("m8f_hn_DoubleSetting").init("m8f_hn_speedometer_x"          , _player));
    push(_speedometerY       = new("m8f_hn_DoubleSetting").init("m8f_hn_speedometer_y"          , _player));
  }

  // private: //////////////////////////////////////////////////////////////////

  private m8f_hn_DoubleSetting _xStart;
  private m8f_hn_DoubleSetting _yStart;
  private m8f_hn_BoolSetting   _showCompass;
  private m8f_hn_BoolSetting   _levelName;
  private m8f_hn_BoolSetting   _showGridCoords;
  private m8f_hn_BoolSetting   _showOnAutomap;
  private m8f_hn_BoolSetting   _showAreaName;
  private m8f_hn_BoolSetting   _hideAutoAreaNames;
  private m8f_hn_BoolSetting   _showExplored;
  private m8f_hn_BoolSetting   _showSwitches;

  private m8f_hn_DoubleSetting _compassScale;
  private m8f_hn_DoubleSetting _compassDegrees;
  private m8f_hn_IntSetting    _compassStyle;
  private m8f_hn_BoolSetting   _textAboveCompass;

  private m8f_hn_BoolSetting   _showLockAccess;
  private m8f_hn_BoolSetting   _showIntroLevelName;

  private m8f_hn_BoolSetting   _isTextSeparate;
  private m8f_hn_DoubleSetting _textX;
  private m8f_hn_DoubleSetting _textY;

  private m8f_hn_BoolSetting   _revealExploredMap;
  private m8f_hn_BoolSetting   _scannerExploredMap;
  private m8f_hn_BoolSetting   _revealOnStart;
  private m8f_hn_BoolSetting   _scannerOnStart;

  private m8f_hn_IntSetting    _nTranslocator;
  private m8f_hn_IntSetting    _nTranslocatorExp;

  private m8f_hn_IntSetting    _nTunneling;
  private m8f_hn_IntSetting    _nTunnelingExp;

  private m8f_hn_BoolSetting   _showSpeed;
  private m8f_hn_DoubleSetting _speedometerScale;
  private m8f_hn_DoubleSetting _speedometerX;
  private m8f_hn_DoubleSetting _speedometerY;

} // class m8f_hn_Settings
