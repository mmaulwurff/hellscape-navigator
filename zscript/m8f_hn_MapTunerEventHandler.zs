
class m8f_hn_MapTunerEventHandler : EventHandler
{

  override void WorldTick()
  {
    if (!playerInGame[consolePlayer]) { return; }

    int nExitSectors = _exitSectors.size();
    if (nExitSectors == 0) { return; }

    for (int i = 0; i < nExitSectors; ++i)
    {
      level.sectors[_exitSectors[i]].lightLevel += _step;
    }

    int lightLevel = level.sectors[_exitSectors[0]].lightLevel;
    if (lightLevel <= startExitLightLevel || lightLevel >= 255) { _step = -_step; }
  }

  override void PlayerEntered(PlayerEvent event)
  {
    int playerNumber = event.playerNumber;
    _settings = new("m8f_hn_MapTunerSettings").init(players[playerNumber]);

    maybeMakeSwitchesShootable();
    maybeHighlightExitSector();

    _step = 5;
  }

  // private: //////////////////////////////////////////////////////////////////

  private void maybeMakeSwitchesShootable()
  {
    if (!_settings.shootableExitSwitches && !_settings.shootableSwitches) { return; }

    int nLines = level.Lines.size();
    for (int i = 0; i < nLines; ++i)
    {
      Line l = level.Lines[i];

      if (l.special == 243 || l.special == 244 || l.special == 75)
      {
        if (_settings.shootableExitSwitches)
        {
          l.activation |= SPAC_Impact;
        }
        continue;
      }

      if (_settings.shootableSwitches && (l.activation & SPAC_Use))
      {
        l.activation |= SPAC_Impact;
      }
    }
  }

  private void maybeHighlightExitSector()
  {
    if (!_settings.isExitHighlightEnabled) { return; }

    int nSectors = level.sectors.size();

    for (int i = 0; i < nSectors; ++i)
    {
      Sector s      = level.sectors[i];
      bool   isExit = m8f_hn_Utils.isExit(s);

      if (isExit)
      {
        _exitSectors.push(i);
        level.sectors[i].lightLevel = startExitLightLevel;
        level.sectors[i].SetColor("ff 00 00");
      }
    }
  }

  // private: //////////////////////////////////////////////////////////////////

  private Array<int> _exitSectors;
  private int        _step;
  private m8f_hn_MapTunerSettings _settings;

  const startExitLightLevel = 150;

} // m8f_hn_MapTunerEventHandler
