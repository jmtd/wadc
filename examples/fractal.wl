/*
 * fractal.wl: fractal example by Aardappel
 * part of WadC
 *
 * Copyright © 2000 Wouter van Oortmerssen
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 * 
 * requires Q1TEX.WAD to play
 */

#"standard.h"

main {
  thing
  frac
}

frac {
  chouter
  straight(128)
  eleft(64)
  frac3
  eleft(64)
  straight(128)
  eleft(256)
  straight(128)
  eleft(64)
  frac3
  eleft(64)
  straight(128)
  left(752)
  left(752)
  secch2
  leftsector(0,128,128)
}

frac3 {
  straight(64)
  move(32)
  rotleft
  frac2
  eleft(32)
  frac2
  eleft(32)
  frac2
  left(32)
  eleft(32)
  straight(32)
  eleft(32)
  straight(192)
  eleft(32)
  straight(240)
  eleft(32)
  straight(192)
  eleft(32)
  straight(32)
  eleft(32)
  straight(32)
  leftsector(16,112,144)
  turnaround
  movestep(32,-112)
  straight(64)
}

frac2 {
  frac1
  rotright
  frac1
  rotright
  frac1
}

frac1 {
  brick
  straight(8)
  !a
  straight(8)
  chouter2
  left(16)
  right(16)
  right(16)
  brick
  left(8)
  straight(8)
  !b
  ^a
  brick2
  left(16)
  eright(8)
  straight(16)
  eright(8)
  straight(16)
  secmet8
  rightsector(64,96,192)
  ^b
}

secch1 { floor("CFLOOR1") ceil("CITYF17") }
secch2 { floor("WOODF4") ceil("CITYF17") }
secmet8 { floor("METALF07") ceil("METALF07") }
secmet16 { floor("METALF18") ceil("METALF18") }
sechall { floor("METALF11") ceil("WOODF8") }

water { floor("QWATER1") }
sky { ceil("F_SKY1") }
green { floor("QGRASS") wall("QROCK4") }
stonefl { floor("WALLF1") }
metfl { floor("METALF18") }

brick { wall("QCITY01") }
brick2 { wall("QBRICK5") }
column { wall("QCOLUMN") }
met8w { wall("QMET01") }
chouter { wall("QMET13") }
chouter2 { wall("QMET16") }
chwindow { mid("QWINDOW4") }
smalllite { mid("LITE5") }


