/*
 * doom_ex.wl - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 * 
 * Boring basic Doom (#1) example
 */

#"doom.h"
#"standard.h"

main {
    doomdefaults
    pushpop(
      movestep(64,64)
      thing
    )
    box(0,128,160,512,512)
}
