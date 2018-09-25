#!/bin/bash

#./make-sprites.sh

name=hellscape-navigator

#IWAD="-iwad /home/allkromm/Programs/Games/wads/doom/freedoom1.wad"

acc source/$name.acs acs/$name.o \
&& \
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
zip $name.pk3 \
    *.txt \
    *.md \
    sprites/*/*.png \
    graphics/*/*.png \
    source/*.acs \
    zscript/*.txt \
    acs/*.o \
    language.enu \
&& \
cp $name.pk3 $name-$(git describe --abbrev=0 --tags).pk3 \
&& \
gzdoom $IWAD \
       -file \
       $name.pk3 \
       ~/Programs/Games/wads/maps/DOOMTEST.wad \
       "$1" "$2" \
       +map test
