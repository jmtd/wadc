#"standard.h"

main {
  thing
  movestep(64,64)
  quad(
    curve(128,256,10,1)
    curve(128,64,10,1)
    twice(curve(64,-64,10,1))
    triple(curve(64,128,20,1))
    twice(curve(16,-16,5,1))
  )
  rightsector(0,128,128)
}
