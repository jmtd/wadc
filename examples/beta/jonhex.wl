#"standard.h"


hex(s) {

  step(64,0)
  step(32,-56)
  step(-32,-56)
  step(-64,0)
  step(-32,56)
  step(32,56)
  s
}
noop { move(0) }

flip(x) { eq(x,-1) ? 1 : -1 }

jitter { 0 | 8 | -8 | 16 | -16 }

hexes(w, h) {
 
  set("hexes", 1)

  for(1, h,

    !hexes
    for(1, w,
      print("hi")
      hex( leftsector(jitter, add(128, jitter), 128))
      movestep(0,112) -- horizontal spacing
    )
    ^hexes
    movestep(96,mul(get("hexes"), 56)) -- vertical spacing
    set("hexes", mul(-1, get("hexes")))
  )

}

main {
  pushpop( movestep(32,32) thing )
  
  hexes(16,8)

}
