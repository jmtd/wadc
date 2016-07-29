/*
 * angles.wl - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * test of manually-provided thing angles
 * a ring of zombies around the player facing away at 8
 * compass points
 */

#"standard.h"
#"monsters.h"

main {

    box(0,192,160,512,512)
    movestep(256,256) thing
    formerhuman

    movestep( 128,    0) thingangle(angle_north)
    movestep(   0,  128) thingangle(angle_ne)
    movestep(-128,    0) thingangle(angle_east)
    movestep(-128,    0) thingangle(angle_se)
    movestep(   0, -128) thingangle(angle_south)
    movestep(   0, -128) thingangle(angle_sw)
    movestep( 128,    0) thingangle(angle_west)
    movestep( 128,    0) thingangle(angle_nw)
}
