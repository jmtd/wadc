#"pickups.h"
#"monsters.h"
#"spawns.h"
#"standard.h"

#"pipes.wl"
#"boring.wl"

usepipes {
  slimeinit(0, 128, 120)
  slime_control

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
    slimebarcurve(0,120),

    slime_downpipe,

    slimebars(0)
    slimefade
    twice( _slimecurve(0,0) )
  )


  impassable
  ^beginning_detail_left

  slimeopening(928) -- TODO: a less random figure
  slimeswitch(128,1)
  slimebars(1)
  pushpop( movestep(128,-128) rotleft slimechoke )
  slimecurve_l
  move(32)
  slimesecret(256,doublebarreled thing)
  pushpop(
    movestep(512,128)
    turnaround
    demon mute
    triple( thing move(128) )
    mute
  )
  slimecorridor(896)

  pushpop(movestep(384,384) rotright slimechoke )
  slimesplit( !tempmain, !donothing, !tempmain2 )
  ^tempmain2
  move(32) -- ?
  slimebarcurve(0,120)

  ^tempmain
  slimecorridor(128)

  -- we're going to drop down 192 units here, but first
  -- some detailing on the top-level
  !tempmain

  -- inaccessible area
  move(256)
  slimebars(0)
  slimecorridor(512)
  slimecurve_l
  slimecorridor(128)

  -- the lower floors. temp low ceiling for trail-off
  slimeinit(-192, add(-192,32), 120)

  ^tempmain
  movestep(256,256) rotleft !tempmain
  straight(256) left(256)
  !tempmain2
  rotright slimebars(0) slimefade popsector
  ^tempmain2
  left(256) left(256)
  leftsector(-192,128,120) rotright

  -- slimecorridor(128) fucksake.

}