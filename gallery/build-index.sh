#!/bin/bash
set -ue

cat examples.adoc.in

for wl in ../examples/*wl; do
    bn=$(basename "$wl")
    echo "== $bn"
    echo

    awk "/$bn/ { sub(/^ \\* $bn: /, \"\");print }" "$wl" # description
    echo

    png="img/${bn/wl/png}"
    if [ -f "$png" ]; then
        echo "image::$png[]"
    fi
    map="img/map_${bn/wl/png}"
    if [ -f "$map" ]; then
        echo "image::$map[]"
    fi
    echo

    echo "PWAD:: link:wads/${bn/wl/wad}[${bn/wl/wad}]"
    echo "Source:: link:wads/$bn[$bn]"
    echo
done
