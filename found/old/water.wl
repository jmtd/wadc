#"standard.h"
#"basic.h"
#"decoration.h"

main {
  -- first room
  sectordefaults(0,128,140,256)
  rotright
  playerstarts
  movestep(0,-256)
  box(0,128,140,128,256)

  -- second room
  move(128)
  pushpop(
    move(192)
    box(0,128,140,256,256)
    pushpop2( 
      movestep(128,128) -- centre of water
      shorttechnolamp
      thing
      light(4,16)
    )
  )

  -- water area
  movestep(0,-256)
  floor("FWATER1")
  box(-24,144,120,192,768)
}
