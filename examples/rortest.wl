#"standard.h"

main {
  box(0,128,128,128,256)
  movestep(0,-128)
  box(0,256,128,256,128)
  movestep(160,128)
  box(0,256,128,96,256)
  movestep(-128,64)
  box(160,256,128,128,128)
}