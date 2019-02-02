
class m8f_hn_MapTunerSettings
{

  bool isExitHighlightEnabled;
  bool shootableExitSwitches;
  bool shootableSwitches;

  void read(PlayerInfo player)
  {
    isExitHighlightEnabled = CVar.GetCVar("m8f_hn_exit_highlight_enabled"  , player).GetInt();
    shootableExitSwitches  = CVar.GetCVar("m8f_hn_shootable_exit_switches" , player).GetInt();
    shootableSwitches      = CVar.GetCVar("m8f_hn_shootable_switches"      , player).GetInt();
  }

  m8f_hn_MapTunerSettings init(PlayerInfo player)
  {
    read(player);
    return self;
  }

} // class m8f_hn_MapTunerSettings
