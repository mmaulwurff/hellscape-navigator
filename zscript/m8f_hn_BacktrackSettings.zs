
class m8f_hn_BacktrackSettings
{

  bool isCrumbsEnabled;

  void read(PlayerInfo player)
  {
    isCrumbsEnabled = CVar.GetCVar("m8f_hn_crumbs_enabled" , player).GetInt();
  }

  m8f_hn_BacktrackSettings init(PlayerInfo player)
  {
    read(player);
    return self;
  }

} // class m8f_hn_BacktrackSettings
