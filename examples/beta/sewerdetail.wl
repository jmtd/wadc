#"standard.h"
#"basic.h"

main {

  place(64,64,thing)

unpegged

  corridor(512)

}

corridor(y) {

  fori(0,3,

    box(0, add(mul(i,16),72), 140, y, 16)
    movestep(0,16)
    xoff(mul(add(1,i),16))
  )
 
  top("METAL")
  box(0, 136, 140, y, 80) movestep(0,80)
ceil("CEIL5_2")
  box(0, 116, 140, y, 32) movestep(0,32)
  box(0, 136, 140, y, 80) movestep(0,80)
  top("BRICK7")

  - TLITE6_1

  fori(0,3,
    box(0, sub(120,mul(i,16)), 140, y, 16)

    movestep(0,16)
    xoff(mul(add(1,i),16))
  )
}


