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

  -- cut out space for a light every 128px
  pushpop(
    fori(0, div(y,192),
      box(-16, 136, 140, 128, 80)
      move(128)
      box(-16, 136, 140, 64, 64)
      move(64)
    )
  )
  movestep(0,80)

   
  ceil("CEIL5_2")

  pushpop(
    fori(0, div(y,192),
      box(-16, 116, 140, 128, 32)
      movestep(128,-16)
      box(-16, 116, 140, 64, 32)
      movestep(64,16)
    )
  )
  movestep(0,32)


  ceil("RROCK10")
  box(-16, 136, 140, y, 80) movestep(0,80)
  top("BRICK7")

  -- TLITE6_1

  fori(0,3,
    box(0, sub(120,mul(i,16)), 140, y, 16)

    movestep(0,16)
    xoff(mul(add(1,i),16))
  )
}

