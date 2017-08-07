/*
 * spd2_aard.wl: Aardappel's entry into the 2nd Doomworld Speedmapping compilation
 * part of WadC
 *
 * Copyright © 2001-2008 Wouter van Oortmerssen
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"pickups.h"
#"monsters.h"
#"decoration.h"
#"basic.h"

sstep() { "SLIME16" }

main() {
  undefx

  autotexall
  autotex("L",0,0,0,"BRICK6")
  autotex("L",16,0,0,"BIGDOOR6")
  autotex("N",0,0,0,"BRICK6")
  autotex("N",160,16,0,"BROWNHUG")
  autotex("N",-288,0,0,"TANROCK5")                                
  autotex("U",0,0,0,"BRICK6")
  autotex("C",0,0,0,"RROCK11")
  autotex("C",-288,0,0,"F_SKY1")
  autotex("F",0,0,0,"SLIME13")
  autotex("F",0,0,-3000,"RROCK19")

  -- movestep(1,1) -- map off grid, to comply with contest theme

  sectordefaults(0, 128, 128, 128)
  playerstarts
  seg(erightdent(32,64))
  segplain(32)
  placeall(96,16)
  place(160, -64, light(3, 40))
  seg(erightdent(64,192))
  segplain(64)
  ceilup(64) stairs(4, sstep, 1)
  segplain(96)
  twice(curvebend(32,1))
  seg(walllight(3,16,64,shortredfirestick thing))
  curvebend(32,-1)
  placeitem3rev(64, -64, 64, demon, heavyweapondude, heavyweapondude)
  seg(erightdent(32,64))
  stairs(4, sstep, 0) ceilup(-64)
  placeitem3rev(64, -64, 64, hellknight, imp, imp)
  seg(erightdent(32,64))
  segplain(64)
  twice(curvebend(32,-1))
  segplain(64)
  curvebend(32,1)
  segtrap($trap1, imp, demon, heavyweapondude)
  stairs(8, sstep, 0) ceilup(-128) 
  seg(walllight(3,16,64,shortredfirestick thing))
  twice(curvebend(32,1))
  curvebend(32,-1)
  segplain(32)
  place(160, -64, light(3, 32))
  placeitem3rev(64, -64, 64, demon, hellknight, hellknight)
  seg(erightdent(64,192))
  ceilup(32) stairs(2, sstep, 1)
  twice(curvebend(64,-1))
  ceilup(32) stairs(2, sstep, 1)
  placeitem3(64, -64, 64, demon, revenant, heavyweapondude)
  seg(erightdent(64,192))
  curvebend(32,1)
  segplain(32)
  segtrap($trap2, cacodemon, spectre, spectre)
  ceilup(64) stairs(4, sstep, 1)
  seg(walllight(3,16,64,shortredfirestick thing))
  ceilup(32)
  triple(quad(seg(rightdent(16,64) straight(16) rightdent(16,64) placeitem(40, -40, imp)))
        curvebend(16,-1))
  pushpop(right(16) turnaround quad(right(576))
          floorup(-64) ceilup(32) defaultsectorr
          turnaround
          place(256,-256,light(3, 64))
          placeitem3rev(256, -256, 80, cacodemon, cacodemon, cacodemon))
  ceilup(-32)
  floorup(64)
  stairs(4, sstep, 0)
  ceilup(-64)  
  seg(rightdent(16,128))
  curvebend(64, 1)
  segplain(64)
  seg(walllight(3,16,64,shortredfirestick thing))
  curvebend(192, 1)
  ceilup(128) stairs(8, sstep, 1)

  -- outside bit starts here

  setlight(224)
  ceilup(192)
  curve(144,192,10,1)
  curve(208,-144,10,1)
  curve(80,80,10,1)
  curve(528,224,10,1)
  left(192)
  rotleft
  curve(80,112,10,1)
  curve(144,192,10,1)
  curve(224,80,10,1)
  curve(176,80,10,1)
  left(192)
  rotleft
  curve(112,-32,10,1)
  curve(48,32,10,1)
  curve(48,80,10,1)
  left(16)
  rotleft
  curve(160,64,10,1)
  curve(224,160,10,1)
  left(16)
  rotleft
  curve(64,144,10,1)
  curve(144,256,10,1)
  curve(432,208,10,1)
  curve(32,-80,10,1)
  curve(80,-96,10,1)
  curve(128,-64,10,1)
  curve(80,304,10,1)
  curve(304,384,10,1)
  curve(432,480,10,1)
  curve(64,-80,10,1)
  curve(944,80,10,1)
  curve(176,-16,10,1)
  right(576)
  curve(240,144,10,1)
  curve(1040,-96,10,1)
  curve(-208,176,10,1)
  movestep(-176,-208)
  rotleft
  curve(224,96,10,-1)
  curve(704,-272,10,-1)
  curve(256,272,10,-1)
  curve(864,976,10,-1)
  curve(736,224,10,-1)
  curve(272,-480,10,-1)
  curve(960,576,10,-1)
  curve(1056,848,10,-1)
  curve(208,-224,10,-1)
  curve(1344,224,10,-1)
  curve(1568,240,10,-1)
  curve(1507,464,10,-1)

  defaultsectorr

  movestep(-48,-369)
  rotleft
  placeitem3rev(0, -64, 64, demon, archvile,  demon)
  movestep(748,-240)
  placeitem3rev(0, -64, 64, demon, cacodemon,  demon)
  movestep(512,64)
  placeitem3rev(0, -64, 64, demon, painelemental,  demon)
  movestep(32,944)
  rotright
  placeitem3rev(0, -64, 64, imp, hellknight,  imp)
  movestep(928,560)
  placeitem3rev(0, -64, 64, imp, hellknight,  imp)
  movestep(192,96)
  placeitem3rev(0, -64, 64, imp, hellknight,  imp)
  movestep(-784,2368)
  rotright
  placeitem3rev(0, -64, 80, cacodemon, cacodemon,  cacodemon)
  movestep(192,64)
  placeitem3rev(0, -64, 80, cacodemon, cacodemon,  cacodemon)
  movestep(-192,896)
  rotright
  placeitem3rev(0, -64, 80, cacodemon, cacodemon,  cacodemon)
  movestep(304,208)
  placeitem3rev(0, -64, 64, hellknight, hellknight,  hellknight)

  movestep(-128,976)
  quad(linetype(52,0) right(64))
  innerrightsector(getfloorheight, getceilheight, 64)
}
