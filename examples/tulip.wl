/*
 * tulip.wl: DM map, the basis of "MAP12: Sperziebonen Met Slagroom" in "Crucified Dreams"
 *
 * part of WadC
 *
 * Copyright © 2006 Wouter van Oortmerssen
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"
#"pickups.h"
#"spawns.h"

water { floor("RROCK05") }
mainfloor { floor("QFLAT09") }
mainfloor2 { floor("DGBRKF01") }
mainceiling { ceil("DGMTLF18") }
redfloor { floor("DG_LF08") ceil("DG_LF08") }
yelfloor { floor("DG_LF09") ceil("DG_LF09") }

stairtile { floor("NDGMF03") bot("ADEL_Y03") }
stairtile2 { floor("DGMTLF06") bot("ADEL_Y05") }

mainwall { wall("ADG_M01") } --"DPWALL02"
wall3 { wall("AXLDGB01") }
litewall { mid("LITE3") }
metalstrip { wall("FIREBLU2") } -- NMTSUP5C

upperwall { mid("FIREBLU2") ceil("DGMTLF05") } -- NMETAL12
upperlift { ceil("DGMTLF05") }
liftside { wall("FIREBLU2") } -- NMTPIPE1
liftfloor { 0 } --floor("NMTLF24") }

archt { floor("DGLITF03") /*ceil("NMTLF24")*/ wall("FIREBLU2") } -- NRUST14B

main {
  thing
  move(128)
  mainceiling
  mainfloor
  mainwall
  stairs(128)
  elbow(96,redfloor,mainfloor,medikit)  
  stairs(96)
  elbow(64,redfloor,mainfloor,chaingun)
  stairs(64)
  elbow(32,redfloor,mainfloor,boxofshells)
  stairs(32)
  watery
  mainfloor
  leftjump
  lift  
  ssg
  topland
  stairs(256)
  elbow(224,yelfloor,mainfloor2,boxofammo)
  stairs(224)
  elbow(192,yelfloor,mainfloor2,stimpak)
  stairs(192)
  elbow(160,yelfloor,mainfloor2,arocket)
  stairs(160)
}

archwall(floor,texset,texback,item) {
  unpegged
  straight(320)
  texset
  turnaround
  straight(32)
  straight(64)
  arch(32,32,32,32,add(floor,32),176)
  straight(16)
  arch(64,64,32,64,add(floor,16),176)
  movestep(-32,8)
  item
  thing
  movestep(32,-8)
  straight(16)
  arch(32,32,32,32,add(floor,32),176)
  straight(64)
  turnaround
  move(320)
  unpegged
  texback
  mainceiling
}

topland {
  movestep(192,192)
  right(64)
  right(192)
  right(64)
  rightsector(256,ceiling,128)
  move(-128)
}

ssg {
  move(320)
  left(192)
  rotright
  unpegged
  arch(128,192,192,192,129,128)
  unpegged
  leftsector(128,ceiling,128)
  movestep(-96,0)
  doublebarreled
  thing
  movestep(96,0)
  movestep(0,192)
  rotright
  bumpr
  straight(64)
  stairtile2
  right(32)
  stairtile
  straight(128)
  stairtile2
  straight(32)
  mainwall
  mainfloor2
  right(64)
  rightsector(128,ceiling,128)
}

lift {
  movestep(384,320)
  turnaround
  liftslant
  right(64)
  rotright
  liftslant
  rotright
  movestep(0,192)
  straight(64)
  curve(64,-64,7,-1)
  straight(64)
  sectortype(0,$lift)
  liftfloor
  leftsector(240,ceiling,128)
  sectortype(0,0)
  turnaround
  move(64)
  liftslant
  straight(128)
  rotright
  bumpl
  right(32)
  archwall(256,archt,mainwall,rocketlauncher)
  rotright
  bumpl
  right(32)
  mainfloor2
  rightsector(256,ceiling,128)
}

liftslant {
  curve(16,-16,5,-1)
  upperlift
  metalstrip
  xoff(0)
  curve(32,32,5,-1)
  rotright
  xoff(8)
  curve(32,32,5,1)
  rightsector(sub(ceiling,96),sub(ceiling,32),224)
  mainceiling
  turnaround
  movestep(32,-32)
  mainwall
  curve(16,-16,5,-1)
  xoff(0)
}

leftjump {
  step(-64,0)
  left(64)
  left(192)
  left(64)
  leftsector(128,ceiling,128)
}

watery {
  turnaround
  straight(64)
  bumpr
  straight(128)
  liftslant
  rotright
  linetype(123,$lift)
  liftside
  ricurve(64,-64,7,-1)
  left(64)
  linetype(0,0)
  mainwall
  straight(32)
  rotright
  bumpl
  right(32)
  archwall(0,archt,mainwall,greenarmor)
  bumpr
  straight(64)
  water
  rightsector(0,ceiling,128)
}

bumpr {
  rotright
  curve(32,-96,7,-1)
  curve(96,-32,7,-1)
  rotright
  xoff(0)
}

bumpl {
  rotleft
  curve(32,96,7,-1)
  curve(96,32,7,-1)
  rotleft
  xoff(0)
}

elbow(floor,light,fl,item) {
  turnaround
  bigwall(floor,light,fl)
  slant
  bigwall(floor,light,fl)
  right(192)
  slant
  straight(32)
  rightsector(floor,ceiling,128)
  straight(-32)
  !sl
  movestep(32,96)
  item
  thing
  movestep(0,-32)
  spot(32,160,floor,ceiling)
  ^sl
  movestep(-128,64)
}

spot(r,l,f,c) {
  quad(curve(r,r,5,1))
  innerrightsector(f,c,l)
  movestep(0,8)
  { eq(l,240)
      ? 0
      : { eq(r,16)
            ? 0
            : spot(sub(r,8),add(l,32),f,c) } }
}

bigwall(floor,light,fl) {
 fl
 straight(16)
 lcast(64,32,96)
 step(-160,0)
 straight(16)
 lcast(48,32,64)
 straight(16)
 rightsector(floor,ceiling,176)
 straight(-40)
 straight(24)
 litewall
 left(32)
 left(32)
 left(24)
 mainwall
 left(8)
 right(8)
 light
 leftsector(add(floor,48),add(floor,96),240)
 right(72)
 right(32)
 litewall
 right(64)
 mainwall
 right(32)
 right(24)
 right(16)
 left(16)
 left(16)
 right(24)
 rightsector(add(floor,32),add(floor,112),255)
 straight(8)
 right(8)
 right(8)
 left(24)
 litewall
 left(32)
 left(32)
 mainwall
 left(24)
 leftsector(add(floor,48),add(floor,96),240)
 mainceiling
 fl
 straight(8)
 rightsector(floor,ceiling,224)
 straight(128) 
}

lcast(side,top,up) {
  rotright
  curve(up,sub(0,side),7,-1)
  deathmatchstart
  thing
  straight(top)
  curve(side,sub(0,up),7,-1)
  rotright
  xoff(0)
}


slant {
  rotright
  curve(64,-64,7,-1)
  xoff(0)
  rotright
  rotleft
  upperwall
  left(64)
  movestep(-32,-32)
  redskullkey
  thing
  movestep(32,32)
  left(64)
  leftsector(sub(ceiling,96),sub(ceiling,32),192)
  turnaround
  mainwall
  mainceiling
  up
  eright(64)
  down
}

stairs(floor) {
  stairtile2
  stairs2(floor,32) 
  stairtile
  stairs2(floor,128) 
  stairtile2
  stairs2(floor,32) 
  mainfloor
  mainwall
}

stairs2(floor,w) {
  box(sub(floor,16),ceiling,128,32,w)
  move(32)
  box(floor,ceiling,128,32,w)
  movestep(-32,w)
}

ceiling { add(384,64) }

