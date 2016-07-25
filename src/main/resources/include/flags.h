/*
 * flags.h - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * flags.h - routines for setting thing flags
 * fairly experimental, might be renamed
 */

setflag(x) {
    setthingflags(or(getthingflags, x))
}
clearflag(x) {
    setthingflags(and(getthingflags, not(x)))
}

/* common to all */

skill1_2            { 1  }
skill3              { 2  }
skill4_5            { 4  }
ambush              { 8  } /* or "stands still" for Strife */
multiplayer         { 16 }

/* boom additions */

not_in_dm           { 32 }
not_in_coop         { 64 }

/* MBF addition */

mbf_friendly        { 128 }

/* hexen */

dormant             { 16 }
fighter             { 32 }
cleric              { 64 }
mage                { 128 }
hexen_appears_sp    { 256 }
hexen_appears_coop  { 512 }
hexen_appears_dm    { 1024 }

/* strife */

stands_still        { 8 }
strife_ambush       { 32 }
strife_friendly     { 64 }
translucent         { 256 } /* 25% translucent */
invisible           { 512 } /* or 75% translucent if on with above */
