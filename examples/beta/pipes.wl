/*
 * This is part of pipes.wl/usepipes.wl, an "Underhalls" tribute
 * I started in around 2006 and never finished.
 *                                                 -- jmtd
 */

#"standard.h"

slimetype(x,tag) {
  sectortype(0,tag)
  floor("SLIME01")
  x
  sectortype(0,0)
  floor("SLIME16")
}
slimemain(x) { slimetype(x,$slime1) }

-- normal corridor
slimecorridor(y) { _slimecorridor(y, get("slimefloor"), get("slimeceil"), get("slimelight")) }
_slimecorridor(y,f,c,l) {
  box(add(32,f),sub(c,32),l,y,32)
  movestep(0,sub(256,32))
  box(add(32,f),sub(c,32),l,y,32)
  movestep(0,mul(-1,sub(256,64)))

  slimemain( box(f,c,l,y,sub(256,64)) )

  movestep(y,-32)
}

-- corridor with exit ramps
slimeopening(y) { _slimeopening(y,get("slimefloor"),get("slimelight")) }
_slimeopening(y,f,l) {

  slimechoke
  move(sub(y,32))
  slimechoke
  move(mul(-1,y))


  box(add(32,f),add(96,f),l,sub(y,32),32)
  movestep(0,32)
  slimemain(box(add(16,f),add(128,f),l,sub(y,32),32))

  movestep(0,sub(256,96))
  right(32) left(sub(y,32)) left(32) left(sub(y,32)) 
  slimemain(leftsector(add(16,f),add(128,f),l))
  print("got this far")
  turnaround movestep(0,32)
  box(add(32,f),add(96,f),l,sub(y,32),32)
  movestep(0,mul(-1,sub(256,96)))

  slimemain( box(f,add(128,f),l,sub(y,32),sub(256,64)) )

  movestep(y,-64)
}

-- a curve to the right
slimecurve_r(f,l) {
  !omglol
  right(32) straight(192) straight(32)
  ^omglol 
  curve(add(128,mul(2,128)),add(128,mul(2,128)),64,1)
  ^omglol
  movestep(0,32)
  curve(add(96,mul(2,128)),add(96,mul(2,128)),64,1)
  ^omglol
  movestep(0,sub(256,32))
  curve(add(32,128),add(32,128),32,1)
  ^omglol
  movestep(0,256)
  curve(128,128,32,1)

  rotleft

  straight(32)
  leftsector(add(f,32),add(f,96),l)
  straight(sub(256,64))
  slimemain( leftsector(f,add(128,f),l) )
  straight(32)
  leftsector(add(f,32),add(f,96),l)

  rotright
}

-- a curve to the left
slimecurve_l() { _slimecurve(get("slimefloor"), get("slimeceil"), get("slimelight")) }
_slimecurve(f,c,l) {
  print("first bit")
  curve(128,mul(-1,128),32,1)
  rotright
  straight(32)
  !secondbit
  rotright
  curve(add(32,128),add(32,128),32,1)
  rotright
  straight(32)
  rightsector(add(32,f),sub(c,32),l)

  print("second bit")
  ^secondbit
  move(sub(256,64))
  !thirdbit
  rotright
  -- dodgy bit
  curve(add(96,mul(2,128)),add(96,mul(2,128)),32,1)
  rotright
  straight(sub(265,64))
  ^secondbit
  straight(sub(256,64))
  slimemain( rightsector(f,c,l) )

  print("third bit")
  ^thirdbit
  straight(32)
  rotright
  curve(add(128,mul(2,128)),add(128,mul(2,128)),32,1)
  rotright
  straight(32)
  rightsector(add(32,f),sub(c,32),l)

  ^secondbit
  rotleft
  movestep(0,-32)
}

scurve(f,c,l) { slimecurve_l | slimecurve_r(f,l) }

slimebars(tag) { 
  _slimebars(get("slimefloor"), get("slimeceil"),
             get("slimelight"), tag)
}
_slimebars(f,c,l,tag) {
  slimecorridor(32)
  !slimebars
  top("SUPPORT3")
  bot("-")
  sectortype(0,tag)
  movestep(-28,32)
  unpegged
  triple(
    movestep(0,30)
    xoff(0) straight(24)
    triple( xoff(0) right(24) )
    innerrightsector(f,f,l)
    popsector
    rotright
    movestep(0,24)
  )
  unpegged
  ^slimebars
  sectortype(0,0)
}
slimeswitch(y,tag) { 
  _slimeswitch(y,get("slimefloor"),add(128,get("slimefloor")),
               get("slimelight"),tag)
}
_slimeswitch(y,f,c,l,tag) {
  slimecorridor(y)
  popsector
  popsector

  -- switch
  pushpop(
    movestep(-64,24)
    rotleft
    linetype(103,tag)
    bot("SW1BRIK") xoff(16) yoff(40) right(32)
    linetype(0,0)
    bot("SHAWN2") left(8) left(32) left(8)
    floor("FLAT23")
    innerleftsector(64,sub(128,32),l)
  )
}

/*
 * slimecut - cut out a section of wall for adjoining a corridor to
 */
slimecut(y,f,l) {
  box(add(32,f),add(96,f),l,y,32)   -- left-hand ledge
  movestep(0,sub(256,32))

  -- recessed wall
  floor("SLIME01")
  sectortype(0,$slime2)
  box(sub(f,add(48,24)),add(96,f),l,y,32)

  -- two steps
  sectortype(0,$slime1)
  floor("SLIME01")
  left(32) right(y) right(32) right(y)
  rightsector(sub(f,48),add(f,128),l)
  rotright
  move(32)
  straight(32) right(y) right(32) right(y)
  rightsector(sub(f,24),add(f,128),l)
  turnaround
  movestep(64,32)
  floor("SLIME16")
  sectortype(0,0)

  movestep(-64,-192)

  -- main corridor
  sectortype(0,$slime1)
  floor("SLIME01")
  box(f,add(128,f),l,y,128)
  floor("SLIME16")
  sectortype(0,0)
  movestep(y,-32)
}

/*
 * slimesecret: puts a secret corridor on the side
 */
slimesecret(y,whatever) { 
  _slimesecret(y,get("slimefloor"),get("slimelight"),whatever)
}
_slimesecret(y,f,l,whatever) {
  slimecut(64,f,l)
  !slimesecretjump
  sectortype(0,$slime3)
  floor("SLIME01")

  -- thin bit
  movestep(-64,256) 
  unpegged straight(64) unpegged
  right(128) right(64) right(128)
  rightsector(sub(f,96), add(f,24), l)

  -- fat bit
  rotright
  movestep(-64,128)
  sectortype(0,$slime1)
  floor("SLIME01")
  box(sub(f,96),add(f,24), l, 256, 128)
  sectortype(0,0)

  pushpop( movestep(192,64) whatever )
  floor("SLIME16")
  sectortype(0,0)
  ^slimesecretjump

}

/*
 * initialise the slime stuff
 * TODO: parameterize the floor/ceiling heights
 *       into globals and use them for above fns
 */
slimeinit(f,c,l) {
  unpegged
  !slimeinit

  set("slimefloor",f)
  set("slimeceil", c) -- XXX very little uses this yet
  set("slimelight",l)
}

slimesplit(left, centre, right) { 
  _slimesplit(get("slimefloor"),get("slimelight"),
              left, centre, right)
}
_slimesplit(f,l, left, centre, right) {
  !slimesplitmarker
  right(32) straight(192) straight(32)

  ^slimesplitmarker 
  movestep(0,sub(256,32))
  curve(add(32,128),add(32,128),32,1)
  ^slimesplitmarker
  movestep(0,256)
  curve(128,128,32,1)

  ^slimesplitmarker 
  curve(128,-128,32,1)
  ^slimesplitmarker 
	movestep(0,32)
  curve(add(32,128),mul(-1,add(32,128)),32,1)
	rotright
	straight(-32)
  leftsector(add(f,32),add(f,96),l)
	movestep(32,0)

	straight(192) straight(32)

	rotright 
	box(add(32,f),add(96,f),l,512,32)
	movestep(512,32) rotright

	straight(192) 
  slimemain( rightsector(f,add(128,f),l) )

  -- centre hook, for detailing
  centre

  straight(32)
  rightsector(add(f,32),add(f,96),l)

	^slimesplitmarker
	movestep(128,-128)
	rotleft
	left

	^slimesplitmarker
	movestep(384,384)
	rotright
	right

    ^slimesplitmarker

}

-- slimechoke: walls move in a bit
slimechoke() { _slimechoke(get("slimefloor"),get("slimelight")) }
_slimechoke(f,l) {
  !slimechoke
  movestep(0,32)
  mid("METAL") top("METAL") bot("METAL")
  slimetype(box(f,add(72,f),l,32,sub(256,64)),$slime4 )
  movestep(0,-32)
  right(256)
  rotleft movestep(32,-256)
  right(256)
  ^slimechoke
  move(32)
}

-- slimebarcurve: just bars with curves after out of sight
-- XXX: floor/ceil needs parameterizing
slimefade() { _slimefade(get("slimefloor"), get("slimeceil"), get("slimelight")) }
_slimefade(f,c,l) {
  set("slimefade",0)
  for(1,15,
    _slimecorridor(16, f, c, sub(mul(8,15),mul(get("slimefade"),8)))
    set("slimefade",add(1,get("slimefade")))
  )
}

slimebarcurve(f,l) {
  slimebars(0)
  slimefade
  twice( slimecurve_r(0,0) )
}

-- WIP
-- need to rework slimesplit so that we can safely put inner sectors in the
-- middle bit, by re-ordering the drawing/sector creation
slime_downpipe {
  !slime_downpipe
  turnaround
  movestep(32, -320)

  -- WIP downpipe
  xoff(0)

  -- draw the outside of the pipe first
  quad( curve(64, 64, 8, 1) )
  innerrightsector(24, 64, get("slimelight")) -- XXX: needs sliming/watering

  -- contortion to add linedefs to the donut
  movestep(0,120)

  mid("SFALL1")
  xoff(0) yoff(-1)
   -- simple static scroller. Major drawback: we lose control of texture
   -- offsets for their primary purpose. Solution: use one of the more
   -- complex scrollers, with a control linedef.
   linetype(255,0)
    quad( curve(56, -56, 8, 0) )
   linetype(0,0)
  xoff(0) yoff(0)

  -- trick to create a donut-shaped sector with the sidedefs pointing out
  forcesector(lastsector)
  rightsector(0,0,0)

  ^slime_downpipe
}
