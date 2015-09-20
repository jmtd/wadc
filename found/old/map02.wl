#"standard.h"
#"basic.h"

room { introom({ 64 | 96 | 128 }) }

introom(x) {

--  wall({ "ASHWALL6" | "BIGBRIK1" | "BRICK10" | "BRICK12" | "BRONZE1" })
--  floor({ "FLOOR4_5" | "TLITE6_5" | "FLAT10" | "NUKAGE1" | "DEM1_6" })
--  ceil({ "SLIME14" | "FLAT5_1" | "FLAT3" })

  box({ -24 | -16 | -32 },                     -- floor
      { 128 | 144 | 160 | 176 },      -- ceiling
      { 96 | 128 | 160  },  -- light
      x,                              -- x
      { 160 | 192 })      -- y

  move(x)

  step(0,{ -16 | 32 | -32 | 16 })

}
vary_16(x) { { x | sub(x,8) | add(x,8) } }

slimecorridor(f,c,l,x,y) {
  for(1,div(x,32),
      slimecorridor_int(f,c,l,32,y)
      move(32)
     )
}
slimecorridor_int(f,c,l,x,y) {
  set("slint_l",vary_16(l))
  set("slint_f",vary_16(f))

  !slint
  box(get("slint_f"),sub(c,32),get("slint_l"),x,32)
  movestep(0,32)
  box(get("slint_f"),c,get("slint_l"),x,sub(y,64))
  movestep(0,sub(y,64))
  box(get("slint_f"),sub(c,32),get("slint_l"),x,32)
  ^slint
}

-- returns a semi-random integer between x and y
-- probably some edge-case issues
range(x,y) {
  eq(x,y) ? x : { 
    lessthaneq(y,x) ? range(y,x) : 
      { range(x,add(x,div(sub(y,x),2)))        -- x -> midpoint
      | range(add(1,add(x,div(sub(y,x),2))),y) -- midpoint+1 -> y
      }
  }
}

main {
  print(range(1,10))
  sectordefaults(0,128,160,256)
  unpegged

  box(0,128,160,128,256)
  !beginningspot
  rotright
  playerstarts
  ^beginningspot
  move(128)
  move(192)
  box(0,128,160,128,256)

  -- arch experiment
  !archexp
  movestep(128,128)
  rotleft
  arch(72,128,256,64,0,160)
  ^archexp

  -- prepare for deep water
--  sectortype(0,$slime1)
  floor("SLIME05")

  -- water section
  -- replace with slimecorridor call
  move(-192)
  box(-24,152,160,192,256)

  -- section to the right
  !jmtd1
  movestep(192,256)
  rotright
--  for(1,8,room)
  slimecorridor(-24,152,160,512,192)

  -- section to the left
  ^jmtd1
  rotleft
--  for(1,8,room)
  slimecorridor(-24,152,160,512,192)


  -- deep water tag
  ^beginningspot
  movestep(-128,0)
  triple(right(64))
  linetype(242,$slime1)
  right(64)
  rightsector(-8,128,160)
  ^beginningspot movestep(512,128) 
  unpegged
  straight(128)
  rotright
  curve(128,-128,64,1)
  rotright
  straight(128)
  rotleft
  curve(-256,-256,128,1)  

  rightsector(0,128,160)
}
