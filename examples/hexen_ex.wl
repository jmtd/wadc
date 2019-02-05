/*
 * hexen_ex.wl: Simple example of a Hexen map
 * part of WadC
 *
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"hexen.h"
#"standard.h"

thingstep(x) {
      movestep(64,0)
      x thing
}

main {
    hexendefaults
    pushpop(
      movestep(64,64)
      thing

      clearflag(or(cleric,mage))
      thingstep(quietus1)
      thingstep(quietus2)
      thingstep(quietus3)

      setflag(cleric)
      clearflag(or(fighter,mage))
      thingstep(wraithverge1)
      thingstep(wraithverge2)
      thingstep(wraithverge3)

      setflag(mage)
      clearflag(or(fighter,cleric))
      thingstep(bloodscourge1)
      thingstep(bloodscourge2)
      thingstep(bloodscourge3)

    )
    box(0,256,160,1024,1024)

    setflag(or(cleric,fighter))
    pushpop(
        movestep(512,512)
        iceguy
        fori(1,5,
            -- spawn a quartz flask when the wendigos die
            -- thanks Gez
            setthingargs(i, 0, 135, i,75,0,0,0)
            thing movestep(0,64))
    )

    -- demonstrate z-position with a rising line of mana
    mana1
    movestep(64,960)
    fori(1,10,
      setthingargs(0, mul(i,8) /* zpos */, 0, 0,0,0,0,0)
      thing
      move(64)
    )
}
