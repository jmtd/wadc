#"standard.h"
#"decoration.h"
#"monsters.h"
#"pickups.h"

main {
  mergesectors
  prunelines
  thing
  movestep(-32,56)
  hallway
  ceil("F_SKY1")
  rows(30,4)
  ^endrow
  movestep(96,add(56,mul(112,8)))
  rows(8,12)
  movestep(add(0,mul(96,-8)),add(0,mul(112,22)))
  rows(22,4)
  movestep(add(0,mul(96,-20)),0)
  rows(8,6)
  movestep(add(0,mul(96,-12)),add(0,mul(112,-8)))
  rows(8,4)
  ^endrow
  linetype(52,0)
  hallway
}

rows(x,y) {
  for(1,y,
    !rowstart
    row(x)
    ^rowstart
    movestep(96,-56)
    row(x)
    !endrow
    ^rowstart
    movestep(192,0)
  )
}

row(x) {
  for(1,x,
    hexagon
    movestep(0,-112)
  )
}

hallway {
  for(1,3,
    hex(
      floor("RROCK08")
      ceil("RROCK04")
      leftsector(16,128,64)
    )
    movestep(0,-112)
  )
}

hexagon {
  { base | base | base | base16 | basehi | pond | roof(160,96) | roof(128,64) | 0 | 0 }
}

base {
  hex(
    floor("GRASS2")
    leftsector(0,192,128)
    putinmiddle({ 1 | { formerhuman | { formersergeant | demon } } })
  )
}

base16 {
  hex(
    floor("RROCK19")
    leftsector(16,192,128)
    putinmiddle({ 1 | { shotgunshells | boxofshells
                      | stimpak | medikit
                      | { shotgun | doublebarreled | chainsaw | chaingun } } })
  )
}

basehi {
  hex(
    floor("RROCK20")
    leftsector(64,192,160)
    putinmiddle({ imp | formerhuman
                | largebrowntree | burnttree | stalagmite })
  )
}

pond {
  hex(
    floor("GRASS2")
    leftsector(0,192,128)
  )
  hexinner(
    floor("NUKAGE1")
    innerleftsector(-16,192,160)
  )
}

roof(c,l) {
  hex(
    floor("GRASS2")
    ceil("RROCK11")
    leftsector(0,c,l)
    ceil("F_SKY1")
  )
}

hex(s) {
  wall({ "TANROCK5" | "ZIMMER3" | "TANROCK4" | "ASHWALL3" | "ZIMMER5" })
  step(64,0)
  step(32,-56)
  step(-32,-56)
  step(-64,0)
  step(-32,56)
  step(32,56)
  s
}

hexinner(s) {
  wall("NUKE24")
  --unpegged
  movestep(0,-8)
  step(64,0)
  step(24,-48)
  step(-24,-48)
  step(-64,0)
  step(-24,48)
  step(24,48)
  --unpegged
  s
  movestep(0,8)
}

putinmiddle(x) {
  movestep(32,-56)
  { eq(x,1) ? 0 : x thing }
  movestep(-32,56)
}

