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

class m8f_hn_EventHandler : EventHandler
{
  // public: // override section ///////////////////////////////////////////////

  override
  void OnRegister()
  {
    _areaNameSources.push(new("m8f_hn_SignAreaNameSource"   ));
    _areaNameSources.push(new("m8f_hn_PlayerStartNameSource"));
    _areaNameSources.push(new("m8f_hn_ItemAreaNameSource"   ));
    _areaNameSources.push(new("m8f_hn_SectorAreaNameSource" ));
    _areaNameSources.push(new("m8f_hn_BaseAreaNameSource"   ));

    _renderUpdatePeriod = 20;
    _renderCounter      =  0;
    _areaName           = "";

    _isWorldLoaded      = false;

    _currentLockAlphaPercent = 0;
    _targetLockAlphaPercent  = 0;

    _isMapRevealerOnMap = false;
    _mapNameAlpha       = 1.5;
  }

  override
  void PlayerEntered(PlayerEvent event)
  {
    if (event.playerNumber != consolePlayer) { return; }

    Actor playerActor = players[event.playerNumber].mo;
    if (playerActor == null) { return; }

    _data       = new("m8f_hn_Data").init();
    _isTitlemap = CheckTitlemap();
    _settings   = new("m8f_hn_Settings");
    _settings.init(players[event.playerNumber]);

    _progress    = 0;
    _oldProgress = 0;
    _initialFoundSectorsCount = 0;

    if (_settings.revealOnStart())
    {
      playerActor.GiveInventory("MapRevealer", 1);

      if (_settings.scannerOnStart())
      {
        playerActor.GiveInventory("m8f_hn_Scanner", 1);
      }
    }

    if (_settings.nTranslocator())
    {
      playerActor.GiveInventory("m8f_hn_EntrywayTranslocator", _settings.nTranslocator());
    }

    if (_settings.nTunneling())
    {
      playerActor.GiveInventory("m8f_hn_SpaceTunnelingDevice", _settings.nTunneling());
    }
  }

  override
  void WorldTick()
  {
    if (level.time == 1)
      {
        _isWorldLoaded            = true;
        _initialFoundSectorsCount = countFoundSectors();
      }

    int  updatePeriod = 35;
    bool isSkip       = (level.time % updatePeriod);

    if (!isSkip) { return; }

    int nSectors = level.sectors.size() - _initialFoundSectorsCount;
    if (nSectors == 0)
    {
      _progress = 10;
      return;
    }

    int        nFoundSectors = countFoundSectors()  - _initialFoundSectorsCount;
    PlayerInfo player        = players[consolePlayer];

    // leave place for unaccessible sectors
    _progress = nFoundSectors * 11 / nSectors;
    if (_progress > 10) { _progress = 10; }

    if (_oldProgress != _progress
        && _progress == 10)
    {
      OnMapExplored(player);
    }

    _oldProgress = _progress;
  }

  override
  void WorldThingSpawned(WorldEvent e)
  {
    if (e == null) { return; }

    Actor item = e.thing;
    if (item == null) { return; }

    // detect and store area name markers
    string spawnedClassName = item.GetClassName();
    bool   isAreaNameMarker = contains(spawnedClassName, "hn_AreaNameMarker");
    if (isAreaNameMarker)
    {
      _data.areaNameMarkers.push(item);
    }

    // detect and store quest markers
    bool isQuestPointer = contains(spawnedClassName, "hn_QuestPointer");
    if (isQuestPointer)
    {
      _data.questPointers.push(item);
    }

    if (item is "MapRevealer")
    {
      _isMapRevealerOnMap = true;
    }

    if (_isWorldLoaded) { return; }

    Inventory inv = Inventory(item);
    if (inv && inv.owner) { return; }

    int nAreaItems = _data.areaItems.size();

    for (int i = 0; i < nAreaItems; ++i)
    {
      if (!(item is _data.areaItems[i])) { continue; }

      _data.itemAreaPosX.push(int(item.pos.x));
      _data.itemAreaPosY.push(int(item.pos.y));
      _data.itemAreaPosZ.push(int(item.pos.z));
      _data.itemAreaNames.push(item.GetTag());
    }
  }

  override
  void NetworkProcess(ConsoleEvent event)
  {
    if (event.name == "m8f_hn_remove_signs") { RemoveSigns(); }
    if (event.name == "m8f_hn_throw_sign"  ) { ThrowSign(); }
  }

  override
  void RenderOverlay(RenderEvent e)
  {
    if (_isTitlemap) { return; }
    if (automapActive && !_settings.showOnAutomap()) { return; }

    PlayerInfo player = players[consolePlayer];

    if (_renderCounter >= _renderUpdatePeriod)
      {
        SetAreaName(GetAreaName(_data));
        SetRenderCounter(0);
      }
    else { SetRenderCounter(_renderCounter + 1); }

    if (_settings.showLockAccess())
    {
      updateDoorLockStatus(player);
      drawDoorLockStatus(player);
    }

    Font    font        = smallFont;
    double  x           = _settings.xStart();
    double  y           = _settings.yStart();
    double  scale       = 1.0 / _settings.compassScale();
    vector3 pos         = player.mo.pos;
    double  playerAngle = player.mo.angle % 360.0;
    double  drawDirection = _settings.textAboveCompass() ? -1 : 1;

    if (_settings.showCompass())
    {
      double offset = drawCompass(x, y, scale, _settings.compassDegrees(), _settings.compassStyle(), _data, pos, playerAngle);
      if (!_settings.textAboveCompass())
      {
        y += offset;
      }
      else
      {
        y -= double(font.GetHeight() * 2.5) / Screen.GetHeight();
      }
    }

    if (_settings.isTextSeparate())
    {
      x = _settings.textX();
      y = _settings.textY();
      drawDirection = 1;
    }

    if (_settings.levelName())
    {
      y += drawTextCenter(level.levelName, normalColor, scale, x, y, font)
        * drawDirection;
    }

    if (_settings.showExplored())
    {
      string progress = String.Format("Explored: %d/10", _progress);
      y += drawTextCenter(progress, normalColor, scale, x, y, font)
        * drawDirection;
    }

    if (_settings.showAreaName() && _areaName.length() != 0)
    {
      y += drawTextCenter(_areaName, normalColor, scale, x, y, font)
        * drawDirection;
    }

    if (_settings.showGridCoords())
    {
      string coords = makeGridCoordinates(pos);
      y += drawTextCenter(coords, normalColor, scale, x, y, font)
        * drawDirection;
    }

    MaybeDrawMapName();
    MaybeDrawSpeed(player);
  }

  // public: ///////////////////////////////////////////////////////////////////

  // returns unique pointer id
  int AddPointer(double x, double y, int type)
  {
    ++_data.pointerId;
    _data.pointers.push(new("m8f_hn_Pointer").init(x, y, type, _data.pointerId));

    return _data.pointerId;
  }

  void RemovePointer(int id)
  {
    int nPointers = _data.pointers.size();
    for (int i = 0; i < nPointers; ++i)
    {
      if (_data.pointers[i].id() == id)
      {
        _data.pointers.delete(i);
        break;
      }
    }
  }

  // private: //////////////////////////////////////////////////////////////////

  private ui
  void MaybeDrawMapName()
  {
    if (_settings.showIntroLevelName() && _mapNameAlpha > 0.0)
    {
      Font   font    = bigFont;
      double scale   = 0.5;
      double x       = 0.5;
      double y       = 0.2;
      string mapName = level.levelName;

      drawTextCenter(mapName, Font.CR_RED, scale, x, y, font, 0, _mapNameAlpha);
    }

    setMapNameAlpha(_mapNameAlpha - 0.005);
  }

  private play
  void setMapNameAlpha(double value) const
  {
    _mapNameAlpha = value;
  }

  private ui
  int getDoorLockStatus(PlayerInfo player)
  {
    double         distance = 500;
    FLineTraceData lineData;
    bool           success = _utils.getPlayerViewLine(player, distance, lineData);

    if (!success) { return 0; }

    Line l = lineData.HitLine;
    if (l == null) { return 0; }

    if (!isSwitch(l)) { return 0; }
    if (!hasLock(l))  { return 0; }

    int locknum = l.args[3];

    if (locknum == 0) { return 0; }

    Actor playerActor = player.mo;
    bool  hasKey      = playerActor.CheckKeys(locknum, false, true);

    return hasKey + 1;
  }

  private ui
  void updateDoorLockStatus(PlayerInfo player)
  {
    int doorLockStatus = getDoorLockStatus(player);
    switch (doorLockStatus)
    {
    case 0:
      SetTargetLockAlpha(0);
      break;

    case 1:
      SetTargetLockAlpha(100);
      SetLockMessage("-");
      SetLockColor(Font.CR_RED);
      break;

    case 2:
      SetTargetLockAlpha(100);
      SetLockMessage("+");
      SetLockColor(Font.CR_GREEN);
    }
  }

  private play
  void SetTargetLockAlpha(int value) const
  {
    _targetLockAlphaPercent = value;
  }

  private play
  void SetLockMessage(string text) const
  {
    _lockMessage = text;
  }

  private play
  void SetLockColor(int lockColor) const
  {
    _lockColor = lockColor;
  }

  private play
  void SetCurrentLockAlpha(int value) const
  {
    _currentLockAlphaPercent = value;
  }

  private ui
  void drawDoorLockStatus(PlayerInfo player)
  {
    int fadeOutStep = 1;
    int fadeInStep  = 10;
    if (_currentLockAlphaPercent < _targetLockAlphaPercent)
    {
      SetCurrentLockAlpha(_currentLockAlphaPercent + fadeInStep);
    }
    else if (_currentLockAlphaPercent > _targetLockAlphaPercent)
    {
      SetCurrentLockAlpha(_currentLockAlphaPercent - fadeOutStep);
    }
    if (_currentLockAlphaPercent <= 0) { return; }

    Font   font  = smallFont;
    double scale = 0.5;
    double x     = 0.5;
    double y     = 0.3;

    double currentLockAlpha = _currentLockAlphaPercent * 0.01;

    drawTextCenter(_lockMessage, _lockColor, scale, x, y, font, 0, currentLockAlpha);

    // todo: remote activation?

    //bool result = l.remoteactivate(playerActor, _data.lineSide, SPAC_Use, playerActor.pos);
    //console.printf("%d", result);
  }

  private ui
  string GetAreaName(m8f_hn_Data data) const
  {
    string areaName = "no area name sources found";
    int    size     = _areaNameSources.size();
    for (int i = 0; i < size; ++i)
      {
        let areaNameSource = _areaNameSources[i];
        if (_settings.hideAutoAreaNames() && areaNameSource.IsAutomatic())
          {
            continue;
          }

        areaName = areaNameSource.GetAreaName(data);
        if (areaName.Length() != 0) { break; }
      }
    return areaName;
  }

  private play
  void SetRenderCounter(int value) const
  {
    _renderCounter = value;
  }

  private play
  void SetAreaName(string name) const
  {
    _areaName = name;
  }

  // What a mess.
  private ui
  double drawCompass( double      relativeX
                    , double      relativeY
                    , double      scale
                    , double      degrees
                    , int         style
                    , m8f_hn_Data data
                    , vector3     playerPosition
                    , double      playerAngle
                    )
  {
    static const string ribbons[] =
    {
      "hn_compass_ribbon_dark",
      "hn_compass_ribbon_transparent",
      "hn_compass_ribbon_blue",
      "hn_compass_ribbon_doom",
      "hn_compass_ribbon_pixel"
    };
    static const string borders[] =
    {
      "hn_compass_border_dark",
      "hn_compass_border_white",
      "hn_compass_border_blue",
      "hn_compass_border_doom",
      "hn_compass_border_pixel"
    };

    int baseClamp    =  25;
    int baseDegrees  = 180;
    int baseMargin   =  10;
    int baseWidth    = 110;
    int baseHeight   =  25;

    double degreesWidth = baseWidth * (degrees / baseDegrees);

    double ribbonMargin = baseMargin   / scale;
    double ribbonWidth  = degreesWidth / scale;
    double ribbonHeight = baseHeight   / scale;

    double screenWidth   = Screen.GetWidth();
    double screenHeight  = Screen.GetHeight();
    double screenRibbonX = screenWidth  * relativeX - ribbonWidth / 2.0;
    double screenRibbonY = screenHeight * relativeY;

    double virtualWidth  = screenWidth  * scale;
    double virtualHeight = screenHeight * scale;
    double virtualBorderC = virtualWidth  * relativeX;
    double virtualBorderX = virtualWidth  * relativeX - degreesWidth / 2.0;
    double virtualBorderR = virtualWidth  * relativeX + degreesWidth / 2.0;
    double virtualBorderY = virtualHeight * relativeY;

    // ribbon texture is 800px for 360° and scaled by 4
    double pixelPerAngle = 800.0 / 4.0 / 360.0;

    // ribbon texture offset
    double offsetByAngle = 0.0;
    // offset depending on player angle
    offsetByAngle += pixelPerAngle * (360.0 - playerAngle);
    // offset depending on number of visible angles (0 at 180°)
    offsetByAngle += pixelPerAngle * ((baseDegrees - degrees) / 2);
    // offset depending on start of first letter N
    offsetByAngle += (200.0 + baseMargin) / 4.0;
    // unknown offset, probably depending on center of first letter N
    offsetByAngle += pixelPerAngle * ((baseDegrees - degrees) / 20);

    // draw border (un-clipped)
    TextureID border = TexMan.CheckForTexture(borders[style], TexMan.Type_Any);

    // left ribbon border
    Screen.DrawTexture( border, false
                      , round(virtualBorderX)
                      , virtualBorderY
                      , DTA_KeepRatio,     true
                      , DTA_SRCX,          0
                      , DTA_SRCWIDTH,      baseClamp
                      , DTA_DESTWIDTH,     baseClamp
                      , DTA_VirtualWidth,  int(virtualWidth)
                      , DTA_VirtualHeight, int(virtualHeight)
                      );

    // offset to align end of center part with start of right part
    double alignmentOffset = round(virtualBorderR - baseClamp) - (virtualBorderR - baseClamp);

    // center ribbon border
    Screen.DrawTexture( border, false
                      , round(virtualBorderX + baseClamp)
                      , virtualBorderY
                      , DTA_KeepRatio,     true
                      , DTA_SRCX,          baseClamp
                      , DTA_SRCWIDTH,      baseWidth - baseClamp * 2
                      , DTA_DESTWIDTH,     int(round(degreesWidth - baseClamp * 2.0 + alignmentOffset))
                      , DTA_VirtualWidth,  int(virtualWidth)
                      , DTA_VirtualHeight, int(virtualHeight)
                      );

    // right ribbon border
    Screen.DrawTexture( border, false
                      , round(virtualBorderR - baseClamp)
                      , virtualBorderY
                      , DTA_KeepRatio,     true
                      , DTA_SRCX,          baseWidth - baseClamp
                      , DTA_SRCWIDTH,      baseClamp
                      , DTA_DESTWIDTH,     baseClamp
                      , DTA_VirtualWidth,  int(virtualWidth)
                      , DTA_VirtualHeight, int(virtualHeight)
                      );

    // set clipping rectangle for the ribbon
    Screen.SetClipRect( int(round(screenRibbonX + ribbonMargin / 2.0))
                      , int(screenRibbonY + ribbonMargin / 2.0)
                      , int(round(ribbonWidth - ribbonMargin))
                      , int(ribbonHeight - ribbonMargin)
                      );

    /*
    // draw the black screen just to test clip rect
    TextureID black = TexMan.CheckForTexture("hn_black", TexMan.Type_Any);
    Screen.DrawTexture( black, false
                      , 0.0
                      , 0.0
                      , DTA_KeepRatio,     true
                      , DTA_VirtualWidth,  int(virtualWidth)
                      , DTA_VirtualHeight, int(virtualHeight)
                      );
    ///*///

    // draw the ribbon (clipped)
    TextureID ribbon = TexMan.CheckForTexture(ribbons[style], TexMan.Type_Any);
    Screen.DrawTexture( ribbon, false
                      , virtualBorderX - offsetByAngle
                      , virtualBorderY + baseMargin / 2.0
                      , DTA_KeepRatio,     true
                      , DTA_VirtualWidth,  int(virtualWidth)
                      , DTA_VirtualHeight, int(virtualHeight)
                      );

    // draw Pointers (clipped)
    drawPointers( virtualBorderX
                , virtualBorderY + baseMargin / 2.0
                , int(virtualWidth)
                , int(virtualHeight)
                , int(degreesWidth)
                , data
                , playerPosition
                , playerAngle
                , style
                );

    // clear clipping rectangle
    Screen.ClearClipRect();

    double relativeCompassHeight = double(ribbonHeight) * 1.4 / screenHeight;
    return relativeCompassHeight;
  }

  private ui
  void drawPointers( double      x
                   , double      y
                   , int         width
                   , int         height
                   , int         ribbonWidth
                   , m8f_hn_Data data
                   , vector3     playerPosition
                   , double      playerAngle
                   , int         style
                   )
  {
    static const string pointerTextures[] =
    {
      // dark
      "hn_compass_pointer_white" ,
      "hn_compass_pointer_blue"  ,
      "hn_compass_pointer_gold"  ,
      "hn_compass_pointer_green" ,
      "hn_compass_pointer_ice"   ,
      "hn_compass_pointer_red"   ,
      // minimalistic
      "hn_compass_pointer_white" ,
      "hn_compass_pointer_blue"  ,
      "hn_compass_pointer_gold"  ,
      "hn_compass_pointer_green" ,
      "hn_compass_pointer_ice"   ,
      "hn_compass_pointer_red"   ,
      // blue
      "hn_compass_pointer_white" ,
      "hn_compass_pointer_blue"  ,
      "hn_compass_pointer_gold"  ,
      "hn_compass_pointer_green" ,
      "hn_compass_pointer_ice"   ,
      "hn_compass_pointer_red"   ,
      // doom
      "hn_compass_pointer_doom_white" ,
      "hn_compass_pointer_doom_blue"  ,
      "hn_compass_pointer_doom_gold"  ,
      "hn_compass_pointer_doom_green" ,
      "hn_compass_pointer_doom_ice"   ,
      "hn_compass_pointer_doom_red"   ,
      // pixel
      "hn_compass_pointer_pixel_white" ,
      "hn_compass_pointer_pixel_blue"  ,
      "hn_compass_pointer_pixel_gold"  ,
      "hn_compass_pointer_pixel_green" ,
      "hn_compass_pointer_pixel_ice"   ,
      "hn_compass_pointer_pixel_red"
    };

    int nPointers = data.pointers.size();
    for (int i = 0; i < nPointers; ++i)
    {
      double    xPointer   = data.pointers[i].x();
      double    yPointer   = data.pointers[i].y();
      int       type       = data.pointers[i].type() + style * 6;
      TextureID pointerTex = TexMan.CheckForTexture(pointerTextures[type], TexMan.Type_Any);

      drawPointer( x, y, width, height, ribbonWidth
                 , playerPosition, playerAngle
                 , xPointer, yPointer, pointerTex
                 , false
                 );
    }

    int nQuestPointers = data.questPointers.size();
    for (int i = 0; i < nQuestPointers; ++i)
    {
      let questPointer = data.questPointers[i];
      if (questPointer == null) { continue; }

      double    xPointer   = questPointer.pos.x;
      double    yPointer   = questPointer.pos.y;
      int       type       = m8f_hn_Pointer.POINTER_GOLD + style * 6;
      TextureID pointerTex = TexMan.CheckForTexture( pointerTextures[type]
                                                   , TexMan.Type_Any
                                                   );

      drawPointer( x, y, width, height, ribbonWidth
                 , playerPosition, playerAngle
                 , xPointer, yPointer, pointerTex
                 , false
                 );
    }

    if (_settings.showSwitches())
    {
      int nLines = level.lines.size();
      for (int i = 0; i < nLines; ++i)
      {
        Line l = level.lines[i];
        if (!isSwitch(l)) { continue; }

        double    xPointer   = (l.v1.p.x + l.v2.p.x) / 2;
        double    yPointer   = (l.v1.p.y + l.v2.p.y) / 2;
        int       type       = m8f_hn_Pointer.POINTER_ICE + style * 6;
        TextureID pointerTex = TexMan.CheckForTexture( pointerTextures[type]
                                                     , TexMan.Type_Any
                                                     );

        drawPointer( x, y, width, height, ribbonWidth
                   , playerPosition, playerAngle
                   , xPointer, yPointer, pointerTex
                   , true
                   );
      }
    }
  }

  // private: // static section ////////////////////////////////////////////////

  private static
  bool contains(String s, String substring)
  {
    return (s.IndexOf(substring) != -1);
  }

  private static
  void removeSigns()
  {
    removeAll("m8f_hn_Sign");
  }

  private static
  void removeAll(String className)
  {
    let   iterator = ThinkerIterator.Create(className);
    Actor a;
    while (a = Actor(iterator.Next()))
    {
      a.A_Die();
    }
  }

  private static
  bool CheckTitlemap()
  {
    bool isTitlemap = (level.mapname == "TITLEMAP");
    return isTitlemap;
  }

  private ui static
  int round(double value)
  {
    int rounded = int(value + 0.5);
    return rounded;
  }

  private ui static
  double clamp(double value, double min, double max)
  {
    if      (value < min) { return min;   }
    else if (value > max) { return max;   }
    else                  { return value; }
  }

  private ui static
  int clampInt(int value, int min, int max)
  {
    if      (value < min) { return min;   }
    else if (value > max) { return max;   }
    else                  { return value; }
  }

  // +--------------+
  // |      1       |
  // +--------------+
  // +-++--------++-+
  // |3||original||4|
  // +-++--------++-+
  // +--------------+
  // |      2       |
  // +--------------+

  private ui static
  void SetClipRectAroundTop(int x, int y, int width, int height, int border)
  {
    Screen.SetClipRect( x - border
                      , y - border
                      , width + border * 2
                      , border
                      );
  }

  private ui static
  void SetClipRectAroundBottom(int x, int y, int width, int height, int border)
  {
    Screen.SetClipRect( x - border
                      , y + height
                      , width + border * 2
                      , border
                      );
  }

  private ui static
  void SetClipRectAroundLeft(int x, int y, int width, int height, int border)
  {
    Screen.SetClipRect( x - border
                      , y
                      , border
                      , height
                      );
  }

  private ui static
  void SetClipRectAroundRight(int x, int y, int width, int height, int border)
  {
    Screen.SetClipRect( x + width
                      , y
                      , border
                      , height
                      );
  }

  private ui static
  string makeGridCoordinates(vector3 pos)
  {
    int     x        = int(pos.x);
    int     y        = int(pos.y);
    int     gridSize = 512;
    if (x < 0) { x -= gridSize; }
    if (y < 0) { y -= gridSize; }
    string  xString  = intToStringAA(x / gridSize);
    y                = (y + 64) / gridSize;
    string  coords   = String.Format("%s %d", xString, y);
    return coords;
  }

  private ui static
  string intToStringAA(int value)
  {
    if (value == 0) { return "A"; }

    bool negative;
    if (value >= 0) { negative = false;}
    else            { negative = true; value = -value - 1; }

    string result = "";
    while (true)
      {
        int small = value % 26;
        result    = String.Format("%c%s", 65 + small, result);
        value    /= 26;

        if (value == 0) break;
        --value;
      }

    if (negative) { result = String.Format("-%s", result); }

    return result;
  }

  private ui static
  double drawTextCenter( string text
                       , int    color
                       , double scale
                       , double x
                       , double y
                       , Font   font
                       , int    xAdjustment = 0
                       , double alpha = 1.0
                       )
  {
    int    width       = int(scale * Screen.GetWidth());
    int    height      = int(scale * Screen.GetHeight());
    double stringWidth = font.StringWidth(text);
    x  = (width * x) - stringWidth / 2;
    y *= height;
    double margin = 4.0;
    if      (x < margin)                       { x = margin; }
    else if (x > width - stringWidth - margin) { x = width - stringWidth - margin; }

    Screen.DrawText( font, color, x, y, text
                   , DTA_KeepRatio,     true
                   , DTA_VirtualWidth,  width
                   , DTA_VirtualHeight, height
                   , DTA_Alpha,         alpha
                   );

    return (font.GetHeight() / scale) / Screen.GetHeight();
  }

  private ui static
  bool isSwitch(Line l)
  {
    bool activation = (l.activation & ( SPAC_Use
                                      | SPAC_Impact
                                      | SPAC_Push
                                      | SPAC_UseThrough
                                      | SPAC_UseBack
                                      ));
    return (activation);
  }

  private ui static
  bool hasLock(Line l)
  {
    int  special     = l.special;
    bool lineHasLock = (special == 13 || special == 83 || special == 85);

    return lineHasLock;
  }

  private ui static
  void drawPointer( double    x
                  , double    y
                  , int       width
                  , int       height
                  , int       ribbonWidth
                  , vector3   playerPosition
                  , double    playerAngle
                  , double    xPointer
                  , double    yPointer
                  , TextureID pointerTex
                  , bool      closeFormula
                  )
  {
    double xDiff = xPointer - playerPosition.x;
    double yDiff = yPointer - playerPosition.y;
    double angle;
    if      (yDiff > 0.0) { angle = atan(xDiff / yDiff) +  90.0; }
    else if (yDiff < 0.0) { angle = atan(xDiff / yDiff) + 270.0; }
    else if (xDiff < 0.0) { angle =   0.0; }
    else if (xDiff > 0.0) { angle = 180.0; }
    else                  { angle =  90.0; }

    angle         = (angle + playerAngle - 90.0) % 360.0;
    double xStart = angle * (ribbonWidth / 180.0);

    double yOffset;
    if (closeFormula)
    {
      double distance = sqrt(xDiff * xDiff + yDiff * yDiff);
      yOffset         = log(distance * 0.05) * 5 - 5;

    }
    else
    {
      double distance = xDiff * xDiff + yDiff * yDiff;
      double step     = 500000.0;
      double steps    = distance / step;
      yOffset         = steps;
      if (yOffset > 11) { yOffset = 11; } // 11 - maximum
    }

    Screen.DrawTexture( pointerTex, false, x + xStart, y + yOffset
                      , DTA_KeepRatio,     true
                      , DTA_VirtualWidth,  width
                      , DTA_VirtualHeight, height
                      );
  }

  private static
  int countFoundSectors()
  {
    int foundSectors = 0;
    int nSectors     = level.sectors.size();

    for (int i = 0; i < nSectors; ++i)
      {
        Sector s       = level.sectors[i];
        bool   isFound = (s.MoreFlags & Sector.SECMF_DRAWN);
        if (isFound) { ++foundSectors; }
      }

    return foundSectors;
  }

  private
  void OnMapExplored(PlayerInfo player)
  {
    Actor playerActor = player.mo;
    if (playerActor == null) { return; }

    if (_settings.nTranslocatorExp())
    {
      playerActor.GiveInventory("m8f_hn_EntrywayTranslocator", _settings.nTranslocatorExp());
    }

    if (_settings.nTunnelingExp())
    {
      playerActor.GiveInventory("m8f_hn_SpaceTunnelingDevice", _settings.nTunnelingExp());
    }

    if (!_isMapRevealerOnMap && _settings.revealExploredMap())
    {
      Console.Printf("Level is explored, map is revealed.");

      playerActor.GiveInventory("MapRevealer", 1);

      if (_settings.scannerExploredMap())
      {
        playerActor.GiveInventory("m8f_hn_Scanner", 1);
      }
    }
  }

  private ui
  void MaybeDrawSpeed(PlayerInfo player)
  {
    if (automapActive)          { return; }
    if (!_settings.showSpeed()) { return; }

    vector3 vel   = player.mo.vel;
    double  speed = sqrt(vel.x * vel.x + vel.y * vel.y) * 583.33 / 15.104167;

    // https://doomwiki.org/wiki/Player
    string speedLevel;
    if      (speed ==    0.00) { speedLevel = ".";      }
    else if (speed <=  291.65) { speedLevel = ">";      }
    else if (speed <=  583.32) { speedLevel = ">>";     }
    else if (speed <=  747.02) { speedLevel = ">>>";    }
    else if (speed <=  824.93) { speedLevel = ">>>>";   }
    else if (speed <= 1235.11) { speedLevel = ">>>>>";  }
    else                       { speedLevel = ">>>>>>"; }

    string speedStr = String.Format("%.2f", speed);
    double scale    = 1.0 / _settings.speedometerScale();
    double y        = _settings.speedometerY();
    double x        = _settings.speedometerX();

    y += drawTextCenter(speedLevel, normalColor, scale, x, y, smallfont);
    drawTextCenter(speedStr, normalColor, scale, x, y, smallfont);
  }

  private
  void ThrowSign()
  {
    string signType = "m8f_hn_WoodenSign";
    switch (m8f_hn_sign_type)
    {
    case 0: signType = "m8f_hn_WoodenSign"     ; break;
    case 1: signType = "m8f_hn_TransparentSign"; break;
    case 2: signType = "m8f_hn_MetalSign"      ; break;
    }

    let player = players[consolePlayer].mo;

    let thing  = Actor.Spawn(signType, player.Pos + (0, 0, 20.));

    //thing.Vel.X = 100.;//xy_velx + player.Vel.X / 2;
    //thing.Vel.Y = 0.;//xy_vely + player.Vel.Y / 2;
    thing.Angle = player.Angle;
    thing.VelFromAngle(5.);
    //thing.Vel.Z = 0.;//5.0;
  }

  // private: //////////////////////////////////////////////////////////////////

  private Array<m8f_hn_BaseAreaNameSource> _areaNameSources;
  private m8f_hn_Data     _data;
  private m8f_hn_Settings _settings;
  private m8f_hn_Utils    _utils;

  private int     _renderUpdatePeriod;
  private int     _renderCounter;
  private string  _areaName;
  private bool    _isTitlemap;
  private int     _progress;
  private int     _oldProgress;
  private int     _initialFoundSectorsCount;

  private bool    _isFirstTick;
  private bool    _isWorldLoaded;

  private int     _currentLockAlphaPercent;
  private int     _targetLockAlphaPercent;
  private string  _lockMessage;
  private int     _lockColor;

  private bool    _isMapRevealerOnMap;

  private double  _mapNameAlpha;

  // const section

  const normalcolor = Font.CR_GRAY;

} // class m8f_hn_EventHandler
