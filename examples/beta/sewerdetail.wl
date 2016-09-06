#"standard.h"
#"basic.h"
#"water.h"

main {
  doomexe("/Users/jon/Games/doom2/ZDoom.app/Contents/MacOS/zdoom")
  doomargs("-iwad /Users/jon/Games/doom2.wad -warp 1 -file")
  turnaround
  box(0,128,128,64,64) -- hack so water works, needs a sector!
  move(128)
  controlinit
  turnaround move(128)
  waterinit_fwater(16)

  place(64,64,thing)
  movestep(0,32)

unpegged

  fori(0,3,

    water(box(0, add(mul(i,16),72), 140, 256, 16),
      0,  add(mul(i,16),72))
    movestep(0,16)
    xoff(mul(add(1,i),16))
  )
 
  water(box(0, 136, 140, 256, 128), 0, 136)

  pushpop(
    top("METAL")
    movestep(128,26)

    water(
    quad(
      straight(64)
      curve(8,8,5,0)
    )
    innerrightsector(0,136,150)
, 0, 136)

    movestep(0,8)
    ceil("CEIL1_2")
    water(ibox(0,112,160, 64,64), 0, 112)
  )
  movestep(0,128)

  fori(0,3,
    water(box(0, sub(120,mul(i,16)), 140, 256, 16),
      0, sub(120,mul(i,16)))
    movestep(0,16)
    xoff(mul(add(1,i),16))
  )
}
