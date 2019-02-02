
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
    _settings    = new("m8f_hn_BacktrackSettings").init(players[playerNumber]);
  }

  override void NetworkProcess(ConsoleEvent event)
  {
    if      (event.name == "m8f_hn_backtrack_on" ) { _isRecording = false; }
    else if (event.name == "m8f_hn_backtrack_off") { _isRecording = true; clearRecords(); }
  }

  override void WorldTick()
  {
    maybeRereadSettings();

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
    if (!_settings.isCrumbsEnabled) { return; }

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

  private void maybeRereadSettings()
  {
    PlayerInfo player = players[consolePlayer];
    int optionsUpdatePeriod = CVar.GetCVar("m8f_hn_update_period", player).GetInt();

    if (optionsUpdatePeriod == 0) { _settings.read(player); }
    else if (optionsUpdatePeriod != -1
             && (level.time % optionsUpdatePeriod) == 0)
    {
      _settings.read(player);
    }
  }

} // class m8f_hn_BacktrackEventHandler
