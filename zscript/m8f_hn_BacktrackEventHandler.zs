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

class m8f_hn_BacktrackEventHandler : EventHandler
{

  const _nRecords      = 35 * 3;
  const _crumbLifetime = _nRecords * 2;
  const _crumbFlags    = SPF_FULLBRIGHT;
  const _crumbSize     = 3.0;
  const _crumbColor    = "ff ff ff";
  const _crumbZOffset  = _crumbSize / 2;

  private bool    _isRecording;
  private Vector3 _records[_nRecords];
  private int     _currentRecord;
  private Vector3 _oldPos;
  private m8f_hn_BacktrackSettings _settings;

  override void PlayerEntered(PlayerEvent event)
  {
    int playerNumber = event.playerNumber;
    if (playerNumber != consolePlayer) { return; }

    clearRecords();

    _isRecording = true;
    _settings    = new("m8f_hn_BacktrackSettings");
    _settings.init(players[playerNumber]);
  }

  override void NetworkProcess(ConsoleEvent event)
  {
    if      (event.name == "m8f_hn_backtrack_on" ) { _isRecording = false; }
    else if (event.name == "m8f_hn_backtrack_off") { _isRecording = true; clearRecords(); }
  }

  override void WorldTick()
  {
    if (_isRecording)
    {
      record();
      spawnBreadCrumb();
    }
    else
    {
      read();
    }
  }

  private void clearRecords()
  {
    for (int i = 0; i < _nRecords; ++i)
    {
      _records[i].x = 0;
      _records[i].y = 0;
      _records[i].z = 0;
    }

    _currentRecord = 0;
  }

  private void nextRecord()
  {
    ++_currentRecord;
    if (_currentRecord >= _nRecords)
    {
      _currentRecord = 0;
    }
  }

  private void prevRecord()
  {
    --_currentRecord;
    if (_currentRecord < 0)
    {
      _currentRecord = _nRecords - 1;
    }
  }

  private void record()
  {
    PlayerInfo player      = players[consolePlayer];
    Actor      playerActor = player.mo;

    _records[_currentRecord] = player.mo.Vel;
    nextRecord();
  }

  private void read()
  {
    PlayerInfo player      = players[consolePlayer];
    Actor      playerActor = player.mo;

    player.mo.Vel = -_records[_currentRecord];

    _records[_currentRecord].x = 0;
    _records[_currentRecord].y = 0;
    _records[_currentRecord].z = 0;

    prevRecord();
  }

  private void spawnBreadCrumb()
  {
    if (!_settings.isCrumbsEnabled()) { return; }

    PlayerInfo player = players[consolePlayer];
    if (player == null) { return; }

    Actor playerActor = player.mo;
    if (playerActor == null) { return; }

    if (playerActor.pos == _oldPos) { return; }
    _oldPos = playerActor.pos;

    playerActor.A_SpawnParticle( _crumbColor, _crumbFlags, _crumbLifetime, _crumbSize, 0
                               , 0, 0, _crumbZOffset, 0, 0, 0, 0, 0, 0, 1.0
                               );
  }

} // class m8f_hn_BacktrackEventHandler
