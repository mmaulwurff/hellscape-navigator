#!/bin/bash

#./make-sprites.sh

name=hellscape-navigator
lasttag=$(git describe --abbrev=0 --tags)

#IWAD="-iwad /home/allkromm/Programs/Games/wads/doom/freedoom1.wad"

rm -f $name.pk3 \
&& \
git log --date=short --pretty=format:"-%d %ad %s%n" | \
    grep -v "^$" | \
    sed "s/HEAD -> master, //" | \
    sed "s/, origin\/master//" | \
    sed "s/ (HEAD -> master)//" | \
    sed "s/ (origin\/master)//"  |\
    sed "s/- (tag: \(v\?[0-9.]*\))/\n\1\n-/" \
    > changelog.txt \
&& \
sed -i 's/Version.*/Version '$lasttag'/' Readme.md \
&& \
zip $name.pk3 \
    *.txt \
    *.md  \
    *.zs  \
    sprites/*/*.png  \
    sprites/*.png    \
    graphics/*/*.png \
    zscript/*.zs     \
    zscript/*/*.zs   \
    language.enu     \
&& \
cp $name.pk3 $name-$lasttag.pk3 \
&& \
gzdoom $IWAD \
       -file \
       $name.pk3 \
       ~/Programs/Games/wads/maps/DOOMTEST.wad \
       "$1" "$2" \
       +map test -nomonsters +vid_fps true
