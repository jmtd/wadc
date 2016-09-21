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
boring2 { boring({formerhuman | formersergeant}) }

corridor {
    movestep(0,64)
    box(0,96,128,256,64)
    movestep(256,-64)
}

main {
    pushpop(movestep(32,32) thing {shotgun | chaingun} thing)
    triple(twice(boring2) rotright move(256))
    twice(boring2)
    corridor
    boring2
}
