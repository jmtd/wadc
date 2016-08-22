/*
 * strife.h - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * strife.h - sensible defaults for Strife maps
 */

-- I might merge these two
#"strife/things.h"

#"thingflags.h"

/* thingflags */
stands_still        { 8 }
strife_ambush       { 32 }
strife_friendly     { 64 }
translucent         { 256 } /* 25% translucent */
invisible           { 512 } /* or 75% translucent if on with above */

/*
 * some suitable default values for flats etc.
 */
strifedefaults {
    floor("F_TECH01")
    ceil("F_GENTAN")
    top("CONCRT02")
    mid("CONCRT02")
    bot("CONCRT02")
}
