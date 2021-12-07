/* Copyright Alexander Kromm (mmaulwurff@gmail.com) 2018-2021
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

class hn_CompassEventHandler : hn_InitializedEventHandler
{

// Compass pointers manipulation functions /////////////////////////////////////////////////////////

  /// @returns unique pointer id.
  static
  int addPointer(double x, double y, int type)
  {
    let this = findThis();

    ++this._data.pointerId;
    this._data.pointers.push(hn_CompassPointer.from(x, y, type, this._data.pointerId));

    return this._data.pointerId;
  }

  static
  void removePointer(int id)
  {
    let this = findThis();

    int nPointers = this._data.pointers.size();
    for (int i = 0; i < nPointers; ++i)
    {
      if (this._data.pointers[i].id() == id)
      {
        this._data.pointers.delete(i);
        break;
      }
    }
  }

// EventHandler implementation /////////////////////////////////////////////////////////////////////

  override
  void renderOverlay(RenderEvent e)
  {
    if (!isInitialized()) { return; }
    if (automapActive && !_settings.isShowingOnAutomap()) { return; }
  }

// hn_InitializedEventHandler implementation ///////////////////////////////////////////////////////

  override
  void initialize()
  {
    _settings = hn_CompassSettings.from();
    _data     = hn_CompassData.from();

    _progress    = 0;
    _oldProgress = 0;
    _initialFoundSectorsCount = 0;
  }

// private: ////////////////////////////////////////////////////////////////////////////////////////

  private static
  hn_CompassEventHandler findThis()
  {
    return hn_CompassEventHandler(EventHandler.Find("hn_CompassEventHandler"));
  }

  ui static
  double drawCompass( double      relativeX
                    , double      relativeY
                    , double      scale
                    , double      degrees
                    , int         style
                    , hn_CompassData data
                    , vector3     playerPosition
                    , double      playerAngle
                    , bool        isShowingSwitches
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
                , isShowingSwitches
                );

    // clear clipping rectangle
    Screen.ClearClipRect();

    double relativeCompassHeight = double(ribbonHeight) * 1.4 / screenHeight;
    return relativeCompassHeight;
  }

  private ui static
  void drawPointers( double      x
                   , double      y
                   , int         width
                   , int         height
                   , int         ribbonWidth
                   , hn_CompassData data
                   , vector3     playerPosition
                   , double      playerAngle
                   , int         style
                   , bool        isShowingSwitches
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
      if (questPointer == NULL) { continue; }

      double    xPointer   = questPointer.pos.x;
      double    yPointer   = questPointer.pos.y;
      int       type       = hn_CompassPointer.POINTER_GOLD + style * 6;
      TextureID pointerTex = TexMan.CheckForTexture( pointerTextures[type]
                                                   , TexMan.Type_Any
                                                   );

      drawPointer( x, y, width, height, ribbonWidth
                 , playerPosition, playerAngle
                 , xPointer, yPointer, pointerTex
                 , false
                 );
    }

    if (isShowingSwitches)
    {
      int nLines = level.lines.size();
      for (int i = 0; i < nLines; ++i)
      {
        Line l = level.lines[i];
        if (!hn_Level.isSwitch(l)) { continue; }

        double    xPointer   = (l.v1.p.x + l.v2.p.x) / 2;
        double    yPointer   = (l.v1.p.y + l.v2.p.y) / 2;
        int       type       = hn_CompassPointer.POINTER_ICE + style * 6;
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

  private hn_CompassData     _data;
  private hn_CompassSettings _settings;

  private int _progress;
  private int _oldProgress;
  private int _initialFoundSectorsCount;

} // class hn_CompassEventHandler
