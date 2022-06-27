/*
 * brexit.wl - part of WadC
 * Copyright © 2019 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * "BRutal EXtinction International Tournament"
 * More complex demonstration of vanilla conveyors
 * Available in the /idgames archive:
 * https://www.doomworld.com/idgames/levels/doom2/a-c/brexit
 */

#"standard.h"
#"monsters.h"
#"basic.h"
#"control.h"
#"vanilla_conveyor.h"
#"lines.h"
#"sectors.h"

skyheight { knob("skyheight", 0, 320, 512) }
skylight  { knob("skylight",  0, 160, 255) }

main
{
  setup_textures
  setup_conveyor
  set("flip", 0)
  set("floor", 16)

  unpegged
  undefx
  mid("TEKGREN2") -- remove
  bot("TEKGREN2") -- remove
  top("TEKGREN2") -- remove
  floor("SLIME15") -- remove
  ceil("F_SKY1") -- remove?
  !start

  quart
  startbox
  bottomsteps
  level1walls
  zombieboxes

  -- motivational posters
  ^start movestep(320,256) rotright killvert(178) 
  ^start turnaround movestep(448,256) rotright killvert(178)
/*
  ^start movestep(640,-64) dievert(264)
  ^start rotright movestep(704, 0) hurtvert(264)
  ^start turnaround movestep(768, -64) dievert(264) 
  ^start rotleft movestep(704, -128) fradvert(264)
*/
 
  ^start movestep(384, 160) unpegged dievert2(138) unpegged
  movestep(-2, 32) rotright
  diagvert(138, "DIE", 32, 669)
  scrollhack(29)

  -- stage 2 monster boxes?
  ^start movestep(192,-384)
  stage2door(0, $door5, 112)
  movestep(32, -32)
  rocketroom($plat5,0)
  turnaround movestep(0, -128) killvert(196)
  turnaround movestep(162, -98)
  rotright
  diagvert(150, "FRAD", 128, 0)

  ^start turnaround movestep(320, -384)
  stage2door(0, $door6, 112)
  movestep(32, -32)
  rocketroom($plat6,1) -- 1 signals exit switch
  turnaround movestep(0, -128) killvert(196)
  popsector
  --turnaround-- movestep(32, -64)
  movestep(32,64) exitlight
  turnaround movestep(192, -32) movestep(2,-2) rotright suckvert(150)
 
  ^start move(-64)
  player1start thing deathmatchstart thing
  move(-128) player2start thing deathmatchstart thing
  movestep(128,256) player3start thing deathmatchstart thing
  movestep(0,-512) player4start thing deathmatchstart thing
  print(cat(get("conveyor_stats"), " conveyor triggers"))
  print(cat(get("controlstats"), " control sectors"))
}

setup_textures
{
  texture("KILL", 64, 128)
  addpatch("RW34_1", 0, 0)
  addpatch("WIOSTK", 0, 0)
  addpatch("RW34_1", 40, 0)

  texture("EXITOPEN", 128, 128)
  addpatch("RW34_1", 0, 0)
  addpatch("RW34_1", 64, 0)
  addpatch("WIF", 0, 0)

  texture("FRAD", 64, 128)
  addpatch("RW34_1",   0, 0)
  addpatch("M_DISOPT",-65, 0)
  addpatch("RW34_1",   18, 0)
  addpatch("M_DISOPT", 18, 0)
  addpatch("RW34_1",   34, 0)
  addpatch("WIFRGS",   38, 1)

  texture("DIE", 64, 128)
  addpatch("RW34_1",    0, 0)
  addpatch("M_JKILL",-205, 0)
  addpatch("RW34_1",   34, 0)

  texture("DIE2", 32, 128)
  addpatch("RW34_1",    0, 0)
  addpatch("M_JKILL",-205, 0)

  texture("HURT", 128, 128)
  addpatch("RW34_1",    0, 0)
  addpatch("M_HURT", 0, 0)
  addpatch("RW34_1", 64, 0)
  addpatch("WIMSTAR", 64, 0)

  texture("SUCK", 128, 128)
  addpatch("RW34_1",    0, 0)
  addpatch("WIMSTAR",  16, 0)
  addpatch("RW34_1",    64, 0)
  addpatch("WISUCKS", 70, 0)

  texture("SW1BREXT", 64, 128)
  addpatch("WALL47_2", 0, 0)
  addpatch("SW3S1", 0, 96)

}

setup_conveyor
{
  rotright
  controlinit
  rotleft
  move(1024) move(256)
  conveyor_init($conveyor1)

  -- reserve
  $clock1 $clock2 $clock3 $clock4 $clock5 $clock6 $clock7 $clock8 $clock9 $clock10 $clock11 $clock12
  set("clock", $clock1)
  $door1 $door2 $door3 $door4
  $door5 $door6 $door7 $door8 $door9 $door10 $door11 $door12
  set("door", $door1)
  $plat1 $plat2 $plat3 $plat4 $plat5 $plat6
  set("plat", $plat1)
  $step1 $step2 $step3 $step4
  set("step", $step1)


  conveyor_trigger(stairs_w1_fast_16, $upstairs, 128)

  -- nukage flood #1
  conveyor_trigger(floor_w1_down_LnF_TxTy, $bottom, 1)
  conveyor_trigger(light_w1_255, $bottom, 1)
  conveyor_trigger(floor_w1_up_24, $bottom, 1)
  conveyor_trigger(floor_w1_down_LnF_TxTy, $step1, 12) -- must be >10 but want as short as poss, step inaccessible until it rises again
  conveyor_trigger(light_w1_255, $step1, 1) -- XXX move to flood 2?

  -- flood #2
  conveyor_trigger(floor_w1_up_24, $bottom, 32)
  conveyor_trigger(floor_w1_up_24, $crate2, 1)
  conveyor_trigger(floor_w1_up_NnF, $step1, 15) -- must be >8

  -- flood #3
  conveyor_trigger(floor_w1_up_24, $bottom, 32)
  conveyor_trigger(floor_w1_up_24, $crate1, 1)
  conveyor_trigger(floor_w1_up_24, $crate2, 1)
  conveyor_trigger(floor_w1_down_LnF_TxTy, $step2, 14) -- must be >8
  conveyor_trigger(light_w1_255, $step2, 1)
  conveyor_trigger(floor_w1_up_NnF, $step1, 7) -- must be >8 from last mover
  conveyor_trigger(floor_w1_up_NnF, $step2, 12) -- must be >=12

  -- flood #4
  conveyor_trigger(floor_w1_up_24, $bottom, 32)
  conveyor_trigger(floor_w1_up_24, $crate1, 1)
  conveyor_trigger(floor_w1_up_24, $crate2, 1)
  conveyor_trigger(floor_w1_up_NnF, $step1, 10) -- must be >8
  conveyor_trigger(floor_w1_down_LnF_TxTy, $step3, 1) -- 
  conveyor_trigger(floor_w1_up_NnF, $step2, 11) -- 
  conveyor_trigger(light_w1_255, $step3, 1)
  conveyor_trigger(floor_w1_up_NnF, $step3, 12) -- 

  -- zombie boxes
  conveyor_trigger(floor_w1_down_LnF, $door1,  1)
  conveyor_trigger(floor_w1_up_fast_NnF, $plat1, 32)
  conveyor_trigger(floor_w1_down_LnF,$door3,  64)
  conveyor_trigger(floor_w1_up_fast_NnF, $plat3, 32)

  conveyor_trigger(floor_w1_down_LnF,$door2,  64)
  conveyor_trigger(floor_w1_down_LnF,$door4,  1)
  conveyor_trigger(floor_w1_up_fast_NnF, $plat2, 32)
  conveyor_trigger(floor_w1_up_fast_NnF, $plat4, 1)

  -- access to upper level
  --conveyor_trigger(stairs_w1_fast_16, $upstairs, 128)

  -- more doors (to interleave/reorder/time)
  conveyor_trigger(floor_w1_down_LnF,$door5, 256)
  conveyor_trigger(floor_w1_up_fast_NnF, $plat5, 32)
  conveyor_trigger(floor_w1_down_LnF,$door6, 128) -- exit door
  conveyor_trigger(floor_w1_up_fast_NnF, $plat6, 32)

  -- old...
  conveyor_trigger(door_w1_openclose,$door7, 32)
  conveyor_trigger(door_w1_openclose,$door8, 32)
  conveyor_trigger(door_w1_openclose,$door9, 32)
  conveyor_trigger(door_w1_openclose,$door10, 32)
  conveyor_trigger(door_w1_openclose,$door11, 32)
  conveyor_trigger(door_w1_openclose,$door12, 32)
  conveyor_trigger(door_w1_openclose, $exitdoor, 64)
/*
  -- clocks (to interleave later)
  conveyor_trigger(floor_w1_down_LnF, $clock1, 1)
  conveyor_trigger(floor_w1_down_LnF, $clock2, 64)
  conveyor_trigger(floor_w1_down_LnF, $clock3, 64)
  conveyor_trigger(floor_w1_down_LnF, $clock4, 64)
  conveyor_trigger(floor_w1_down_LnF, $clock5, 64)
  conveyor_trigger(floor_w1_down_LnF, $clock6, 64)
  conveyor_trigger(floor_w1_down_LnF, $clock7, 64)
  conveyor_trigger(floor_w1_down_LnF, $clock8, 64)
  conveyor_trigger(floor_w1_down_LnF, $clock9, 64)
  conveyor_trigger(floor_w1_down_LnF, $clock10, 64)
  conveyor_trigger(floor_w1_down_LnF, $clock11, 64)
  conveyor_trigger(floor_w1_down_LnF, $clock12, 64)
*/


  conveyor_finish
}

startbox
{
  ^start
  !startbox
  floor("FLAT5_4")
  unpegged

  movestep(-128, -64)
  linetype(crusher_w1_slow, $conveyor1)

  straight(128)
  linetype(0, 0)

  right(8)
  bot("ICKWALL2")
  right(8) straight(112) straight(8)
  right(8)
  rotright
  sectortype(sectortype_damage_5, 0)
  floor("NUKAGE1")
  rightsector(111, skyheight, 255,)
  movestep(8,8)

  bot("ICKWALL2")
  
  box(111, skyheight, 255, 112, 112)
  sectortype(0,0)
  right(112)
  twice(left(112))
  right(8)
  right(120)
  right(128)
  right(120)
  right(8)
  floor("FLAT5_4")
  rightsector(136, skyheight, 200)

  ^startbox
  place(256, -256, radiationsuit thing)
}

quart
{
  -- control sector first: we want to ensure the lowest numbered 2s line
  -- in this sector adjoins the control sector

  control(
    sectortype(0,$bottom)
    ceil("F_SKY1")
    floor("RROCK19")
    box(16, skyheight, skylight, 32, 32)
    move(32)
    floor("NUKAGE1")
    sectortype(sectortype_damage_5,0)
    box(15, skyheight, 255, 32, 32)
    sectortype(0,0)
    move(32)
  )
  popsector

  move(-64)
  place(64,-192, medikit thing)
  place(128,-128, greenarmor thing)
  place(160, -64, turnaround formersergeant thing)
  place(-160, -64, formerhuman thing)
  place(0, 128, formerhuman thing)
  place(-192,64, formersergeant thing)
/*
  quad(
  place(192,-64,
    turnaround
    ifelse(eq(get("flip"), 0), formersergeant, formerhuman)
    flip
    thing
  )
  rotleft
  )
*/
  bot("METAL2")
  movestep(256,-64)
  !steps
  rotleft
  quad(
    straight(64) 
    step(128, -128)
    left(64)
    right(32)
    linetype(0,667) left(128) linetype(0,0)
    left(32)
    rotright
  )

  forcesector(lastsector)
  leftsector(0, 0, 0)

  -- tracing around startbox
  rotleft 
  movestep(192,0)
  linetype(crusher_w1_slow, $conveyor1)
  bot("SFALL1")
  yoff(-16)
  straight(128)
  linetype(0,0)
  mid("ICKWALL2")
  bot("SFALL1") left(8) bot("ICKWALL2") straight(120)
  left(128)
  left(120) bot("SFALL1") straight(8)
  forcesector(lastsector)
  rightsector(0,0,0)

  -- floating crate
  movestep(32,32)
  sectortype(0,$crate1)
  bot("CRATE1")
  floor("CRATOP2")
  xoff(0) 
  yoff(0)
  unpegged
  ibox(80, skyheight, skylight, 64, 64)
  popsector

  -- lil' crate
  movestep(-192,-256)
  bot("CRATELIT")
  floor("CRATOP1")
  yoff(32)
  sectortype(0,$crate2)
  ibox(48, skyheight, skylight, 32, 32)
  popsector

  -- diag crate
  sectortype(0,$crate1)
  bot("CRATE2")
  floor("CRATOP1")
  movestep(-64,296)
  yoff(0)
  step(45,45)
  step(45,-45)
  step(-45,-45)
  step(-45,45)
  innerleftsector(80, skyheight, skylight)
  popsector
  movestep(0,-48)
  boxofshells thing

  -- another lil
  movestep(256, -240)
  bot("CRATELIT")
  floor("CRATOP1")
  yoff(32)
  sectortype(0,$crate2)
  step(22, 22)
  step(22,-22)
  step(-22,-22)
  step(-22, 22)
  innerleftsector(48, skyheight, skylight)

  move(-288)
  barrel thing
  movestep(104,160)
  thing
  
  sectortype(0,0)
  unpegged
  undefx
}

bottomsteps
{
  ^steps
  move(32)

  linetype(0,666)
  quad(
    bot("METAL7")
    fori(1,3,
      sectortype(0,get("step"))
      inc("step",1)
      box(add(16,mul(i,24)), skyheight, skylight, 32, 128)
      floor("SLIME14")
      move(32)
    )

    set("step",$step1)

    rotright
    movestep(64,0)
    movestep(256, 320)
    move(32)
  )
  linetype(0,0)
  sectortype(0,0)
}

level1walls
{
  ^start 
  movestep(320,-64)

  quad(

    top("BROWNGRN")
    move(64)
    !door1
    bot("CEMENT1")
    mid("CEMENT1") -- the mid is promoted to bottom when this becomes 2s it seems
    left(32)
    bot("BROWNGRN")
    straight(32)
    mid("TEKGREN2")
    straight(32)
    straight(32)
    bot("TEKGREN2")
    top("TEKGREN2")


    !steps2
    xoff(32) step(32,-32) xoff(0)
    step(32,-32)
    unpegged
    xoff(11) step(128,-128)
    unpegged
    xoff(32) step(32,-32) xoff(0)
    unpegged step(32,-32) unpegged

    !clock
    unpegged xoff(32) left(32) unpegged
    xoff(0) straight(32) undefx
    mid("BROWNGRN")
    bot("BROWNGRN")
    straight(32)
    mid("CEMENT1")
    bot("CEMENT1") 
    straight(32)
 
    bot("METAL7")
    left(64)
    quad(straight(32))

    left(64)
    step(128,128)
    right(64)
    left(128)
    right(128)
    left(64)
    bot("CEMENT1")
    mid("CEMENT1") -- the mid is promoted to bottom when this becomes 2s it seems
    left(128) -- XXX door
    leftsector(112, skyheight, skylight)
--    pushpop(clockstuff)
    
    turnaround
    movestep(448, 384)
  )
}

clockstuff
{
  ^clock
  rotright
  movestep(0,96)
  bot("LITEBLU4")
  floor("FLAT14")

  triple(
    sectortype(0, get("clock"))
    inc("clock", 1)
    ibox(144, skyheight, 200, 16, 16)
    popsector
    movestep(64,64)
  )
  sectortype(0, 0)
}

zombieboxes
{
  ^start
  movestep(384,-128)
  quad(
    zombiebox
    rotright
    movestep(576,320)
  )
}
zombiebox
{
  !zombiebox

  if(eq(get("door"), $door1), 
    place(128, 128, 
      chaingun thing
      turnaround formerhuman cluster(thing, 40)
    )
  )
  if(eq(get("door"), $door3),
    place(128, 128,
      doublebarreled thing
      turnaround formerhuman cluster(thing, 40)
    )
  )
  if(eq(get("door"), $door2),
    place(128, 128,
      stimpak thing
      turnaround imp cluster(thing, 40)
    )
  )
  if(eq(get("door"), $door4),
    place(128, 128,
      stimpak thing
      turnaround demon cluster(thing, 60)
    rocketlauncher thing arocket cluster(thing, 32)
    )
  )

  -- horseshoe
  movestep(0,224) -- hack to avoid wadc choosing adjacent lines
  bot("BROWNGRN")
  straight(8)
  bot("DOORTRAK")
  straight(8)
  bot("BROWNGRN")
  straight(16)
  straight(192)
  left(192)
  left(192)
  straight(16)
  bot("DOORTRAK")
  straight(8)
  bot("BROWNGRN")
  straight(8)
  right(32)
  rotright

  bot("TEKGREN2")
  twice(straight(128)) rotright
  straight(64)
  unpegged straight(64) unpegged
  straight(128)
  rotright
  twice(straight(128)) rotright

  straight(32)
  rightsector(232, skyheight, skylight)

  -- recess
  straight(192)
  right(8)
  xoff(0) bot("SUPPORT3")
  right(24)
  bot("CEMENT1") --BIGDOOR3")
  straight(144)
  bot("SUPPORT3") 
  straight(24) undefx
  right(8)
  rotright
  rightsector(104, skyheight, skylight)
  movestep(0,8)

  -- dropping door
  bot("BIGDOOR3")-- not used
  straight(192)
--  twice(straight(96))
  right(8)
  right(192)
  right(8)
  sectortype(0, get("door"))
  rightsector(208, skyheight, skylight)
  sectortype(0,0)
  inc("door",1)

  -- anchor floor height
  rotright
  movestep(0,8)
  box(104, skyheight, skylight, 192,16)

  -- monster platform
  movestep(0,16)
  sectortype(0, get("plat"))
  inc("plat", 1)
  box(32, skyheight, add(32,skylight), 192, 192)
  sectortype(0,0)
  control(
    forcesector(lastsector)
    box(0,0,0,32,32)
    move(32)
    box(112, skyheight, skylight, 32, 32)
    move(32)
  )

  ^zombiebox
}

stage2door(type, tag, h)
{
  ceil("FLAT23")
  !upperdoor

  movestep(8,-8)
  bot("CEMENT2") step(128,128) 
  unpegged mid("DOORTRAK") step(8,-8) unpegged 
  top("BIGDOOR2") step(-128,-128)
  unpegged mid("DOORTRAK") step(-8,8) unpegged
  mid("TEKGREN2")
  
         sectortype(0,tag)
         leftsector(add(96,h), add(96,h), skylight)
         sectortype(0,0)

  movestep(8, -8)
  step(128,128)
  step(16,-16)
  step(-128,-128)
  step(-16,16)
  leftsector(h, add(96,h), skylight)

  ^upperdoor
  step(128,128)
  step(8,-8)
  step(-128,-128)
  step(-8,8)
  leftsector(h, add(96,h), skylight)
}

rocketroom(tag,lift)
{
  mid("TEKGREN2")
  step(-32,-32)
  unpegged step(128,-128) unpegged
  step(32,32) unpegged step(128,128) unpegged step(32,32)
  step(-128,128)
  step(-32,-32)
  step(-128,-128)
  sectortype(0,tag)
  rightsector(0, 240, skylight)
  sectortype(0,0)
  move(128)
  turnaround 
--  ifelse(eq(get("flip"), 0),
--    rocketlauncher thing arocket cluster(thing, 32),
    mancubus thing
--  )
  flip
}

exitlight
{  unpegged yoff(0)
  linetype(exit_s1_normal, 0)
  top("EXITSIGN") bot("SW1BREXT") xoff(-8)
  step(32, 32) xoff(-8)
   step(8, -8)
   step(-32, -32)
   step(-8, 8) undefx
  innerleftsector(152, 224, 200)
  unpegged
}

-- decorative "adverts"-------------------------------------------------------

advert(height,tex,width,tag,y)
{
  mid("BLAKWAL1")
  floor("CEIL5_1")
  ceil("CEIL5_1")
  straight(2)
  mid(tex)
  linetype(wall_scroll_left,tag)
  yoff(y) xoff(0)
  right(width)
  yoff(0) undefx unpegged
  mid("BLAKWAL1")
  linetype(0,0) unpegged
  right(2)
  right(width)
  rotright
  sectortype(light_oscillate, 0)
  rightsector(height, add(20,height), 256)
  move(2)
/*
  straight(2)
  linetype(wall_scroll_left,0)
  right(width)
  linetype(0,0)
  right(2)
  right(width)
  rotright
  sectortype(light_oscillate,$exitdoor)
  rightsector(height, height, 100)
  sectortype(0,0)
  move(2)

  mid("BLAKWAL1")
  straight(2)
  linetype(wall_scroll_left,0)
  yoff(-4)
  mid("EXITOPEN")
  right(width)
  linetype(0,0)
  mid("BLAKWAL1")
  right(2)
  right(width)
  rotright
  rightsector(height, add(20,height), 256)
  move(2)
*/
}

diagvert(height,tex,width,tag)
{
  mid("BLAKWAL1")
  floor("CEIL5_1")
  ceil("CEIL5_1")
  step(1, -1)
  xoff(0) mid(tex) undefx
  linetype(wall_scroll_left,tag)
  yoff(16) unpegged
  step(width, width)
  yoff(0) unpegged
  linetype(0,0)
  mid("BLAKWAL1")
  step(-1, 1)
  step(mul(-1, width), mul(-1, width))
  sectortype(light_oscillate, 0)
  rightsector(height, add(20,height), 256)
  movestep(1,-1)
/*
  step(1,-1)
  linetype(wall_scroll_left,0)
  step(width, width)
  linetype(0,0)
  step(-1,1)
  step(mul(-1, width), mul(-1, width))
  sectortype(light_oscillate,$exitdoor)
  rightsector(height, height, 100)
  sectortype(0,0)
  movestep(1,-1)

  mid("BLAKWAL1")
  step(1,-1)
  linetype(wall_scroll_left,0)
  yoff(-4)
  mid("EXITOPEN")
  step(width, width)
  linetype(0,0)
  mid("BLAKWAL1")
  step(-1,1)
  step(mul(-1, width), mul(-1, width))
  rightsector(height, add(20,height), 256)
*/
}

scrollhack(n)    
{    
  control(    
  linetype(48,669) -- share with all these lines    
  for(1,n, straight(64))    
  linetype(0,0)    
  right(64) rotright    
  for(1,n, straight(64))
  right(64) rotright
  rightsector(0,0,0)
  )
  control_carriage_return
}

killvert(height)
{
  diagvert(height,"KILL",128,0)
}

fradvert(height)
{
  advert(height, "FRAD", 64, 0, 16)
}

dievert(height)
{
  advert(height, "DIE", 64, 0, 16)
}


dievert2(height)
{
  advert(height, "DIE2", 32, 668, 18)
}


hurtvert(height)
{
  advert(height, "HURT", 64, 0, 16)
}

suckvert(h)
{
  diagvert(150, "SUCK", 128, 0)
}
