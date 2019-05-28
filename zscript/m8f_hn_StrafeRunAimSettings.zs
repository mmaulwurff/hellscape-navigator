
class m8f_hn_StrafeRunAimSettings
{

  bool isStrafeRunAimEnabled;

  void read(PlayerInfo player)
  {
    isStrafeRunAimEnabled = CVar.GetCVar("m8f_hn_sr40_aim_enabled" , player).GetInt();
  }

  m8f_hn_StrafeRunAimSettings init(PlayerInfo player)
  {
    read(player);
    return self;
  }

} // class m8f_hn_StrafeRunSettings
