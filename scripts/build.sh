#!/bin/bash

#./make-sprites.sh

mkdir -p build

filename=build/hellscape-navigator-$(git describe --abbrev=0 --tags).pk3

git log --date=short --pretty=format:"-%d %ad %s%n" | \
    grep -v "^$" | \
    sed "s/HEAD -> master, //" | \
    sed "s/, origin\/master//" | \
    sed "s/ (HEAD -> master)//" | \
    sed "s/ (origin\/master)//"  |\
    sed "s/- (tag: \(v\?[0-9.]*\))/\n\1\n-/" \
    > changelog.txt

rm   -f "$filename"
zip -R0 "$filename" "*.md" "*.txt" "*.zs" "*.png" > /dev/null
gzdoom  "$filename" "$@" > output.log 2>&1; cat output.log
