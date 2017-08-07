/*
 * strife_ex.wl: Boring basic Strife example
 * part of WadC
 *
 * Copyright © 2016-2017 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"strife.h"
#"standard.h"

main {
    strifedefaults
    pushpop(
      movestep(64,64)
      thing
    )
    box(0,128,160,512,512)
}
