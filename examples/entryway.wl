-- First attempt at re-creating MAP01 from Doom 2
-- more-or-less successfull IMHO

#"standard.h"
#"spawns.h"
#"monsters.h"
#"pickups.h"

--Flats

ceil1_2 { floor("CEIL1_2") }
ceil1_3 { ceil("CEIL1_3") }
ceil3_1 { ceil("CEIL3_1") }
ceil3_3 { ceil("CEIL3_3") }
ceil5_1 { ceil("CEIL5_1") }
ceil5_2 { ceil("CEIL5_2") }
floor5_2 { floor("CEIL5_2") }
sky { ceil("F_SKY1") }
flat1_1 { floor("FLAT1_1") }
flat1_2 { floor("FLAT1_2") }
flat2 { ceil("FLAT2") }
flat4 { floor("FLAT4") }
flat5 { floor("FLAT5") }
flat5_5 { floor("FLAT5_5") }
flat10 { ceil("FLAT10") }
flat18 { ceil("FLAT18") }
flat20 { ceil("FLAT20") }
flat23 { floor("FLAT23") }
mainfloor { floor("FLOOR0_1") }
floor0_2 { ceil("FLOOR0_2") }
floor1_1 { floor("FLOOR1_1") }
floor3_3 { floor("FLOOR3_3") }
mainceiling { ceil("FLOOR4_1") }
floor5_4 { floor("FLOOR5_4") }
floor7_1 { ceil("FLOOR7_1") }
water { floor("FWATER1") }
grass { floor("GRASS1") }
grnlite1 { ceil("GRNLITE1") }
rrock09 { floor("RROCK09") }
tlite6_4 { ceil("TLITE6_4") }

-- Textures

ashwall3 { mid("ASHWALL3") }
topashwall3 { top("ASHWALL3") }
bigdoor1 { top("BIGDOOR1") }
brnsmal1 { mid("BRNSMAL1") }
bronze1 { mid("BRONZE1") }
topbronze1 { top("BRONZE1") }
bronze2 { bot("BRONZE2") }
midbronze { mid("BRONZE2") }
brovine2 { mid("BROVINE2") }
brown1 { mid("BROWN1") }
lowbrown1 { bot("BROWN1") }
botbrn96 { bot("BROWN96") }
brown96 { mid("BROWN96") }
topbrn96 { top("BROWN96") }
botbrowngrn { bot("BROWNGRN") }
browngrn { mid("BROWNGRN") }
topbrowngrn { top("BROWNGRN") }
brownhug { bot("BROWNHUG") }
cement9 { bot("CEMENT9") }
compspan { bot("COMPSPAN") }
doortrak { mid("DOORTRAK") }
exitdoor { mid("EXITDOOR") }
topexit { top("EXITDOOR") }
exitsign { top("EXITSIGN") }
lite5 { mid("LITE5") }
midbars3 { mid("MIDBARS3") }
modwall3 { bot("MODWALL3") }
botpipe4 { bot("PIPE4") }
pipe4 { mid("PIPE4") }
toppipe4 { top("PIPE4") }
spacew3 { top("SPACEW3") }
spacew4 { bot("SPACEW4") }
step2 { bot("STEP2") }
topstep { top("STEP2") }
step6 { bot("STEP6") }
stone7 { bot("STONE7") }
support2 { mid("SUPPORT2") }
midsw1brcom { mid("SW1BRCOM") }
sw1brcom { bot("SW1BRCOM") }
sw1brngn { mid("SW1BRNGN") }
sw1comp { bot("SW1COMP") }
tekgren1 { mid("TEKGREN1") }
tekgren2 { mid("TEKGREN2") }
toptekgren { top("TEKGREN2") }
tekgren3 { mid("TEKGREN3") }
tekgren4 { mid("TEKGREN4") }
tekgren5 { mid("TEKGREN5") }
tekwall4 { top("TEKWALL4") }
midtek { mid("TEKWALL6") }
tekwall6 { top("TEKWALL6") }

tekwall(len,type) {
	{ eq(type,0) ? tekgren2 : tekgren5 }
	lessthaneq(len,64)
		? straight(len)
		: straight(64)
		  tekwall(sub(len,64), type ? 0 : 1)
}

main {

  mainfloor
  mainceiling
  pipe4
  toppipe4
  left(64)
  eright(128)
  step(320,64)
  right(64)
  step2
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
  botpipe4
  straight(256)
  unpegged
  rightsector(8,264,128)

  movestep(0,128)
  bronze2
  ibox(264,264,0,64,64)
  popsector
  movestep(-320,0)
  ibox(264,264,0,64,64)

  movestep(64,-128)
  bronze1
  topbronze1
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
  topbrowngrn
  right(192)
  right(256)
  eright(64)
  rightsector(56,136,96)

-- Outside area

  movestep(128,320)
  turnaround
  sky
  midbars3 -- Not appearing in map
  bronze2
  unpegged
  step(128,-128)
  step(192,64)
  right(64)
  unpegged
  browngrn
  right(128)
  straight(192)
  rightsector(56,264,128)

  grass
  step(320,16)
  browngrn
  cement9
  right(512)
  step(160,448)
  step(-256,448)
  straight(-368)
  step(-48,64)
  step(-16,-320)
  rightsector(8,264,224)

  movestep(16,-640)
  flat4
  browngrn
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
  mainfloor
  mainceiling
  pipe4
  step2
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
  toppipe4
  straight(128)
  xoff(0)
  rightsector(48,264,208) -- top step

-- Main corridor

  movestep(-128,0)
  floor3_3
  grnlite1
  support2
  xoff(4)
  left(16)
  tekgren2
  xoff(16)
  straight(48)
  xoff(0)
  tekwall(mul(5,64), 1)
  tekgren4
  right(64)
  tekwall(128,0)
  tekgren3
  straight(64)
  unpegged
  tekwall4
  straight(128)
  unpegged
  tekgren3
  straight(64)
  tekwall(mul(3,64),0)
  unpegged
  tekwall6
  right(128)
  unpegged
  right(64)
  straight(128)
  tekwall(mul(5,64), 0)
  tekgren5
  left(64)
  tekwall(128,0)
  tekgren2
  straight(48)
  support2
  xoff(4)
  straight(16)
  xoff(0)
  rightsector(56,128,224)

  movestep(-256,-448)
  tekwall(256,0)
  right(128)
  tekgren5
  right(64)
  tekgren2
  straight(64)
  tekgren5
  straight(64)
  tekgren2
  straight(64)
  rightsector(56,128,224)
  
  movestep(-256,128)
  turnaround
  straight(64)
  tekgren5
  straight(64)
  tekgren2
  straight(64)
  tekgren5
  straight(64)
  tekgren2
  straight(48)
  support2
  xoff(4)
  straight(16)
  xoff(0)
  unpegged
  topashwall3
  step6
  step(64,128)
  unpegged
  turnaround
  xoff(4)
  straight(16)
  tekgren4
  xoff(16)
  straight(48)
  xoff(0)
  tekgren2
  straight(64)
  tekgren5
  straight(64)
  tekgren2
  straight(64)
  tekgren5
  straight(64)
  tekgren2
  straight(64)
  rightsector(56,128,224)

  movestep(384,-192)
  tekgren2
  straight(128)
  bigdoor1
  linetype(31,0)
  right(128) -- Door
  linetype(0,0)
  right(128)
  rightsector(56,128,160)


-- North rooms

  movestep(-128,128)
  flat20
  floor3_3
  unpegged
  doortrak
  straight(-8)
  bigdoor1
  left(128)
  right(8)
  unpegged
  rightsector(56,56,224)

  movestep(-8,128)
  tlite6_4
  toptekgren
  compspan
  tekgren2
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
  flat18
  floor1_1
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
  flat18
  ibox(48,240,224,336,528)
  movestep(8,8)
  flat2
  spacew3
  yoff(64)
  ibox(48,176,224,320,512)
  yoff(0)
  movestep(129,320)
  spacew4
  ibox(240,240,0,62,64)
  popsector
  flat23
  movestep(63,0)
  spacew3
  modwall3
  yoff(64)
  sectortype(0,1)
  ibox(112,176,224,64,128)
  popsector
  movestep(-64,0)
  sw1comp
  linetype(103,2)
  straight(-64)
  linetype(0,0)
  modwall3
  right(128)
  left(64)
  left(128)
  innerleftsector(112,176,224) -- Switch reveals secret
  sectortype(0,0)
  yoff(0)
  popsector
  movestep(128,1)
  spacew4
  ibox(240,240,0,64,62)
  popsector
  movestep(0,-65)
  modwall3
  yoff(64)
  sectortype(0,1)
  ibox(112,176,224,128,64)
  popsector
  movestep(0,128)
  sw1comp
  linetype(102,1)
  right(64)
  linetype(0,0)
  modwall3
  left(128)
  left(64)
  left(128)
  innerleftsector(112,176,224) -- Switch lowers pedestals
  sectortype(0,0)
  yoff(0)

-- Secret

  movestep(320,-256)
  doortrak
  flat20
  floor1_1
  unpegged
  step(16,-16)
  unpegged
  toptekgren
  step(128,128)
  unpegged
  step(-16,16)
  unpegged
  sectortype(0,2)
  rightsector(48,48,144) -- Remote-activated door
  sectortype(0,0)
  movestep(-112,-144)
  tekgren2
  flat18
  left(48)
  right(176)
  right(176)
  right(48)
  sectortype(9,0)
  rightsector(48,176,144) -- Secret
  sectortype(0,0)


-- Alcove off corridor

  movestep(80,-848)
  ceil3_3
  floor3_3
  midbronze
  turnaround
  xoff(32)
  eleft(24)
  xoff(0)
  midtek
  eright(40)
  xoff(56)
  straight(64)
  xoff(120)
  eright(96)
  xoff(0)
  tekwall6
  straight(64)
  xoff(64)
  eright(96)
  xoff(200)
  straight(64)
  xoff(8)
  eright(40)
  xoff(0)
  midbronze
  eleft(24)
  rightsector(56,184,192)

  movestep(-224,96)
  flat20
  doortrak
  straight(-8)
  spacew3
  left(64)
  right(8)
  sectortype(0,3)
  rightsector(56,56,144) -- Remote-activated door
  sectortype(0,0)

  movestep(-8,64)
  tekgren1
  ceil3_3
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
  ashwall3
  topashwall3
  ceil3_1
  rrock09
  straight(-512)
  straight(-64)
  step(-128,-64)
  brnsmal1 -- Not appearing in map
  left(64)
  ashwall3
  straight(192)
  linetype(1,0)
  straight(64) -- Door to Imp closet
  linetype(0,0)
  step(128,64)
  right(96)
  straight(64)
  right(40)
  brown1
  right(24)
  eleft(24)
  straight(32)
  eleft(24)
  straight(32)
  lowbrown1
  topstep
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
  ashwall3
  right(40)
  right(360)
  step(128,184)
  xoff(32)
  sw1brcom
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

  botbrowngrn
  topbrn96
  ceil1_2
  ceil1_3
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
  brown96  
  botbrn96
  ceil3_1
  flat5_5
  straight(120)
  linetype(31,0)
  right(64) -- Door
  linetype(0,0)
  right(120)
  sectortype(0,4)
  rightsector(152,232,128)
  sectortype(0,0)

  movestep(-120,64)
  flat10
  doortrak
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
  brown96
  floor0_2
  yoff(8)
  straight(-120)
  midsw1brcom
  xoff(32)
  linetype(103,5)
  left(64) -- Switch, opens door to outside secret
  linetype(0,0)
  xoff(0)
  brown96
  right(120)
  sectortype(9,0)
  rightsector(152,256,128) -- Secret
  sectortype(0,0)
  yoff(0)


-- More of BIG ROOM

  movestep(624,128)
  brown1
  lowbrown1
  topstep
  ceil3_1
  floor5_4
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
  topashwall3
  flat5
  yoff(112)
  right(32)
  yoff(0)
  right(192)
  yoff(112)
  right(32)
  yoff(0)
  rightsector(72,248,160)

  movestep(-32,192)
  lite5
  topbrowngrn
  botbrowngrn
  ceil5_2
  floor5_2
  straight(-16)
  left(192)
  right(16)
  rightsector(96,192,176)


-- Imp cages

  movestep(384,448)
  brown96
  botbrn96
  floor7_1
  rrock09
  right(128)
  right(64)
  unpegged
  right(8)
  unpegged
  straight(120)
  rightsector(40,104,128)

  movestep(0,-256)
  flat10
  doortrak
  unpegged
  straight(-8)
  unpegged
  toppipe4
  linetype(1,0)
  right(64) -- Door
  linetype(0,0)
  unpegged
  left(8)
  unpegged
  leftsector(40,40,128)

  movestep(-8,-64)
  brown96
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
  ceil5_1
  straight(64)
  right(64)
  right(64)
  rightsector(40,112,128)

  movestep(-64,64)
  exitdoor
  topexit
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
  exitsign
  ceil5_2
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
  brovine2
  ceil5_1
  step(64,32)
  xoff(72)
  right(64)
  xoff(136)
  eright(64)
  xoff(0)
  linetype(11,0)
  sw1brngn
  yoff(56)
  straight(64) -- Exit switch
  yoff(0)
  linetype(0,0)
  brovine2
  eright(64)
  xoff(91)
  straight(64)
  xoff(155)
  step(32,64)
  xoff(0)
  topexit
  linetype(1,0)
  right(64) -- Door
  linetype(0,0)
  rightsector(40,112,192)

  flat20
  doortrak
  unpegged
  left(8)
  step(0,-64)
  straight(-8)
  unpegged
  leftsector(40,40,192)

-- The Great Outdoors

  movestep(616,32)
  doortrak
  flat1_1
  floor7_1
  topbrowngrn
  botbrowngrn
  straight(24)
  right(72)
  step(-8,24)
  sectortype(0,5)
  rightsector(40,40,176) -- Remote-activated door
  sectortype(0,0)

  movestep(8,-24)
  floor7_1
  step(-32,-40)
  step(-40,40)
  leftsector(16,128,192)

  sky
  botbrn96
  step(-32,-40)
  eleft(64)
  right(64)
  step(40,64)
  step(-40,64)
  browngrn
  step(-24,-24)
  rightsector(16,256,224)

  movestep(24,24)
  flat1_2  
  right(48)
  left(192)
  left(48)
  eleft(192)
  straight(192)
  step(80,-168)
  straight(-176)
  leftsector(-8,256,224)

  movestep(176,0)
  grass
  brownhug
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
  botbrowngrn
  water
  step(64,80)
  step(-168,152)
  step(-296,32)
  step(-576,-280)
  step(-208,-744)
  step(288,-456)
  step(128,64)
  rightsector(-40,256,224)

  movestep(-128,-64)
  grass
  stone7
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

/*

*/

}


