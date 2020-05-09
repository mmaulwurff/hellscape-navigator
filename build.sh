#!/bin/bash

set -e

#./make-sprites.sh

name=hellscape-navigator-$(git describe --abbrev=0 --tags).pk3

rm -f $name.pk3

git log --date=short --pretty=format:"-%d %ad %s%n" | \
    grep -v "^$" | \
    sed "s/HEAD -> master, //" | \
    sed "s/, origin\/master//" | \
    sed "s/ (HEAD -> master)//" | \
    sed "s/ (origin\/master)//"  |\
    sed "s/- (tag: \(v\?[0-9.]*\))/\n\1\n-/" \
    > changelog.txt

zip -R "$name" \
    "*.md"  \
    "*.png" \
    "*.txt" \
    "*.zs"

gzdoom -file "$name" "$@"
