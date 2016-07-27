#"standard.h"
#"monsters.h"
#"pickups.h"

boring(x) {
    box(0,128,160,256,256)
    pushpop(
      movestep(96, 96)
      ibox(24,128,200,64,64)
      movestep(32,32)
      x thing
    )
    move(256)
}

main {
    pushpop(movestep(32,32) thing)
    boring(shotgun)
    boring(formerhuman)
}
