#!/bin/bash

params="-alpha set -background none -rotate"

convert sprites/hnl1a0.png $params 22.5  sprites/hnl9a0.png
convert sprites/hnl1a0.png $params 45    sprites/hnl2a0.png
convert sprites/hnl1a0.png $params 67.5  sprites/hnlAa0.png
convert sprites/hnl1a0.png $params 90    sprites/hnl3a0.png
convert sprites/hnl1a0.png $params 112.5 sprites/hnlBa0.png
convert sprites/hnl1a0.png $params 135   sprites/hnl4a0.png
convert sprites/hnl1a0.png $params 157.5 sprites/hnlCa0.png
convert sprites/hnl1a0.png $params 180   sprites/hnl5a0.png
convert sprites/hnl1a0.png $params 202.5 sprites/hnlDa0.png
convert sprites/hnl1a0.png $params 225   sprites/hnl6a0.png
convert sprites/hnl1a0.png $params 247.5 sprites/hnlEa0.png
convert sprites/hnl1a0.png $params 270   sprites/hnl7a0.png
convert sprites/hnl1a0.png $params 292.5 sprites/hnlFa0.png
convert sprites/hnl1a0.png $params 315   sprites/hnl8a0.png
convert sprites/hnl1a0.png $params 337.5 sprites/hnlGa0.png

convert sprites/hnr1a0.png $params 22.5  sprites/hnr9a0.png
convert sprites/hnr1a0.png $params 45    sprites/hnr2a0.png
convert sprites/hnr1a0.png $params 67.5  sprites/hnrAa0.png
convert sprites/hnr1a0.png $params 90    sprites/hnr3a0.png
convert sprites/hnr1a0.png $params 112.5 sprites/hnrBa0.png
convert sprites/hnr1a0.png $params 135   sprites/hnr4a0.png
convert sprites/hnr1a0.png $params 157.5 sprites/hnrCa0.png
convert sprites/hnr1a0.png $params 180   sprites/hnr5a0.png
convert sprites/hnr1a0.png $params 202.5 sprites/hnrDa0.png
convert sprites/hnr1a0.png $params 225   sprites/hnr6a0.png
convert sprites/hnr1a0.png $params 247.5 sprites/hnrEa0.png
convert sprites/hnr1a0.png $params 270   sprites/hnr7a0.png
convert sprites/hnr1a0.png $params 292.5 sprites/hnrFa0.png
convert sprites/hnr1a0.png $params 315   sprites/hnr8a0.png
convert sprites/hnr1a0.png $params 337.5 sprites/hnrGa0.png

convert sprites/hna1a0.png $params 22.5  sprites/hna9a0.png
convert sprites/hna1a0.png $params 45    sprites/hna2a0.png
convert sprites/hna1a0.png $params 67.5  sprites/hnaAa0.png
convert sprites/hna1a0.png $params 90    sprites/hna3a0.png
convert sprites/hna1a0.png $params 112.5 sprites/hnaBa0.png
convert sprites/hna1a0.png $params 135   sprites/hna4a0.png
convert sprites/hna1a0.png $params 157.5 sprites/hnaCa0.png
convert sprites/hna1a0.png $params 180   sprites/hna5a0.png
convert sprites/hna1a0.png $params 202.5 sprites/hnaDa0.png
convert sprites/hna1a0.png $params 225   sprites/hna6a0.png
convert sprites/hna1a0.png $params 247.5 sprites/hnaEa0.png
convert sprites/hna1a0.png $params 270   sprites/hna7a0.png
convert sprites/hna1a0.png $params 292.5 sprites/hnaFa0.png
convert sprites/hna1a0.png $params 315   sprites/hna8a0.png
convert sprites/hna1a0.png $params 337.5 sprites/hnaGa0.png

optipng sprites/*

wine ~/Programs/doomcrap-0.1.4/util/grabpng.exe -grab "w*0.5" "h*0.5" sprites/*
wine ~/Programs/doomcrap-0.1.4/util/grabpng.exe -grab "w*0.5" "h" sprites/hnwsa0.png
