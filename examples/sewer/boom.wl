/*
 * boom.wl - routines for working with Boom special effects
 *
 * so far just water* for managing deep water effects
 *
 * XXX: Things to fix:
     * de-duplicate control sectors
     * more water property parameterisation (light level, textures, flats)
 */

#"standard.h"

main {
    waterinit(24)
    movestep(0,64) -- out of the way of control sectors

    pushpop(movestep(32,32) thing)

    -- a ramp of rooms, descending in floor and ceiling height
    fori(0, 7,
        water(
            room(mul(i,-16), 200, 256, 256),
            add(128,mul(i,-16))
        )
        movestep(-256,0)
    )
}

-- simplify box; ceil is floor + 128
room(f,l,x,y) {
    box(f, add(128,f), l, x, y)
}

/*
 * waterinit - this should be called only once and before using any
 * other water* routines.
 *
 * the water routines will draw control sectors forward and to the right
 * of the pen location when this is called.
 */
waterinit(waterheight) {
    set("water", waterheight)
    set("watertag", newtag)
    !water -- where the next control sector will go
}

/*
 * water - wrapper to use around functions which create sectors that should
 * have water in them.
 */
water(x,ceilheight) {
    !notwater

    -- the control sector
    ^water
      floor("RROCK10")
      ceil("SLIME01")
      move(8)
      triple(left(8))
      linetype(242, get("watertag") ) left(8)
      leftsector(get("water"), ceilheight, 140)
      linetype(0,0)
      move(16)
    !water

    ^notwater
    sectortype(0, get("watertag") )
    floor("SLIME01")
    x
    sectortype(0,0)
    set("watertag", newtag)
}
