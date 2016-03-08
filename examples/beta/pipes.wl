/*
 * This is part of pipes.wl/usepipes.wl, an "Underhalls" tribute
 * I started in around 2006 and never finished.
 *                                                 -- jmtd
 */

#"standard.h"
#"water.h"

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

  water(
    box(add(32,f),sub(c,32),l,y,32)
    movestep(0,sub(256,32))
    box(add(32,f),sub(c,32),l,y,32),
  add(32,f), sub(c,32))

  movestep(0,mul(-1,sub(256,64)))

  water( box(f,c,l,y,sub(256,64)), f, c )

  movestep(y,-32)
}

-- corridor with exit ramps
slimeopening(y) { _slimeopening(y,get("slimefloor"),get("slimelight")) }
_slimeopening(y,f,l) {

  slimechoke
  move(sub(y,32))
  slimechoke
  move(mul(-1,y))

  water(
      box(add(32,f),add(96,f),l,sub(y,32),32),
      add(32,f), add(96,f)
  )

  movestep(0,32)

  water(
    box(add(16,f),add(128,f),l,sub(y,32),32)

    movestep(0,sub(256,96))

    right(32) left(sub(y,32)) left(32) left(sub(y,32))
    leftsector(add(16,f),add(128,f),l),
    add(16,f), add(128,f)
  )

  turnaround movestep(0,32)

  water(
    box(add(32,f),add(96,f),l,sub(y,32),32),
    add(32,f), add(96,f)
  )

  movestep(0,mul(-1,sub(256,96)))

  water(
    box(f,add(128,f),l,sub(y,32),sub(256,64)),
    f, add(128,f)
  )

  movestep(y,-64)
}

-- a curve to the right
slimecurve_r { _slimecurve_r(get("slimefloor"), get("slimeceil"), get("slimelight")) }
_slimecurve_r(f,c,l) {
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
  water(
      leftsector(add(f,32),sub(c,32),l),
      add(f,32), sub(c,32)
  )
  water(
      straight(sub(256,64))
      leftsector(f,c,l),
      f, c
  )
  water(
      straight(32)
      leftsector(add(f,32),sub(c,32),l),
      add(f,32), sub(c,32)
  )

  rotright
}

-- a curve to the left
slimecurve_l { _slimecurve(get("slimefloor"), get("slimeceil"), get("slimelight")) }
_slimecurve(f,c,l) {
  curve(128,mul(-1,128),32,1)
  rotright
  straight(32)
  !secondbit
  rotright
  curve(add(32,128),add(32,128),32,1)
  rotright
  water(
    straight(32)
    rightsector(add(32,f),sub(c,32),l),
    add(32,f), sub(c,32)
  )
  ^secondbit
  move(sub(256,64))
  !thirdbit
  rotright
  -- dodgy bit
  curve(add(96,mul(2,128)),add(96,mul(2,128)),32,1)
  rotright
  straight(sub(265,64))
  ^secondbit
  water(
    straight(sub(256,64))
    rightsector(f,c,l)
    , f,c
  )

  ^thirdbit
  straight(32)
  rotright
  curve(add(128,mul(2,128)),add(128,mul(2,128)),32,1)
  rotright
  water(
    straight(32)
    rightsector(add(32,f),sub(c,32),l)
    , add(32,f), sub(c,32)
  )

  ^secondbit
  rotleft
  movestep(0,-32)
}

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
 * y  - length of corridor
 * nf - destination floor height
 */
biggest(a,b) { lessthaneq(a,b) ? b : a }
smallest(a,b){ lessthaneq(a,b) ? a : b }

-- return a floor height that moves towards nf from f in increments of 24
nextstep(f,nf) {
    eq(f,nf) ? f : { -- obvious case

        lessthaneq(f,nf) ? {
            -- f < nf
            smallest(nf, add(f,24))

        } : {
            -- f > nf
            biggest(nf, sub(f,24))
        }

    }
}

slimecut(y,nf) { _slimecut(y,nf,get("slimefloor"),get("slimelight")) }
_slimecut(y,nf,f,l) {
  move(y) !slimecut rotright

  -- left-hand ledge/rail
  water(
    box(add(32,f),add(96,f),l,32,y),
    add(32,f), sub(get("slimeceil"),32)
  )
  move(32)

  -- normal corridor floor, but shorter
  water(
    box(f,get("slimeceil"), l, 128, y),
    f,get("slimeceil")
  )
  move(128)

  -- three steps down/up: two in corridor, one in ledge/rail
  water(
    set("slimecut_stepheight", nextstep(f,nf))
    box(get("slimecut_stepheight"), get("slimeceil"),l,32,y) move(32)
    set("slimecut_stepheight", nextstep(get("slimecut_stepheight"),nf))
    box(get("slimecut_stepheight"), get("slimeceil"),l,32,y) move(32),
    f, get("slimeceil")
  )
  water(
    set("slimecut_stepheight", nextstep(get("slimecut_stepheight"),nf))
    box(get("slimecut_stepheight"), sub(get("slimeceil"),32),l,32,y) move(32),
    sub(f,72), sub(get("slimeceil"),32)
  )
  ^slimecut
}

/*
 * slimesecret: puts a secret corridor on the side
 * secret corridor is 96 units lower than base
 */
slimesecret_backup {
    set("slimefloor", sub(get("slimefloor"), 96))
    set("slimeceil", sub(get("slimeceil"), 96))
}
slimesecret_restore {
    set("slimefloor", add(get("slimefloor"), 96))
    set("slimeceil", add(get("slimeceil"), 96))
}
slimesecret(y,whatever) {
  _slimesecret(y,get("slimefloor"),get("slimelight"),whatever)
}
_slimesecret(y,f,l,whatever) {
  slimecut(64,sub(f,96)) -- tunnel will be -96
  !slimesecret_orig
  slimesecret_backup

  -- joining tunnel
  movestep(-64,256)
  water(
      unpegged straight(64) unpegged
      right(128) right(64) right(128)
      rightsector(f, get("slimeceil"), l),
      f, sub(get("slimeceil"), 8)
  )

  rotleft
  movestep(-64,-384) -- tunnel + width of corridor
  slimecut(64,f)
  turnaround movestep(64,-256)

  -- north detailing
  !slimesecret
  slimecorridor(256)
  slimebars(0)
  slimefade

  -- the treat
  ^slimesecret movestep(128,128) whatever

  -- south detailing
  ^slimesecret
  turnaround movestep(64,-256)
  slimecurve_l
  slimebars(0)
  slimecurve_l
  slimefade

  slimesecret_restore
  ^slimesecret_orig
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

-- XXX: we need a control sector helper
slimeinit_once {
  waterinit_fwater(add(24,get("slimefloor")))
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
  water(
    straight(-32)
    leftsector(add(f,32),add(f,96),l)
    , add(f,32), add(f,96)
  )
	movestep(32,0)

	straight(192) straight(32)

	rotright 
    water(
      box(add(32,f),add(96,f),l,512,32)
      , add(32,f), add(96,f)
    )
	movestep(512,32) rotright

    water(
      straight(192)
      rightsector(f,add(128,f),l)
      , f, add(128,f)
    )

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
  water(
      box(f,add(72,f),l,32,sub(256,64)),
      f, add(72, f)
  )
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
  twice( slimecurve_r )
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
  water(
    quad(curve(64, 64, 8, 1)) innerrightsector(0, 64, get("slimelight")),
    0, 64
  )

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

/*
 * slimequad - a four-way split for corridors
 * orientations assuming we're drawing northwards
 *   e,w - hooks for corridors to east and west
 *   s is assumed to be drawn prior to slimequad
 *   n is assumed to be handled after slimequad
 */
slimequad(e,w) { _slimequad(e,w,
  get("slimefloor"), get("slimeceil"), get("slimelight"))
}
_slimequad(east,west,f,c,l) {
  water(
    -- XXX: quad(...) fails; moving rotright before rightsector fails.
    triple( straight(32) straight(192) straight(32) rotright)
    straight(32) straight(192) straight(32)
    rightsector(f,c,l)
    rotright,
    f, c
  )
  !slimequad movestep(256,256) rotright east
  ^slimequad rotleft west
  ^slimequad movestep(256,0)
}
