#"standard.h"
#"quaketextures.h"

main {
  thing
  garden
}

garden {
  sky
  green
  !gst
  gardenpit
  straight(128)
  !mids
  movestep(0,-288)
  gardenpit
  ^mids
  rotleft
  move(736)
  left(128)
  leftsector(0,128,160)
  ^gst
  rotright
  move(288)
  chouter
  sidearea(1344)
  sidearea(480)
  sidearea(1344)
  sidearea(480)
}

sidearea(d) {
  eleft(128)
  straight(d)
  eleft(128)
  leftsector(0,128,160)
  rotright  
}

gardenpit {
  for(1,4,hedgeblock
          gardenstairs
          movestep(288,-448)
          rotright)
  move(256)
  straight(32)
  green
  leftsector(-96,128,128)
  movestep(448,288)
}

gardenstairs {
  !gs
  left(32)
  straight(96)
  ^gs
  stdescent(0,-96)
  ^gs
}

stdescent(h,max) {
  eq(h,max)
    ? 0
    : green
      straight(32)
      met8w
      !nextstep
      left(32)
      !midbit
      left(32)
      left(32)
      metfl
      leftsector(h,128,160)
      ^midbit
      eright(16)
      left(64)
      eleft(16)
      !midbit
      straight(32)
      stonefl
      leftsector(h,128,160)
      ^midbit
      right(32)
      left(32)
      left(32)
      metfl
      leftsector(h,128,160)
      ^nextstep
      stdescent(sub(h,16),max)
}

hedgeblock {
  green
  move(32)
  for(1,4,
    for(1,4,hedge(16) hedge(32))
    rotright
    move(32))
  right(32)
  left(32)
  water
  rightsector(8,128,192)
  movestep(-64,-32)
}

hedge(h) {
  straight(32)
  right(32)
  right(32)
  right(32)
  rightsector(h,128,240)
  rotright
  move(32)
}

