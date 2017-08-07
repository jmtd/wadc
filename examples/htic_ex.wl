/*
 * htic_ex.wl: Simple example of a Heretic map
 * part of WadC
 *
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"heretic.h"
#"standard.h"

main {
    hereticdefaults
    pushpop(
      movestep(64,64)
      thing
    )
    testroom(imp thing crossbow thing)
    testroom(mummy thing dragonclaw thing)

    movestep(512,0) rotright
    testroom(knight thing hellstaff thing)
    testroom(wizard thing phoenixrod thing)

    movestep(512,0) rotright
    testroom(macespawner thing impleader thing)
    testroom(mummyghost thing)
    testroom(mummyleader thing)

    movestep(512,0) rotright
    testroom(mummyleaderghost thing )
    testroom(knightghost thing)
    testroom(iron_liche thing)

    movestep(512,0) rotright
    testroom(pod thing artiegg thing)
    testroom(ophidian thing)
    testroom(weredragon thing)
    testroom(sabreclaw thing)

    movestep(512,0) rotright
    testroom(maulotaur thing)

}

testroom(x) {
    !testroom

    box(0,128,160,512,512)
    movestep(192,192)
    ibox(16,128,160,128,128)
    movestep(64,64)
    turnaround x turnaround

    ^testroom movestep(512,0)

    movestep(0,192)
    movestep(64,128) turnaround
    box(0,96, 160, 64, 128)
    movestep(64,-256)

    ^testroom movestep(add(64,512),0)
}
