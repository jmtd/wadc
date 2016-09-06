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
 
  box(0, 136, 140, y, 192)

  pushpop(     movestep(128,56)  corridor_light )
  pushpop(     movestep(320,56)  corridor_light )

  movestep(0,192)

  fori(0,3,
    box(0, sub(120,mul(i,16)), 140, y, 16)

    movestep(0,16)
    xoff(mul(add(1,i),16))
  )
}

corridor_light {
    top("-")
    quad(
      straight(64)
      curve(8,8,5,0)
    )
    innerrightsector(0,1036,150)

    top("METAL")
    movestep(0,8)
    ceil("CEIL1_2")
    ibox(0,112,160, 64,64)
    twice(popsector)
}
