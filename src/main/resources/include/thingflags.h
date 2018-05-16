/*
 * thingflags.h - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * thingflags.h - routines for setting thing flags
 */

setflag(x) {
    setthingflags(or(getthingflags, x))
}
clearflag(x) {
    setthingflags(and(getthingflags, not(x)))
}
toggleflag(x) {
    setthingflags(xor(getthingflags, x))
}
xor(a,b) {
    not(or(and(a,b),and(not(a),not(b))))
}

/* common to all Doom engine games */

skill1_2            { 1  }
skill3              { 2  }
skill4_5            { 4  }
ambush              { 8  } /* or "stands still" for Strife */
multiplayer         { 16 }


/* formerly built-in WadC commands */

deaf
{
  print("WARNING: deaf is deprecated and will be removed in a future release")
  toggleflag(ambush)
}

easy { setflag(or(skill1_2, or(skill3, skill4_5))) }
hurtmeplenty { clearflag(skill1_2) setflag(or(skill3, skill4_5)) }
ultraviolence { clearflag(or(skill1_2, skill3)) setflag(skill4_5) }

/* complememts to the above */

easyonly { clearflag(or(skill3, skill4_5)) setflag(skill1_2) }
mediumonly { clearflag(or(skill1_2, skill4_5)) setflag(skill3) }

/* boom additions */

not_in_dm           { 32 }
not_in_coop         { 64 }

/* MBF addition */

mbf_friendly        { 128 }

/* formerly built-in WadC command */
friendly { toggleflag(mbf_friendly) }
