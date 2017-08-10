/*
 * sectorfill.wl: sector shapes that break the polygon fill algorithm
 * part of WadC
 * Copyright © 2017 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"

main {
  !start
  box(0,0,0,64,64)
  movestep(128,0)

  box(50,0,0,64,64)

  ^start -- adjacent box => linedefs not all inward facing
  movestep(32,64)
  box(100,0,0,64,64)

  ^start -- non convex shape
  movestep(128,0)
  straight(64)
  right(64)
  right(64)
  left(32)
  left(96)
  left(128)
  left(96)
  left(32)
  leftsector(10,0,0)

  ^start   -- sectors that are disjoint
  movestep(0,192)
  forcesector(lastsector)
  box(666,0,0,64,64) -- floor level should be ignored

}
