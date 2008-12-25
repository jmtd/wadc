#"standard.h"
#"quaketextures.h"

main() {
  thing
  box4
  box4
  box4
  box4
}

box4 {
  box1
  box1
  box1
  box1
  rotleft
  movestep(288,-32)
}

box1 {
  straight(32)
  straight(64)
  straight(32)
  left(128)
  left(64)
  straight(64)
  left(32)
  straight(96)
  leftsector(0,128,128)

  right(16)
  rotleft
}
