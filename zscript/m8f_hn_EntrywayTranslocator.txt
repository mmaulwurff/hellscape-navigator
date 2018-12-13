class m8f_hn_EntrywayTranslocator : ArtiTeleport
{

  Default
  {
    Tag "Entryway Translocator";
    Inventory.Icon "hneyc0";

    -FLOATBOB;
  }

  States
  {
  Spawn:
    hney b 1;
    loop;
  }

} // m8f_hn_EntrywayTranslocator
