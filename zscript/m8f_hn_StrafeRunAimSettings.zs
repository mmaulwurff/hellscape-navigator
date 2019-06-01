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

class m8f_hn_StrafeRunAimSettings : m8f_hn_SettingsPack
{

  // public: ///////////////////////////////////////////////////////////////////

  bool isStrafeRunAimEnabled() { checkInit(); return _isStrafeRunAimEnabled.value(); }

  // private: //////////////////////////////////////////////////////////////////

  private
  void checkInit()
  {
    if (_isInitialized) { return; }

    clear();

    push(_isStrafeRunAimEnabled = new("m8f_hn_BoolSetting").init("m8f_hn_sr40_aim_enabled", _player));

    _isInitialized = true;
  }

  // private: //////////////////////////////////////////////////////////////////

  private m8f_hn_BoolSetting _isStrafeRunAimEnabled;

} // class m8f_hn_StrafeRunSettings
