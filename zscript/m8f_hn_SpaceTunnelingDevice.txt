
class m8f_hn_SpaceTunnelingDevice : Inventory
{

  Default
  {
    Inventory.Icon "hnstc0";
    Inventory.DefMaxAmount;
    Tag "Space TunnelingDevice";

    +INVENTORY.INVBAR
  }

  override bool Use(bool pickup)
  {
    Owner.GiveInventory("m8f_hn_SpaceTunnelingDevicePowerup", 1);
    return true;
  }

  States
  {
    Spawn:
      hnst b 1;
      loop;
  }

} // m8f_hn_SpaceTunnelingDevice

class m8f_hn_SpaceTunnelingDevicePowerup : Powerup
{

  Default
  {
    Powerup.Duration 105;
  }

  override void InitEffect() {}

  override void DoEffect()
  {
    if (EffectTics % 35 == 0)
    {
      console.printf("Tunnel remains for %d...", EffectTics / 35);
    }
    PlayerInfo p = owner.player;
    p.cheats |= (CF_NOCLIP | CF_NOCLIP2);
  }

  override void EndEffect()
  {
    if (!owner) { return; }
    PlayerInfo p = owner.player;
    p.cheats &= ~(CF_NOCLIP | CF_NOCLIP2);
  }

} // m8f_hn_SpaceTunnelingDevicePowerup
