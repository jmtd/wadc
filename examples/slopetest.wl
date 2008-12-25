#"standard.h"
#"zdoom.h"

main {
  undefx
  twice(left(128))
  mirror(left(128))   -- for fun :)
  sloped(1,2,left(128))
  leftsector(0, 128, 128)
  quad(right(128))
  rightsector(32, 96, 128)
  thing
  movestep(0, -128)
  slopedarch(128, 8, 16, 96, 0, 0, 96, 128, unpegged)
}

