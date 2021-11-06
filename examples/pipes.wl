/*
 * pipes.wl: an example of a sewer-like pattern, with curving corridor sections.
 * Also demonstrates fixing the random number generator with a given
 * seed.
 *
 * part of WadC
 *
 * Copyright © 2015-2017 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"

-- normal corridor
slimecorridor(y,f,c,l) {
  box(add(32,f),sub(c,32),l,y,32)
  movestep(0,32)
  box(f,c,l,y,sub(256,64))
  movestep(0,sub(256,64))
  box(add(32,f),sub(c,32),l,y,32)
  movestep(0,mul(-1,sub(256,32)))

  move(y)
}

-- a curve to the right
slimecurve_r(f,c,l) {
  !omglol
  curve(add(128,mul(2,128)),add(128,mul(2,128)),64,1)
  ^omglol
  movestep(0,32)
  curve(add(96,mul(2,128)),add(96,mul(2,128)),64,1)
  ^omglol
  movestep(0,sub(256,32))
  curve(add(32,128),add(32,128),32,1)
  ^omglol
  movestep(0,256)
  curve(128,128,32,1)

  rotleft

  straight(32)
  leftsector(add(f,32),sub(c,32),l)
  straight(sub(256,64))
  leftsector(f,c,l)
  straight(32)
  leftsector(add(f,32),sub(c,32),l)

  rotright
}

-- a curve to the left
slimecurve(f,c,l) {
  print("first bit")
  curve(128,mul(-1,128),32,1)
  rotright
  straight(32)
  !secondbit
  rotright
  curve(add(32,128),add(32,128),32,1)
  rotright
  straight(32)
  rightsector(add(32,f),sub(c,32),l)

  print("second bit")
  ^secondbit
  move(sub(256,64))
  !thirdbit
  rotright
  -- dodgy bit
  curve(add(96,mul(2,128)),add(96,mul(2,128)),32,1)
  rotright
  straight(sub(265,64))
  ^secondbit
  straight(sub(256,64))
  rightsector(f,c,l)

  print("third bit")
  ^thirdbit
  straight(32)
  rotright
  curve(add(128,mul(2,128)),add(128,mul(2,128)),32,1)
  rightsector(add(32,f),sub(c,32),l)

  ^secondbit
  rotleft
  movestep(0,-32)
}

scurve(f,c,l) { slimecurve(f,c,l) | slimecurve_r(f,c,l) }

main {

  seed(rand(0,14424))

  pushpop( movestep(64,64) thing )

  for(0,8,
    slimecorridor(256,0,128,160)
    scurve(0,128,160)
  )
}
