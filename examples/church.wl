/*
 * church.wl: a Gothic-style church nave by Aardappel
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
  cathedral
  attachhall
}

attachhall {
  ^churchentrance
  rotright
  triple(hallseg)
}

hallseg {
  triple(hallsegside(0))  
  hallsegside(sechall leftsector(-8,160,192))
  move(256)  
}

hallsegside(last) {
  brick
  straight(16)
  met8w
  eright(32)
  straight(64)
  eright(32)
  rotleft
  !hs
  brick
  right(16)
  right(128)
  secmet16
  rightsector(0,128,128)
  ^hs
  met8w
  eleft(16)
  smalllite
  right(16)
  left(16)
  met8w
  !hs
  left(16)
  left(16)
  secmet8
  leftsector(32,96,240)
  ^hs
  eright(16)
  last
  rotleft
  rotleft
  move(-16)
}

cathedral {
  turnaround
  midandnext(1,0)
  midandnext(2,0)
  midandnext(4,0)
  midandnext(2,secch1
               rightsector(0,256,160))
  rotright
  move(16)
  column
  for(1,4,eright(48)
          secmet16
          rightsector(16,240,144)
          secch2
          leftsector(32,160,128)
          move(160))
}

midandnext(rep,sect) {
  secch1
  midsection(rep)
  rotright
  column
  eright(64)
  sect
  move(128)
  rotleft
}

midsection(rep) {
  column
  leftdent3(16,32,64,rep,0,0)
  rotleft
  { eq(rep,4) ? straight(128) !churchentrance : glassbit }
  rotleft
  leftdent3(16,32,64,rep,0,0)
  left(128)
  leftsector(0,256,160)
  addlayer2(rep)
  addlayer2(rep)
  chouter
  movestep(208,-144)
  rotleft
  step(48,-16)
  outerwal(rep)
  left(176)
  move(160)
  straight(176)
  rotleft
  outerwal(rep)
  step(48,16)
  movestep(144,-336)
  rotleft
  rotleft
}

glassbit {
  straight(16)
  straight(96)
  secmet8
  met8w
  right(1)
  right(16)
  left(1)
  chwindow
  right(64)
  met8w
  right(1)
  right(64)
  rightsector(80,208,240)
  rotright
  rotright
  move(64)
  straight(16)
  right(1)
  rightsector(64,224,160)
  rotright
  move(96)
  secch1
  column
  straight(16)
}

outerwal(rep) {
  for(1,sub(rep,1),
    straight(48)
    smalllight
    straight(48))
}

smalllight {
  unpegged
  straight(32)
  secmet8
  met8w
  right(32)
  right(8)
  smalllite
  right(16)
  left(16)
  left(16)
  met8w
  right(8)
  right(32)
  rightsector(64,128,192)
  secch2
  straight(32)
  eright(8)
  straight(16)
  eright(8)
  straight(32)
  rightsector(32,160,160)
  rotright
  rotright
  eright(8)
  left(48)
  eleft(8)
  straight(32)
  eleft(8)
  straight(48)
  eleft(8)
  leftsector(32,160,144)
  move(32)
  chouter
}

addlayer2(rep) {
  yoff(16) straight(16) yoff(0)
  rotleft
  leftdent3(16,32,64,rep,16,
    right(32)
    eright(16)
    straight(32)
    eright(16)
    straight(32)
    rotright
    move(64))
  yoff(16) left(16) yoff(0)
  secmet16
  leftsector(16,240,144)
  move(128)
}

leftdent3(n,mid,dist,rep,y,afterdent) { 
  for(1,rep,straight(dist)
            yoff(y)
            eleftdent(n,mid)
            yoff(0)
            afterdent)
  straight(dist)
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

