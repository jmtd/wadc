-- hi there
#"standard.h"
#"monsters.h"

-- normal corridor
corridor(x,y,f,c) {
  box(f,c,get("light"),y,x)
  move(y)
}

-- the sniper window with moving blinds/crushers
leftwindow() {
  movestep(32,-32)
  box(32,72,get("light"),add(64,128),8)
  movestep(0,8)

  !leftwindow
  mid("DOORTRAK")
  top("TEKLITE")
  sectortype(0, get("crushtype"))
  box(32,64,160,add(64,128),16)
  sectortype(0,0)
  ^leftwindow
  unpegged

  movestep(0,16)
  box(32,72,160,add(64,128),8)
}

  -- triggers for crushers
crushstart() {
    !crushstart
    linetype(25, get("crushtype"))
    ibox(0,160, get("light"), 64, 64)
    linetype(0,0)

    ^crushstart
}

main {

  undefx
  autotexall
  autotex("F", 0, 0, 0, "SLIME15")
  autotex("C", 0, 0, 0, "CEIL5_1")
  autotex("N", 0, 0, 0, "TEKGREN2")
  autotex("L", 0, 0, 0, "TEKGREN2")
  autotex("U", 0, 0, 0, "TEKGREN2")
  set("crushtype", 1)
  set("light", 128)

  !maintmp
  corridor(256,256,0,160)
  !maintmp2

  ^maintmp
  pushpop(
      movestep(64,64)
      crushstart
      movestep(32,32)
      thing
  )
  ^maintmp2

  pushpop( leftwindow )
  corridor(256,256,0,160)
  rotleft
  pushpop( leftwindow )
  move(-256)
  corridor(256,512,0,160)

  -- sniper room
  movestep(-256,-256) move(32) corridor(sub(256,32),sub(256,32),0,160)
  pushpop(
      movestep(-64,64)
      formersergeant thing
  )

  print("Done")
}
