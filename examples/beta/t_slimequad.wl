#"standard.h"
#"usepipes.wl"

main {

  !usepipes
  move(-64) rotright -- control sectors can extend from here
  controlinit
  ^usepipes

  set("slime1", onew)
  slimeinit(get("slime1"), 0, 128, 120, 24, "SLIME05", "WATERMAP", 80)

  unpegged

  set("lifttag", oget(oget(get("slime"),"whandle"), "watertag"))

  pushpop(movestep(64,64) thing)
  slimecorridor(128)
  slimelift(
	get("slime1"),
	0, -- east
	0, -- west
        get("lifttag")
  )

  -- last sector was the ibox...
  control(
    forcesector(lastsector)
    box(0,0,0, 8,8)
    move(8)
    box(64,128,0, 8,8)
    move(16)
  )

  slimeswitch(128, 102, get("lifttag"))
}
