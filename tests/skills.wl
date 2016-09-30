/*
 * skills.wl - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 * 
 * test of skill levels
 */

#"basic.h"
#"monsters.h"

main {

    box(0,256,160,256,256)
    place(64, 64, thing)

    formerhuman

    friendly easy          print(getthingflags) place(128,128, thing) -- 7 + 128 = 135
    friendly hurtmeplenty  print(getthingflags) place(64, 128, thing) -- 6
    friendly ultraviolence print(getthingflags) place(128, 64, thing) -- 4 + 128 = 132

}
