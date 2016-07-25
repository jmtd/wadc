/*
 * hexen.h - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * hexen.h - sensible defaults for Heretic maps
 */

-- I might merge these two
#"hexenthings.h"
#"flags.h"

/*
 * some suitable default values for flats etc.
 */
hexendefaults {
    floor("F_009")
    ceil("F_011")
    top("CAVE02")
    mid("CAVE02")
    bot("CAVE02")
    hexenformat

    setflag(fighter)
    setflag(cleric)
    setflag(mage)
    setflag(hexen_appears_sp)
    setflag(hexen_appears_coop)
    setflag(hexen_appears_dm)
}
