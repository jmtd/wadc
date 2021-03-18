#"standard.h"
/*
 * accessor.wl - part of WadC
 * Copyright © 2021 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * test texture accessors
 */

main {
    mid("WTF")
    assert(streq("WTF", getmid))
    top("fancy java")
    assert(streq("fancy java", gettop))
    bot("streams meant")
    assert(streq("streams meant", getbot))
    floor("these were")
    assert(streq("these were", getfloor))
    ceil("broken")
    assert(streq("broken", getceil))
}
