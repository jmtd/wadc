/*
 * choz.wl: A large approximation of a sphere with ZDoom slopes
 * part of WadC
 *
 * Copyright © 2001-2008 Wouter van Oortmerssen
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"

main {
  undefx
  thing
  movestep(0,-256)
  ceil("RROCK04")
  floor("RROCK04")
  quad(slopedarc_8(192, 8, 6, 64, 28, 192, 0, 0, 0, 128)
       movestep(192,-160)
       rotright
       slopedarc_8b(192, 8, 6, 64, 28, 192, 0, 0, 0, 128)
       movestep(24,-232))
  movestep(0,224)
  step(24,8)
  rightsector(-208,208,128)
}

-- below adapted from zdoom.h for dome purposes

delta(r, f, h) { div(sin(add(900,asin(sub(1024,mul(div(1024,f),r))))),div(1024,h)) }

slopedarc_8(x, y, y2, off, n, h, cur, floor, ceil, light) {
  eq(cur,n)
    ? 0
    : step(x,off)
      rotright
      unpeg(eright(y2) rotleft)
      linetypehexen(181, 1, 1, 0, 0 ,0)
      rotright
      step(sub(x,y2),sub(off,2))
      linetype(0,0)
      unpeg(right(y))
      rightsector(sub(floor, delta(cur, n, h)), add(ceil, delta(cur, n, h)), light)
      rotright
      movestep(0, y)
      slopedarc_8(sub(x,y2), y, y2, sub(off,2), n, h, add(cur,1), floor, ceil, light) 
}

slopedarc_8b(x, y, y2, off, n, h, cur, floor, ceil, light) {
  eq(cur,n)
    ? 0
    : step(x,sub(0,off))
      unpeg(right(y))
      linetypehexen(181, 1, 1, 0, 0 ,0)
      rotright
      step(sub(x,y2),sub(0,sub(off,2)))
      linetype(0,0)
      unpeg(eright(y2))
      rightsector(sub(floor, delta(cur, n, h)), add(ceil, delta(cur, n, h)), light)
      rotright
      movestep(y2, y2)
      slopedarc_8b(sub(x,y2), y, y2, sub(off,2), n, h, add(cur,1), floor, ceil, light) 
}
