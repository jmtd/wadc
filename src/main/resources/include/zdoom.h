/*
 * zdoom.h - part of WadC
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

-- some zdoom specific macros

sloped(f,c,x) { linetypehexen(181, f, c, 0, 0, 0) x linetype(0,0) }
mirror(x)     { linetypehexen(182, 0, 0, 0, 0, 0) x linetype(0,0) }

-- arches! weeee!

slopedarch(x, y, n, h, cur, floor, ceil, light, unpegger) {
  twice(slopedarc(x, y, n, h, cur, floor, ceil, light, unpegger)
        movestep(x, mul(y,n))
        turnaround)
}

delta(r, f, h) { div(sin(add(900,asin(sub(1024,mul(div(1024,f),r))))),div(1024,h)) }

slopedarc(x, y, n, h, cur, floor, ceil, light, unpegger) {
  eq(cur,n)
    ? 0
    : straight(x)
      unpegger right(y) unpegger
      sloped(0,1,right(x))
      unpegger right(y) unpegger
      rightsector(floor, add(ceil, delta(cur, n, h)), light)
      rotright
      movestep(0, y)
      slopedarc(x, y, n, h, add(cur,1), floor, ceil, light, unpegger) 
}
