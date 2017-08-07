/*
 * slopetest.wl: simple ZDoom slopes tests
 * part of WadC
 *
 * Copyright © 2001-2008 Wouter van Oortmerssen
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

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

