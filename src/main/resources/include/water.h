/*
 * water.h - part of WadC
 * Copyright © 2015 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * routines for working with Boom deep water (sector type 242)
 * TODO: de-duplicate control sectors
 */

/*
 * waterinit - this should be called only once and before using any
 * other water* routines.
 *
 * the water routines will draw control sectors forward and to the right
 * of the pen location when this is called.
 */
waterinit(h, f, m, l) {
    set("water",     h) -- height of the water
    set("waterflat", f) -- what flat to use e.g. FWATER1
    set("watermap",  m) -- COLORMAP to use for underwater e.g. WATERMAP
    set("waterlight",l) -- how bright it is underwater

    set("watertag", newtag)
    !water -- where the next control sector will go
    !watermargin
    water_vanilla(m)
}

/* convenience function for common water settings */
waterinit_fwater(h) {
    waterinit(h, "FWATER1", "WATERMAP", 80)
}

/*
 * define a texture matching the colormap. This is a hack so that
 * the wad doesn't crash vanilla.
 */
water_vanilla(m) {
    texture(m,64,128)
    addpatch("BODIES",0,0)
}

/*
 * water - wrapper to use around functions which create sectors that should
 * have water in them.
 */
water(x, floorheight, ceilheight) {
    -- we only want to set the floor of *this* sector to waterflat if the
    -- water level is above the floor. (TODO: consider moving water.)
    lessthaneq(floorheight, get("water"))
      ?
        !notwater

        -- the control sector
        ^water
          ceil(get("waterflat"))
          move(8)
          triple(left(8))
          linetype(242, get("watertag") ) left(8)
          bot(get("watermap"))
          leftsector(get("water"), ceilheight, 140)
          popsector
          linetype(0,0)
          move(16)
        !water

        -- decorate whatever we've been passed
        ^notwater
        sectortype(0, get("watertag") )
        set("watertmp", getfloor)
        floor(get("waterflat"))
        x
        floor(get("watertmp"))
        sectortype(0,0)
        set("watertag", newtag)

      -- pass-through if no decoration necessary
      : x
}

/*
 * water_carriage_return - temporary measure for performing a 'carriage return'
 * for control sector placement
 */
water_carriage_return {
  !water_carriage_return
  ^watermargin
  movestep(0,16)
  !watermargin
  !water
  ^water_carriage_return
}
