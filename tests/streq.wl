#"standard.h"
/*
 * streq.wl - part of WadC
 * Copyright © 2021 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * test streq function
 */

main {
    assert(streq("hi","hi"))
    assert(not(streq("a","b")))
}
