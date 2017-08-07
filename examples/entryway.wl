/*
 * entryway.wl: Re-creation of Doom 2 MAP01 by hand
 * part of WadC
 *
 * Copyright © 2010 GreyGhost
 * Copyright © 2010-2017 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

-- First attempt at re-creating MAP01 from Doom 2
-- more-or-less successfull IMHO

#"standard.h"
#"spawns.h"
#"monsters.h"
#"pickups.h"

tekwall(len,type) {
	{ eq(type,0) ? mid("TEKGREN2")  : mid("TEKGREN5")  }
	lessthaneq(len,64)
		? straight(len)
		: straight(64)
		  tekwall(sub(len,64), type ? 0 : 1)
}

main {

  floor("FLOOR0_1") 
  ceil("FLOOR4_1") 
  mid("PIPE4") 
  top("PIPE4") 
  left(64)
  eright(128)
  step(320,64)
  right(64)
  bot("STEP2") 
  step(192,320)
  step(192,-320)
  xoff(192)
  straight(64)
  xoff(0)
  rotright
  step(320,-64)
  eright(128)
  straight(64)
  unpegged
  bot("PIPE4") 
  straight(256)
  unpegged
  rightsector(8,264,128)

  movestep(0,128)
  bot("BRONZE2") 
  ibox(264,264,0,64,64)
  popsector
  movestep(-320,0)
  ibox(264,264,0,64,64)

  movestep(64,-128)
  mid("BRONZE1") 
  top("BRONZE1") 
  left(64)
  step(64,128)
  right(64)
  unpegged
  eright(64)
  unpegged
  straight(64)
  right(256)
  rightsector(56,264,112)
  rotleft
  movestep(-32,-160)
  thing
  movestep(0,64)
  setthing(2)
  thing
  movestep(0,-128)
  setthing(3)
  thing
  movestep(0,192)
  setthing(4)
  thing

  rotleft
  movestep(160,-96)
  eleft(128)
  right(192)
  top("BROWNGRN") 
  right(192)
  right(256)
  eright(64)
  rightsector(56,136,96)

-- Outside area

  movestep(128,320)
  turnaround
  ceil("F_SKY1") 
  mid("MIDBARS3") 
  bot("BRONZE2") 
  unpegged impassable midtex
  step(128,-128)
  step(192,64)
  right(64)
  unpegged impassable midtex
  mid("BROWNGRN") 
  right(128)
  straight(192)
  rightsector(56,264,128)

  floor("GRASS1") 
  step(320,16)
  mid("BROWNGRN") 
  bot("CEMENT9") 
  right(512)
  step(160,448)
  step(-256,448)
  straight(-368)
  step(-48,64)
  step(-16,-320)
  rightsector(8,264,224)

  movestep(16,-640)
  floor("FLAT4") 
  mid("BROWNGRN") 
  step(0,-128)
  step(48,64)
  straight(528)
  step(192,512)
  step(-288,512)
  straight(-432)
  step(-48,64)
  step(0,-64)
  rightsector(64,264,128)

  movestep(0,-1088)
  straight(832)
  right(1152)
  right(832)
  rightsector(64,64,128)

-- Steps

  movestep(208,0)
  floor("FLOOR0_1") 
  ceil("FLOOR4_1") 
  mid("PIPE4") 
  bot("STEP2") 
  xoff(64)
  straight(32)
  xoff(0)
  step(160,256)
  step(160,-256)
  xoff(160)
  straight(32)
  rightsector(16,264,144) -- bottom step
  movestep(-352,0)
  xoff(96)
  straight(32)
  xoff(0)
  step(128,192)
  step(128,-192)
  xoff(128)
  straight(32)
  rightsector(24,264,160)
  movestep(-288,0)
  straight(32)
  xoff(0)
  step(96,128)
  step(96,-128)
  xoff(96)
  straight(32)
  rightsector(32,264,176)
  movestep(-224,0)
  xoff(160)
  straight(32)
  xoff(0)
  step(64,64)
  eleft(64)
  xoff(64)
  right(32)
  rightsector(40,264,192)
  movestep(-160,0)
  xoff(192)
  top("PIPE4") 
  straight(128)
  xoff(0)
  rightsector(48,264,208) -- top step

-- Main corridor

  movestep(-128,0)
  floor("FLOOR3_3") 
  ceil("GRNLITE1") 
  mid("SUPPORT2") 
  xoff(4)
  left(16)
  mid("TEKGREN2") 
  xoff(16)
  straight(48)
  xoff(0)
  tekwall(mul(5,64), 1)
  mid("TEKGREN4") 
  right(64)
  tekwall(128,0)
  mid("TEKGREN3") 
  straight(64)
  unpegged
  top("TEKWALL4")
  !northcorridor
  straight(128)
  unpegged
  mid("TEKGREN3") 
  straight(64)
  tekwall(mul(3,64),0)
  unpegged
  top("TEKWALL6") 
  right(128)
  unpegged
  right(64)
  !southcorridor1
  straight(128)
  tekwall(mul(5,64), 0)
  mid("TEKGREN5") 
  left(64)
  tekwall(128,0)
  mid("TEKGREN2") 
  straight(48)
  mid("SUPPORT2") 
  xoff(4)
  straight(16)
  xoff(0)
  rightsector(56,128,224)
 
  ^southcorridor1 rotleft
  tekwall(256,0)
  !southcorridor2
  right(128) rotright
  tekwall(256, 1)
  rightsector(56,128,224)
  
  ^southcorridor2 
  tekwall(256,0)
  mid("TEKGREN2") 
  straight(48)
  mid("SUPPORT2") 
  xoff(4)
  straight(16)
  xoff(0)
  unpegged
  top("ASHWALL3") 
  bot("STEP6") 
  step(64,128)
  unpegged
  turnaround
  xoff(4)
  straight(16)
  mid("TEKGREN4") 
  xoff(16)
  straight(48)
  xoff(0)
  mid("TEKGREN2") 
  straight(64)
  mid("TEKGREN5") 
  straight(64)
  mid("TEKGREN2") 
  straight(64)
  mid("TEKGREN5") 
  straight(64)
  mid("TEKGREN2") 
  straight(64)
  rightsector(56,128,224)

  ^northcorridor rotleft
  mid("TEKGREN2") 
  straight(128)
  top("BIGDOOR1") 
  linetype(31,0)
  right(128) -- Door
  linetype(0,0)
  right(128)
  rightsector(56,128,160)


-- North rooms

  movestep(-128,128)
  ceil("FLAT20")
  floor("FLOOR3_3") 
  unpegged
  mid("DOORTRAK") 
  straight(-8)
  top("BIGDOOR1") 
  left(128)
  right(8)
  unpegged
  rightsector(56,56,224)

  movestep(-8,128)
  ceil("TLITE6_4") 
  top("TEKGREN2") 
  bot("COMPSPAN") 
  mid("TEKGREN2") 
  yoff(-40)
  straight(-8)
  yoff(0)
  unpegged
  left(128)
  unpegged
  yoff(-40)
  right(8)
  yoff(0)
  rightsector(56,152,224)

  movestep(-8,128)
  ceil("FLAT18") 
  floor("FLOOR1_1") 
  right(208)
  step(112,240)
  right(448)
  eright(128)
  straight(512)
  unpegged
  eright(128)
  unpegged
  straight(448)
  step(240,112)
  right(208)
  rightsector(48,240,160)

-- The pedestals. Sector-in-sector drawing problems forced a few changes here.

  movestep(328,360)
  rotright
  ceil("FLAT18") 
  ibox(48,240,224,336,528)
  movestep(8,8)
  ceil("FLAT2") 
  top("SPACEW3") 
  yoff(64)
  ibox(48,176,224,320,512)
  yoff(0)
  movestep(129,320)
  bot("SPACEW4") 
  ibox(240,240,0,62,64)
  popsector
  ceil("FLAT23")
  movestep(63,0)
  top("SPACEW3") 
  bot("MODWALL3") 
  yoff(64)
  sectortype(0,1)
  ibox(112,176,224,64,128)
  popsector
  movestep(-64,0)
  bot("SW1COMP") 
  linetype(103,2)
  straight(-64)
  linetype(0,0)
  bot("MODWALL3") 
  right(128)
  left(64)
  left(128)
  innerleftsector(112,176,224) -- Switch reveals secret
  sectortype(0,0)
  yoff(0)
  popsector
  movestep(128,1)
  bot("SPACEW4") 
  ibox(240,240,0,64,62)
  popsector
  movestep(0,-65)
  bot("MODWALL3") 
  yoff(64)
  sectortype(0,1)
  ibox(112,176,224,128,64)
  popsector
  movestep(0,128)
  bot("SW1COMP") 
  linetype(102,1)
  right(64)
  linetype(0,0)
  bot("MODWALL3") 
  left(128)
  left(64)
  left(128)
  innerleftsector(112,176,224) -- Switch lowers pedestals
  sectortype(0,0)
  yoff(0)

-- Secret

  movestep(320,-256)
  mid("DOORTRAK") 
  ceil("FLAT20")
  floor("FLOOR1_1") 
  unpegged
  step(16,-16)
  unpegged
  top("TEKGREN2") 
  step(128,128)
  unpegged
  step(-16,16)
  unpegged
  sectortype(0,2)
  rightsector(48,48,144) -- Remote-activated door
  sectortype(0,0)
  movestep(-112,-144)
  mid("TEKGREN2") 
  ceil("FLAT18") 
  left(48)
  right(176)
  right(176)
  right(48)
  sectortype(9,0)
  rightsector(48,176,144) -- Secret
  sectortype(0,0)


-- Alcove off corridor

  movestep(80,-848)
  ceil("CEIL3_3") 
  floor("FLOOR3_3") 
  mid("BRONZE2") 
  turnaround
  xoff(32)
  eleft(24)
  xoff(0)
  mid("TEKWALL6") 
  eright(40)
  xoff(56)
  straight(64)
  xoff(120)
  eright(96)
  xoff(0)
  top("TEKWALL6") 
  straight(64)
  xoff(64)
  eright(96)
  xoff(200)
  straight(64)
  xoff(8)
  eright(40)
  xoff(0)
  mid("BRONZE2") 
  eleft(24)
  rightsector(56,184,192)

  movestep(-224,96)
  ceil("FLAT20")
  mid("DOORTRAK") 
  straight(-8)
  top("SPACEW3") 
  left(64)
  right(8)
  sectortype(0,3)
  rightsector(56,56,144) -- Remote-activated door
  sectortype(0,0)

  movestep(-8,64)
  mid("TEKGREN1") 
  ceil("CEIL3_3") 
  step(-24,59)
  straight(-64)
  step(-90,-91)
  step(90,-91)
  straight(64)
  step(24,59)
  sectortype(9,0)
  rightsector(56,184,144) -- Secret
  sectortype(0,0)


-- BIG ROOM

  movestep(296,-608)
  mid("ASHWALL3") 
  top("ASHWALL3") 
  ceil("CEIL3_1") 
  floor("RROCK09") 
  straight(-512)
  straight(-64)
  step(-128,-64)
  impassable midtex mid("BRNSMAL1") 
  left(64) impassable midtex
  mid("ASHWALL3") 
  straight(192)
  linetype(1,0)
  straight(64) -- Door to Imp closet
  linetype(0,0)
  step(128,64)
  right(96)
  straight(64)
  right(40)
  mid("BROWN1") 
  right(24)
  eleft(24)
  straight(32)
  eleft(24)
  straight(32)
  bot("BROWN1") 
  top("STEP2") 
  step(24,72)
  step(64,32)
  step(40,32)
  step(24,64)
  step(64,64)
  step(64,24)
  step(88,-16)
  step(16,-40)
  step(-88,-40)
  step(-80,-104)
  left(40)
  step(48,24)
  right(32)
  eleft(24)
  straight(32)
  eleft(24)
  straight(24)
  mid("ASHWALL3") 
  right(40)
  right(360)
  step(128,184)
  xoff(32)
  bot("SW1BRCOM") 
  linetype(62,4)
  right(64) -- Switch to lower platform
  linetype(0,0)
  xoff(0)
  step(200,136)
  rightsector(40,232,128)

-- Octagons

  movestep(-192,32)
  eright(32)
  straight(64)
  eright(32)
  straight(64)
  eright(32)
  straight(64)
  eright(32)
  straight(64)
  innerrightsector(40,232,176)

  popsector
  movestep(64,512)
  eright(32)
  straight(64)
  eright(32)
  straight(64)
  eright(32)
  straight(64)
  eright(32)
  straight(64)
  innerrightsector(40,232,176)

  bot("BROWNGRN") 
  top("BROWN96") 
  floor("CEIL1_2") 
  ceil("CEIL1_3") 
  movestep(-64,32)
  ibox(72,216,176,64,64)
  popsector
  movestep(0,-512)
  linetype(2,3)
  straight(-64) -- Walkover switch to raise concealed door
  linetype(0,0)
  right(64)
  left(64)
  left(64)
  innerleftsector(72,216,176)


-- Platform switch for outside door

  movestep(200,-72)
  mid("BROWN96")   
  bot("BROWN96") 
  ceil("CEIL3_1") 
  floor("FLAT5_5")
  straight(120)
  linetype(31,0)
  right(64) -- Door
  linetype(0,0)
  right(120)
  sectortype(0,4)
  rightsector(152,232,128)
  sectortype(0,0)

  movestep(-120,64)
  ceil("FLAT10") 
  mid("DOORTRAK") 
  unpegged
  straight(-8)
  unpegged
  xoff(64)
  left(64)
  xoff(0)
  unpegged
  right(8)
  unpegged
  rightsector(152,152,128)

  movestep(-8,64)
  mid("BROWN96") 
  ceil("FLOOR0_2") 
  yoff(8)
  straight(-120)
  mid("SW1BRCOM") 
  xoff(32)
  linetype(103,5)
  left(64) -- Switch, opens door to outside secret
  linetype(0,0)
  xoff(0)
  mid("BROWN96") 
  right(120)
  sectortype(9,0)
  rightsector(152,256,128) -- Secret
  sectortype(0,0)
  yoff(0)


-- More of BIG ROOM

  movestep(624,128)
  mid("BROWN1") 
  bot("BROWN1") 
  top("STEP2") 
  ceil("CEIL3_1") 
  floor("FLOOR5_4") 
  yoff(120)
  step(24,24)
  yoff(0)
  step(24,-48)
  step(48,-24)
  straight(64)
  step(40,32)
  step(16,40)
  yoff(120)
  step(24,-24)
  yoff(0)
  leftsector(56,240,144)

  movestep(-24,24)
  top("ASHWALL3") 
  floor("FLAT5") 
  yoff(112)
  right(32)
  yoff(0)
  right(192)
  yoff(112)
  right(32)
  yoff(0)
  rightsector(72,248,160)

  movestep(-32,192)
  mid("LITE5") 
  top("BROWNGRN") 
  bot("BROWNGRN") 
  ceil("CEIL5_2") 
  floor("CEIL5_2") 
  straight(-16)
  impassable left(192) impassable
  right(16)
  rightsector(96,192,176)


-- Imp cages

  movestep(384,448)
  mid("BROWN96") 
  bot("BROWN96") 
  ceil("FLOOR7_1") 
  floor("RROCK09") 
  right(128)
  right(64)
  unpegged
  right(8)
  unpegged
  straight(120)
  rightsector(40,104,128)

  movestep(0,-256)
  ceil("FLAT10") 
  mid("DOORTRAK") 
  unpegged
  straight(-8)
  unpegged
  top("PIPE4") 
  linetype(1,0)
  right(64) -- Door
  linetype(0,0)
  unpegged
  left(8)
  unpegged
  leftsector(40,40,128)

  movestep(-8,-64)
  mid("BROWN96") 
  straight(-120)
  right(64)
  unpegged
  left(8)
  unpegged
  straight(112)
  sectortype(9,0)
  leftsector(40,104,128) -- Secret
  sectortype(0,0)

  movestep(-112,0)
  right(192)
  movestep(0,8)
  straight(-192)
  rightsector(96,104,0)


-- Exit

  movestep(320,-320)
  ceil("CEIL5_1") 
  straight(64)
  right(64)
  right(64)
  rightsector(40,112,128)

  movestep(-64,64)
  mid("EXITDOOR") 
  top("EXITDOOR") 
  xoff(64)
  straight(-32)
  xoff(0)
  linetype(1,0)
  left(64) -- Exit door
  linetype(0,0)
  xoff(88)
  right(32)
  xoff(0)
  rightsector(40,112,192)
  
  movestep(-8,16)
  top("EXITSIGN") 
  ceil("CEIL5_2") 
  xoff(32)
  straight(-8)
  xoff(0)
  right(32)
  xoff(32)
  left(8)
  xoff(0)
  left(32)
  innerleftsector(40,96,192)

  turnaround
  movestep(48,32)
  mid("BROVINE2") 
  ceil("CEIL5_1") 
  step(64,32)
  xoff(72)
  right(64)
  xoff(136)
  eright(64)
  xoff(0)
  linetype(11,0)
  mid("SW1BRNGN") 
  yoff(56)
  straight(64) -- Exit switch
  yoff(0)
  linetype(0,0)
  mid("BROVINE2") 
  eright(64)
  xoff(91)
  straight(64)
  xoff(155)
  step(32,64)
  xoff(0)
  top("EXITDOOR") 
  linetype(1,0)
  right(64) -- Door
  linetype(0,0)
  rightsector(40,112,192)

  ceil("FLAT20")
  mid("DOORTRAK") 
  unpegged
  left(8)
  step(0,-64)
  straight(-8)
  unpegged
  leftsector(40,40,192)

-- The Great Outdoors

  movestep(616,32)
  mid("DOORTRAK") 
  floor("FLAT1_1") 
  ceil("FLOOR7_1") 
  top("BROWNGRN") 
  bot("BROWNGRN") 
  straight(24)
  right(72)
  step(-8,24)
  sectortype(0,5)
  rightsector(40,40,176) -- Remote-activated door
  sectortype(0,0)

  movestep(8,-24)
  ceil("FLOOR7_1") 
  step(-32,-40)
  step(-40,40)
  leftsector(16,128,192)

  ceil("F_SKY1") 
  bot("BROWN96") 
  step(-32,-40)
  eleft(64)
  right(64)
  step(40,64)
  step(-40,64)
  mid("BROWNGRN") 
  step(-24,-24)
  rightsector(16,256,224)

  movestep(24,24)
  floor("FLAT1_2")   
  right(48)
  left(192)
  left(48)
  eleft(192)
  straight(192)
  step(80,-168)
  straight(-176)
  leftsector(-8,256,224)

  movestep(176,0)
  floor("GRASS1") 
  bot("BROWNHUG") 
  step(112,-88)
  step(64,128)
  right(256)
  step(392,256)
  step(64,512)
  step(-72,448)
  straight(-512)
  step(-168,-160)
  left(392)
  eleft(24)
  sectortype(9,0)
  rightsector(-32,256,224) -- Secret
  sectortype(0,0)

  movestep(64,576)
  bot("BROWNGRN") 
  floor("FWATER1") 
  step(64,80)
  step(-168,152)
  step(-296,32)
  step(-576,-280)
  step(-208,-744)
  step(288,-456)
  step(128,64)
  rightsector(-40,256,224)

  movestep(-128,-64)
  floor("GRASS1") 
  bot("STONE7") 
  step(-256,-160)
  step(-176,208)
  right(1168)
  step(432,-872)
  left(840)
  step(-320,-352)
  leftsector(24,256,224)

  movestep(320,352)
  straight(640)
  step(-256,256)
  straight(-1200)
  step(-1056,-528)
  left(1312)
  step(640,224)
  right(112)
  right(416)
  rightsector(24,24,224)
}
