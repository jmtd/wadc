#"standard.h"
#"basic.h"

main {

  place(64,64,thing)
  movestep(0,32)

unpegged

  doomexe("chocolate-doom")

  fori(0,3,

    box(0, add(mul(i,16),72), 140, 256, 16)
    movestep(0,16)
    xoff(mul(add(1,i),16))
  )
 
  box(0, 136, 140, 256, 128)

  pushpop(
    top("METAL")
    movestep(128,26)

    quad(
      straight(64)
      curve(8,8,5,0)
    )
    innerrightsector(0,136,150)

    movestep(0,8)
    ceil("CEIL1_2")
    ibox(0,112,160, 64,64)
  )
  movestep(0,128)

  fori(0,3,
    box(0, sub(120,mul(i,16)), 140, 256, 16)

    movestep(0,16)
    xoff(mul(add(1,i),16))
  )
}
