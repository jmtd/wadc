/*
 * This is part of pipes.wl/usepipes.wl, an "Underhalls" tribute
 * I started in around 2006 and never finished.
 *                                                 -- jmtd
 */
#"pickups.h"
#"monsters.h"
#"spawns.h"
#"standard.h"

#"pipes.wl"
#"boring.wl"

-- hack to avoid sprinkling get("slime1") all over _usepipes
usepipes {
  !usepipes
  move(-64) rotright -- control sectors can extend from here
  controlinit
  ^usepipes

  set("slime1", onew)
  slimeinit(get("slime1"), 0, 128, 120, 24, "SLIME05", "WATERMAP", 80, "AASHITTY")
  _usepipes(get("slime1"))
}
_usepipes(o) {
  unpegged
  set("slime1", o)

  /*
   * beginning rooms; preamble to pipes
   */
  pushpop( movestep(64,64) thing )
                    room(32,add(32,128),160,256,256)
  movestep(0,128)   door(32,add(32,72),160)
  movestep(0,-128)  room(32,128,136,128,384)
  move(256)         room(32,128,136,128,384)
  !oppositeentrance
  movestep(0,128)   bigdoor(32,add(32,72),160)
  movestep(0,-320)  
  

  rotleft quad( right(768) ) rotright
  twice(
		room(-512,256,160,256,256)
		move(256)
		room(-512,256,160,256,256)
		movestep(-768,512)
  )
  movestep(256,-256)
	straight(128)
  leftsector(32,256,160)

  ^oppositeentrance
  move(-128)
  rotright

  /*
   * now for the pipe tunnels
   */
  move(add(-32,-256))

  /*
   * unreachable detailing to the left
   */
  !beginning_detail_left
  turnaround movestep(0,-256)
  impassable
  slimebars(0)
  slimesplit(
    slimefade( twice( slimecurve_r )),

    slime_downpipe,

    slimebars(0)
    slimefade( twice( slimecurve_l ))
  )


  impassable
  ^beginning_detail_left
  control_carriage_return

  slimeopening(928) -- TODO: a less random figure
  slimeswitch(128,103,1)
  slimebars(1)
  pushpop( movestep(128,-128) rotleft slimechoke )
  slimecurve_l

  move(32)
  slimesecret(256,doublebarreled thing)
  control_carriage_return

  slimecorridor(864)
  -- monsters for the upper corridor
  pushpop(
    movestep(-256,128)
    turnaround
    demon toggleflag(ambush)
    triple( thing move(128) )
    toggleflag(ambush)
  )

  set("slime2", onew)
  slimeinit(get("slime2"), -256, -128, 150, 16, "SLIME05", "WATERMAP", 80, "AASHITTY")

  _slimelift(
    !east,
    /*west*/ slimebars(0) slimefade(slimecurve_r),
    -256, oget(o, "ceil"), oget(o, "light"),
    $sometag
  )

  -- last sector was the ibox...
  -- XXX some of the step shenanigans here need tidying up
  control(
    move(8)
    forcesector(lastsector)
    movestep(0,-8)
    box(0,0,0, 8,8) -- dummy
    move(-8)
    box(-232,128,0, 8,8) -- lift bottom height desired
    move(16)
    box(0,128,0, 8,8) -- floor height key
    movestep(16,8)
  )

  /*north*/ slimebars(0) slimefade(slimecurve_l)

  -- lower corridors
  control_carriage_return
  ^east
  slimecorridor(128)
  slimetrap(102, $sometag)
}
