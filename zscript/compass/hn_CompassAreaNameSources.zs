/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2018-2021
 *
 * This file is part of Hellscape Navigator.
 *
 * Hellscape Navigator is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * Hellscape Navigator is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with Hellscape Navigator.  If not, see <https://www.gnu.org/licenses/>.
 */

class hn_BaseCompassAreaNameSource
{

  play virtual bool IsAutomatic() const
  {
    return true;
  }

  play virtual string GetAreaName(hn_CompassData data) const
  {
    return "";
  }

} // hn_BaseCompassAreaNameSource

class hn_PlayerStartCompassAreaNameSource : hn_BaseCompassAreaNameSource
{

  override string GetAreaName(hn_CompassData data)
  {
    vector3    playerStart;
    int        angle;
    [playerStart, angle]      = Object.G_PickPlayerStart(consolePlayer);
    vector3    playerPos      = players[consolePlayer].mo.pos;
    double     dx             = playerStart.x - playerPos.x;
    double     dy             = playerStart.y - playerPos.y;
    double     dz             = playerStart.z - playerPos.z;
    double     distance       = dx * dx + dy * dy + dz * dz;
    bool       isCloseToStart = (distance < 20000);

    return isCloseToStart ? "Entrance" : "";
  }

} // hn_PlayerStartCompassAreaNameSource

class hn_SignCompassAreaNameSource : hn_BaseCompassAreaNameSource
{

  override bool IsAutomatic() const
  {
    return false;
  }

  override string GetAreaName(hn_CompassData data)
  {
    vector3     playerPos   = players[consolePlayer].mo.pos;
    let         iterator    = ThinkerIterator.Create("m8f_hn_Sign");
    double      minDistance = -1;
    Actor       closestSign = null;
    m8f_hn_Sign sign;

    while (sign = m8f_hn_Sign(iterator.Next()))
    {
      if (sign.areaName.length() == 0) { continue; }

      double distance;
      bool   isInRadius;
      [distance, isInRadius] = hn_DistanceCalculator.calculateDistance( sign.pos
                                                                      , playerPos
                                                                      , sign.areaRadiusSq
                                                                      );

      if (isInRadius && (distance < minDistance || minDistance < 0.0))
      {
        minDistance = distance;
        closestSign = sign;
      }
    }

    int nAreaNameMarkers = data.areaNameMarkers.size();

    for (int i = 0; i < nAreaNameMarkers; ++i)
    {
      let areaNameMarker = data.areaNameMarkers[i];
      if (areaNameMarker == null) { continue; }

      vector3 pos            = areaNameMarker.pos;
      double  areaRadius     = areaNameMarker.health;
      double  areaRadiusSq   = areaRadius * areaRadius;
      double  distance;
      bool    isInRadius;
      [distance, isInRadius] = hn_DistanceCalculator.calculateDistance( pos
                                                                      , playerPos
                                                                      , areaRadiusSq
                                                                      );

      if (isInRadius && (distance < minDistance || minDistance < 0.0))
      {
        minDistance = distance;
        closestSign = data.areaNameMarkers[i];
      }
    }

    if (closestSign)
    {
      m8f_hn_Sign sign = m8f_hn_Sign(closestSign);
      return sign
        ? sign.areaName
        : closestSign.GetTag();
    }

    return "";
  }

} // hn_SignCompassAreaNameSource

class m8f_hn_CalculateDistanceBenchmark : Actor
{
  void RunBenchmark()
  {
    console.printf("calculateDistance benchmark started");

    double radius   = 200;
    double radiusSq = radius * radius;

    int    iterations = 10000000;

    // pos1 and pos2 are in radius
    {
      vector3 pos1 = (0, 0, 0);
      vector3 pos2 = (1, 1, 1);
      for (int i = 0; i < iterations; ++i)
      {
        double distance;
        bool   isInRadius;
        [distance, isInRadius] = hn_DistanceCalculator.calculateDistance(pos1, pos2, radiusSq);
      }
    }

    // x is out of radius
    {
      vector3 pos1 = (0, 0, 0);
      vector3 pos2 = (400, 1, 1);
      for (int i = 0; i < iterations; ++i)
      {
        double distance;
        bool   isInRadius;
        [distance, isInRadius] = hn_DistanceCalculator.calculateDistance(pos1, pos2, radiusSq);
      }
    }

    // y is out of radius
    {
      vector3 pos1 = (0, 0, 0);
      vector3 pos2 = (0, 400, 1);
      for (int i = 0; i < iterations; ++i)
      {
        double distance;
        bool   isInRadius;
        [distance, isInRadius] = hn_DistanceCalculator.calculateDistance(pos1, pos2, radiusSq);
      }
    }

    // z is out of radius
    {
      vector3 pos1 = (0, 0, 0);
      vector3 pos2 = (0, 0, 400);
      for (int i = 0; i < iterations; ++i)
        {
          double distance;
          bool   isInRadius;
          [distance, isInRadius] = hn_DistanceCalculator.calculateDistance(pos1, pos2, radiusSq);
        }
    }

    console.printf("calculateDistance benchmark finished");
  }

  States
    {
    Spawn:
      TNT1 A 0;
      TNT1 A 0 RunBenchmark();
      TNT1 A -1;
    }
}

class hn_ItemCompassAreaNameSource : hn_BaseCompassAreaNameSource
{

  override string GetAreaName(hn_CompassData data)
  {
    vector3 playerPos      = players[consolePlayer].mo.pos;
    double  minDistance    = -1;
    string  closestItem    = "";
    double  itemAreaRadius = 20000.0;
    int     nAreaItems     = data.itemAreaPosX.size();

    for (int i = 0; i < nAreaItems; ++i)
    {
      double dx       = data.itemAreaPosX[i] - playerPos.x;
      double dy       = data.itemAreaPosY[i] - playerPos.y;
      double dz       = data.itemAreaPosZ[i] - playerPos.z;
      double distance = dx * dx + dy * dy + dz * dz;

      if ((distance < minDistance || minDistance < 0.0)
          && distance < itemAreaRadius)
      {
        minDistance = distance;
        closestItem = data.itemAreaNames[i];
      }
    }

    if (closestItem.length())
    {
      return String.Format("%s Area", beautify(closestItem));
    }

    return "";
  }

  string beautify(string name)
  {
    string result = SeparateCamelCase(name);
    result.replace("_", " ");
    return result;
  }

  static string SeparateCamelCase(string source)
  {
    int    sourceLength = source.Length();
    string result       = "";
    string letter1      = source.CharAt(0);
    string letter2;

    for (int i = 1; i < sourceLength; ++i)
    {
      letter2 = source.CharAt(i);
      if (IsSmallLetter(letter1) && IsBigLetter(letter2))
      {
        result.AppendFormat("%s ", letter1);
      }
      else
      {
        result.AppendFormat(letter1);
      }
      letter1 = letter2;
    }
    result.AppendFormat(letter2);

    return result;
  }

  static bool IsSmallLetter(string letter)
  {
    int code = letter.CharCodeAt(0);
    return (97 <= code && code <= 122);
  }

  static bool IsBigLetter(string letter)
  {
    int code = letter.CharCodeAt(0);
    return (65 <= code && code <= 90);
  }

} // hn_ItemCompassAreaNameSource

class hn_SectorCompassAreaNameSource : hn_BaseCompassAreaNameSource
{
  override string GetAreaName(hn_CompassData data)
  {
    PlayerInfo player = players[consolePlayer];
    if (player == null) { return ""; }

    Actor playerActor = player.mo;
    if (playerActor == null) { return ""; }

    Sector currentSector = playerActor.curSector;
    if (currentSector == null) { return ""; }

    bool isSecret = (currentSector.Flags & (Sector.SECF_SECRET | Sector.SECF_WASSECRET));
    if (isSecret)
    {
      int nSecretSectors = data.secretSectors.size();
      int i = 0;
      for (; i < nSecretSectors; ++i)
      {
        if (currentSector == data.secretSectors[i]) { break; }
      }
      return String.Format("Secret #%d", i + 1);
    }

    bool isSky = (currentSector.GetTexture(1) == skyflatnum);
    if (isSky) { return "Outdoors"; }

    bool isExit = hn_Level.isExit(currentSector);
    if (isExit) { return "Exit"; }

    return "";
  }

} // hn_SectorCompassAreaNameSource
