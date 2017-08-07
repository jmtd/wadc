#"standard.h"

-- generates a corridor with every possible doom light level
-- each segment has a custom texture with a number on it corresponding
-- to the light level

-- units/tens/hundreds: given a number (light level), calculate patch
-- name and offset for each decimal number column

units(num) {
    addpatch(cat("WINUM", num), 24, 0)
}

tens(num) {
    addpatch(cat("WINUM", div(num, 10)), 12, 0)
    units(sub(num, mul(10, div(num, 10))))
}

hundreds(num) {
    addpatch(cat("WINUM", div(num, 100)), 0, 0)
    tens(sub(num, mul(100, div(num, 100))))
}

maketex(num) {
  texture(cat("LLEVL", num), 64, 128)
  addpatch("RW24_2", 0, 0)
  hundreds(num)
  mid(cat("LLEVL", num))
}

-- a basic box segment
mybox(floor,ceil,light,x,y) {
  maketex(get("llevel"))
  straight(x)
  mid("BRICK7")
  right(y)
  right(x)
  right(y)
  rightsector(floor,ceil,light)
  rotright
}

main {
  rotleft
  pushpop(
    movestep(32,32)
    thing
  )

  -- 32 possible light levels, 0-255, 0-7 = 1, etc.
  set("llevel", 0)
  for(1, 32,
    mybox(0, 128, get("llevel"), 64, 256)
    move(64)
    set ("llevel", add(get("llevel") , 8))
  )
}
