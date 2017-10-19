#!/bin/sh
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

    echo "PWAD:: https://redmars.org/wadc/examples/${bn/wl/wad}[${bn/wl/wad}]"
    echo "Source:: https://github.com/jmtd/wadc/blob/master/examples/$bn[$bn]"
    echo
done
