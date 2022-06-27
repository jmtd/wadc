/*
 * hexagon.wl: random hexagon maze, as featured in the 10 Sectors Competition MAP32
 * part of WadC
 *
 * Copyright © 2000 Wouter van Oortmerssen
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"
#"decoration.h"
#"monsters.h"
#"pickups.h"

main {
  seed(rand(0,1337))
  mergesectors
  prunelines
  toggleflag(ambush)
  thing
  shotgun
  thing
  boxofshells
  thing
  movestep(-32,56)
  hallway
  movestep(0,784)
  ceil("F_SKY1")
  hex64
  movestep(768,448)
  hex64
  triple(movestep(-768,448) hex64)
  triple(movestep(-768,-448) hex64)
  triple(movestep(768,-448) hex64)
  movestep(768,-336)
  linetype(52,0)
  hallway
}

hex64 {
  !starthex64
  repeathex(hex16,4)
  ^starthex64
}

hex16 {
  !starthex16
  repeathex(hex4c,2)
  ^starthex16
}

hex4c {
  { { hex4 | { hex4 | { hex4 | { hex4 | bighexogon } } } } }
}

hex4 {  
  !starthex4
  repeathex(hexagon,1)
  ^starthex4
}


repeathex(sub,f) {
  sub
  movestep(0,mul(-112,f))
  sub
  movestep(mul(96,f),mul(56,f))
  sub
  movestep(mul(-192,f),0)
  sub
}

hallway {
  triple(
    hex(
      floor("RROCK08")
      ceil("RROCK04")
      leftsector(16,128,64)
    )
    movestep(96,56)
  )
}

hexagon {
  { base 
  | { base16 | roof(128,64) | roof(160,96) }
  | { 0 | pond | basehi }
  }
}

base {
  hex(
    floor("GRASS2")
    leftsector(0,192,128)
    { ultraviolence
      putinmiddle({ formerhuman
                  | imp
                  | { spectre
                    | lostsoul
                    | { heavyweapondude | cacodemon } 
                    } 
                  }
      )
      easy
    | putinmiddle({ formerhuman 
                  | { formersergeant | demon } 
                  }
      ) 
    }
  )
}

base16 {
  hex(
    floor("RROCK19")
    leftsector(16,192,128)
    putinmiddle({ 1
                | { stimpak | shotgunshells }
                | { boxofshells
                  | medikit
                  | { shotgun | doublebarreled | chainsaw | chaingun }
                  }
                }
    )
  )
}

basehi {
  hex(
    floor("RROCK20")
    leftsector(64,192,160)
    putinmiddle({ imp
                | formerhuman
                | largebrowntree
                | burnttree
                | stalagmite
                }
    )
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
    ultraviolence
    putinmiddle({ ammoclip | { shotgunshells | stimpak } })
    easy
  )
}

hex(s) {
  rndwall
  step(64,0)
  step(32,-56)
  step(-32,-56)
  step(-64,0)
  step(-32,56)
  step(32,56)
  s
}

rndwall {
  wall({ "TANROCK5" | "ZIMMER3" | "TANROCK4" | "ASHWALL3" | "ZIMMER5" })
}

hexinner(s) {
  wall("NUKE24")
  movestep(0,-8)
  step(64,0)
  step(24,-48)
  step(-24,-48)
  step(-64,0)
  step(-24,48)
  step(24,48)
  s
  movestep(0,8)
}

putinmiddle(x) {
  movestep(32,-56)
  { eq(x,1) ? 0 : x thing }
  movestep(-32,56)
}

bighexogon {
  { fountain   print("O")
  | crossthing print("+")
  | roundthing print("o")
  }
}

fountain {
  bighex(
   floor("GRASS2")
   leftsector(0,192,128)
   !startfountain
   movestep(32,-48)
   wall("BRICK7")
   quad(curve(64,-64,7,1))
   floor("FWATER1")
   innerleftsector(-16,192,128)
   movestep(0,-32)
   quad(curve(32,-32,5,1))
   floor("CEIL5_2")
   innerleftsector(32,192,128)
   movestep(0,-8)
   quad(curve(24,-24,3,1))
   floor("FWATER1")
   innerleftsector(-16,192,128)
   movestep(0,-24)
   burningbarrel
   thing
   ^startfountain 
  )
}

crossthing {
  bighex(
   floor("GRASS2")
   leftsector(0,192,128)
   !startcross
   movestep(0,-16)
   wall("NUKE24")
   quad(straight(64)
        left(64)
        right(64)
        rotleft
   )
   floor("NUKAGE1")
   innerleftsector(-16,192,160)
   movestep(16,-16)
   wall("BRICK10")
   quad(straight(32)
        movestep(-16,-16)
        shortredfirestick
        thing
        movestep(16,16)        
        left(64)
        right(64)
        rotleft
   )
   floor("RROCK19")
   innerleftsector(16,192,128)
   ^startcross
  )
}

roundthing {
  bighex(
   floor("GRASS2")
   leftsector(0,192,128)
   !startround
   movestep(32,-64)
   wall("BRICK7")
   quad(curve(48,-48,5,1))
   floor("RROCK19")
   innerleftsector(16,192,128)
   movestep(0,-16)
   quad(curve(32,-32,4,1))
   floor("CEIL5_2")
   innerleftsector(32,192,128)
   movestep(0,-32)
   shortgreenpillar
   thing
   ^startround 
  )
}

bighex(s) {
  rndwall
  twice(step(64,0)
        step(32,-56)
  )
  twice(step(-32,-56)
        step(-64,0)
  )
  step(-32,56)
  step(-64,0)
  step(-32,56)
  step(32,56)
  step(64,0)
  step(32,56)
  s
}

