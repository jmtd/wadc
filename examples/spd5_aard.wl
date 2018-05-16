/*
 * spd5_aard.wl: Aardappel's entry into the 5th Doomworld Speedmapping compilation
 * part of WadC
 *
 * Copyright © 2001-2008 Wouter van Oortmerssen
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"basic.h"
#"monsters.h"
#"pickups.h"
#"spawns.h"


main {
  undefx
  autotexall
  autotex("W",0,0,0,"ROCK5")
  autotex("C",0,0,0,"F_SKY1")
  autotex("F",0,0,0,"RROCK19")

  ceil("RROCK19")
  sectordefaults(0, 128, 160, 192)
  playerstartskeyedexit
  autotexall
  placeall(160,-128)
  placeall(160,128)
  step(64,144)
  step(128,112)
  step(80,16)
  straight(160)
  step(176,48)
  step(16,64)
  right(96)
  eright(64)
  step(320,-48)
  step(144,48)
  step(32,96)
  step(32,80)
  step(16,80)
  step(16,112)
  step(80,192)
  step(128,16)
  step(96,-16)
  step(32,-80)
  step(16,-112)
  left(80)
  step(192,-48)
  step(112,-48)
  step(96,16)
  step(80,112)
  step(32,128)
  step(64,192)
  step(128,160)
  step(144,112)
  step(160,80)
  step(208,48)
  step(352,32)
  step(464,-128)
  step(272,-192)
  step(160,-352)
  step(240,-176)
  step(368,128)
  step(96,288)
  step(112,368)
  step(288,48)
  step(240,-16)
  step(192,-144)
  step(64,-336)
  left(432)
  step(368,-48)
  step(256,-112)
  step(320,-224)
  step(144,-240)
  step(-16,-336)
  step(-144,-224)
  step(-320,-112)
  step(-320,-64)
  eright(-128)
  step(-176,160)
  step(-160,48)
  step(-192,-16)
  step(-144,-208)
  step(-160,-240)
  step(-96,-144)
  step(-144,32)
  step(-80,144)
  step(16,256)
  step(-96,208)
  step(-208,80)
  step(-192,-32)
  step(-224,-144)
  step(-256,-80)
  step(-64,-48)
  left(80)
  step(112,16)
  step(112,64)
  step(96,64)
  step(176,96)
  step(96,-48)
  step(160,-144)
  step(112,-144)
  step(80,-144)
  step(96,-80)
  straight(176)
  step(224,144)
  step(64,272)
  step(-160,192)
  step(-288,96)
  step(-384,32)
  step(-416,48)
  step(-144,224)
  step(80,208)
  step(304,224)
  step(272,304)
  step(224,368)
  step(64,416)
  step(32,496)
  step(224,400)
  step(624,208)
  step(576,-64)
  step(208,-224)
  step(144,-224)
  step(80,-320)
  step(-112,-352)
  step(-256,-240)
  step(-320,-144)
  step(-272,-208)
  step(-400,-176)
  step(-176,-256)
  step(-80,-368)
  step(112,-240)
  step(272,-192)
  step(256,-128)
  step(128,-80)
  step(256,-192)
  step(48,-192)
  step(-64,-208)
  step(-304,-208)
  step(-448,-80)
  step(-192,-96)
  left(128)
  step(144,64)
  step(16,160)
  step(32,240)
  step(96,208)
  step(112,176)
  step(272,64)
  step(288,32)
  step(224,-208)
  step(160,-320)
  step(48,-400)
  step(48,-752)
  step(-176,-1024)
  step(-192,-688)
  step(-432,-496)
  step(-448,-288)
  step(-416,-272)
  step(-448,-112)
  step(-512,-112)
  step(-624,-48)
  step(-624,-48)
  step(-624,112)
  eleft(-320)
  step(-352,-224)
  step(-320,-64)
  step(-368,16)
  step(-272,160)
  step(-16,144)
  step(16,112)
  step(176,128)
  eright(176)
  step(320,-144)
  step(640,-144)
  step(288,-32)
  step(256,80)
  step(224,144)
  step(288,16)
  step(352,32)
  straight(336)
  step(416,128)
  step(304,240)
  step(288,352)
  step(176,416)
  right(544)
  step(240,176)
  step(192,160)
  step(-16,208)
  step(-144,96)
  step(-368,128)
  step(-288,112)
  step(-144,128)
  step(-96,112)
  leftsector(0,256,176)
  movestep(1136,64)
  placeitem9rev(0,0,48,medikit)
  rotright
  movestep(576,352)
  toggleflag(ambush)
  placeitem9rev(0,0,48,imp)
  movestep(200,160)
  placeitem9rev(0,0,64,demon)
  rotright
  movestep(736,120)
  placeitem9rev(0,0,64,formersergeant)
  movestep(80,224)
  placeitem9rev(0,0,64,formerhuman)
  movestep(256,-608)
  placeitem9rev(0,0,64,formerhuman)
  rotleft
  movestep(896,368)
  placeitem9rev(0,0,128,mancubus)
  movestep(200,-528)
  placeitem9rev(0,0,140,arachnotron)
  movestep(1112,-192)
  placeitem9rev(0,0,64,demon)
  movestep(480,-480)
  placeitem9rev(0,0,64,revenant)
  movestep(160,512)
  placeitem9rev(0,0,140,revenant)
  movestep(128,592)
  placeitem9rev(0,0,64,boxofshells)
  movestep(32,208)
  placeitem(0,0,redskullkey)
  movestep(-896,144)
  placeitem(0,0,yellowskullkey)
  movestep(48,256)
  placeitem9rev(0,0,64,boxofshells)
  movestep(-480,224)
  placeitem9rev(0,0,140,arachnotron)
  movestep(-496,224)
  placeitem9rev(0,0,140,painelemental)
  movestep(-736,-128)
  placeitem9rev(0,0,140,demon)
  movestep(-720,-112)
  placeitem9rev(0,0,64,formerhuman)
  movestep(48,208)
  placeitem9rev(0,0,64,formerhuman)
  movestep(16,-464)
  placeitem9rev(0,0,64,formerhuman)
  movestep(-480,48)
  placeitem9rev(0,0,140,demon)
  movestep(2816,-4080)
  placeitem(0,0,blueskullkey)
  movestep(272,32)
  placeitem9rev(0,0,64,boxofshells)
  movestep(288,592)
  placeitem9rev(0,0,140,baronofhell)
  movestep(-528,384)
  placeitem9rev(0,0,140,arachnotron)
  movestep(-656,320)
  placeitem9rev(0,0,140,heavyweapondude)
  movestep(-576,304)
  placeitem9rev(0,0,140,heavyweapondude)
  movestep(-480,-32)
  placeitem9rev(0,0,140,heavyweapondude)
  movestep(-784,-608)
  placeitem9rev(0,0,64,formerhuman)
  movestep(-1440,320)
  turnaround
  placeitem9rev(0,0,64,formerhuman)
  movestep(544,-192)
  placeitem9rev(0,0,64,hellknight)
  movestep(-2800,-704)
  placeitem9rev(0,0,64,boxofshells)
  movestep(-960,-2656)
  placeitem9rev(0,0,64,boxofshells)
  movestep(480,2240)
  placeitem9rev(0,0,64,boxofshells)
}  
