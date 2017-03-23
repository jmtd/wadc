#"standard.h"


hex(s) {
  step(64,0)
  step(32,56)
  step(-32,56)
  step(-64,0)
  step(-32,-56)
  step(32,-56)
  s
}


flip(x) { eq(x,-1) ? 1 : -1 }

jitter { 0 | 8 | -8 | 16 | -16 }

hexes(w, h) {
 
  set("hexes", 1)

  fori(1, h,

    !hexes
    for(1, w,
      print(cat(i,cat(",","y")))
      hex( rightsector(jitter, 256, 140))
      movestep(0,112) -- horizontal spacing
    )
    ^hexes
    movestep(96,mul(get("hexes"), 56)) -- vertical spacing
    set("hexes", mul(-1, get("hexes")))
  )

}

texrules {
  autotex("C", 0,    0, 0, "F_SKY1")
  autotex("F", 0,    0, 0, "MFLR8_2")
  autotex("F", 0,  984, 0, "SLIME01")
  autotex("F", 0,-1015, 0, "FLAT5_7")
  autotex("N", 0,    0, 0, "TANROCK5")
  autotex("L", 0,    0, 0, "TANROCK5")
}

main {
  texrules
  autotexall
  pushpop( movestep(32,32) thing )
  
  ceil("F_SKY1")
  hexes(16,8)

}
