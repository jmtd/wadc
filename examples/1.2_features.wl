#"standard.h"
#"monsters.h"
#"pickups.h"

main {
  thing movestep(-64,-64)
  box(0,192,160,512,add(256,128))

  revenant
  mid("MIDGRATE")

  movestep(64,128)
  ibox(24,128,160,128,128)
  pushpop( movestep(64,64) thing )

  popsector
  midtex
  impassable
  friendly

  movestep(256,0)
  ibox(24,128,160,128,128)
  pushpop( movestep(64,64) thing )
}
