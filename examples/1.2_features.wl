/*
 * 1.2_features.wl: demonstrate the new features in WadC 1.2: midtex, impassable and friendly
 * part of WadC
 *
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"
#"monsters.h"
#"pickups.h"


main {
  thing movestep(-64,-64)
  box(0,192,160,512,add(256,128))

  revenant
  mid("MIDGRATE")

  movestep(64,128)
  ibox(24,128,160,128,128)
  pushpop( movestep(64,64) thing )

  popsector
  midtex
  impassable
  friendly

  movestep(256,0)
  ibox(24,128,160,128,128)
  pushpop( movestep(64,64) thing )
}
