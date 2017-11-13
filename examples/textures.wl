/*
 * textures.wl: Simple example of composing textures in WadC
 * part of WadC
 *
 * Copyright © 2015-2017 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"

main {

    -- simple example of a new texture with two patches
    texture("ZOMG", 64, 128)
    addpatch("RW24_2", 0, 64)
    addpatch("RW24_2", 48, 8)

    -- generate 4 textures with a different BFALLx on each
    set("i", 1)
    for(1, 4,
      texture(cat("ZOMG", get("i")), 128, 128)
      addpatch("RW24_2", 0, 0)
      addpatch("RW24_2",64, 0)
      addpatch(cat("BFALL",get("i")), 32, 0)
      inc("i", 1)
    )

    -- generate a bunch of new textures, adding some new lumps
    -- onto them (the WINUMx menu graphics)
    set("i", 0)
    for(0, 9,
      texture(cat("LOL", get("i")), 64, 128)
      addpatch("RW24_2", 0, 0)
      addpatch(cat("WINUM",get("i")), 32, 0)
      inc("i", 1)
    )

    -- a room so we can see this in DOOM
    pushpop(movestep(32,32) thing)
    mid("LOL3")
    box(0, 128, 140, 256, 256)
}
