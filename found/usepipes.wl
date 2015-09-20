#"pickups.h"
#"monsters.h"
#"pipes.wl"
#"standard.h"
#"boring.wl"

usepipes {
  slimeinit(0,120)

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
   * now for the circular pipe tunnels
   */
  move(add(-32,-256))
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
  slimecorridor(768)

  pushpop(movestep(384,384) rotright slimechoke )
  slimesplit( !tempmain, !tempmain2 )
  ^tempmain2
  move(32)
  slimebarcurve(0,120)
  ^tempmain

  -- left branch
  slimecorridor(128) -- dual of bars
  pushpop( movestep(128,0) slimechoke )
  slimecorridor(128) -- dual of switch
  move(32)
  sectortype(17,0)
  slimecorridor(add(32,add(768,128)))  -- dual of opening
  sectortype(0,0)
  slimecorridor(128) -- dual of bars
  slimecorridor(128) -- dual of switch
  slimecurve_l

  slimecorridor(768)
  pushpop( movestep(64,0) slimechoke )
  slimecorridor(64) -- dual of slimesecret
  move(32)
  movestep(384,-128) rotright

  move(-256)
  slimebars(2)
  slimeswitch(128,2)

  slimesplit(!tempmain,move(0))
  ^tempmain
  slimebarcurve(0,120)

}
