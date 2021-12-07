/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2021
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

/** EventHandler with added initialization when player enters the game.
 *
 * @attention if derived event handler needs playerEntered method, make sure to call
 * super.PlayerEntered there.
 */
class hn_InitializedEventHandler : EventHandler
{

// EventHandler implementation /////////////////////////////////////////////////////////////////////

  override
  void playerEntered(PlayerEvent event)
  {
    if (event.playerNumber != consolePlayer) return;
    if (players[consolePlayer].mo == NULL) return;
    if (hn_Level.isTitlemap()) return;

    initialize();
  }

// public: /////////////////////////////////////////////////////////////////////////////////////////

  bool isInitialized() const
  {
    return _isInitialized;
  }

// protected: //////////////////////////////////////////////////////////////////////////////////////

  virtual protected
  void initialize()
  {
    _isInitialized = true;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private bool _isInitialized;

} // class hn_InitializedEventHandler
