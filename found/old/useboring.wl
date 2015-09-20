#"standard.h"
#"boring.wl"
#"monsters.h"

main {
  unpegged
  pushpop( movestep(64,64) thing )
  room(0,128,160,256,256)
  movestep(0,128)
  door(0,72,160)
  movestep(0,-128)
  room(32,128,136,384,128)
}
