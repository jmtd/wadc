/*
 * water.h - part of WadC
 * Copyright © 2015-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * routines for working with Boom deep water (sector type 242)
 * NOTE: this uses control.h. The caller must ensure controlinit
 * has been run before using water routines.
 *
 * the water* routines operate on a global object and are useful for
 * maps that only need/want one deep water type
 * the owater* routines operate on a user-supplied object, meaning you
 * can mix multiple water levels/types in the same map
 */
#"standard.h"
#"control.h"

/*
 * waterinit - this should be called only once and before using any
 * other water* routines.
 *
 * the water routines will draw control sectors forward and to the right
 * of the pen location when this is called.
 */
waterinit(h, f, m, l) {
    set("owater", onew)
    owaterinit(get("owater"), h, f, m, l)
}
owaterinit(o, h, f, m, l) {
    oset(o, "water",     h) -- height of the water
    oset(o, "waterflat", f) -- what flat to use e.g. FWATER1
    oset(o, "watermap",  m) -- COLORMAP to use for underwater e.g. WATERMAP
    oset(o, "waterlight",l) -- how bright it is underwater

    oset(o, "watertag", newtag)
    water_vanilla(m)

    -- this is a workaround for a bug which stops you using water() on
    -- the first sector in the map: the control sector gets drawn first
    -- (so it's the real first sector), but then the popsector command
    -- fails (since you can't pop the last sector).
    control( box(0,0,0,8,8) )
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
    texture(m,32,128)
    addpatch("SW12_1",0,0)
}

/*
 * water - wrapper to use around functions which create sectors that should
 * have water in them.
 */
water(x, floorheight, ceilheight) {
    owater(get("owater"), x, floorheight, ceilheight)
}
owater(o, x, floorheight, ceilheight) {
    -- we only want to set the floor of *this* sector to waterflat if the
    -- water level is above the floor. (TODO: consider moving water.)
    lessthaneq(floorheight, oget(o, "water"))
      ?
        -- the control sector
        control(
          bot(oget(o, "watermap"))
          linetype(242, oget(o, "watertag"))
          straight(8)
          linetype(0,0)
          triple(right(8))
          rotright
          ceil(oget(o, "waterflat"))
          rightsector(oget(o, "water"), ceilheight, oget(o, "waterlight"))
          popsector
        )

        -- decorate whatever we've been passed
        sectortype(0, oget(o, "watertag") )
        oset(o, "watertmp", getfloor)
        floor(oget(o, "waterflat"))
        x
        floor(oget(o, "watertmp"))
        sectortype(0,0)
        oset(o, "watertag", newtag)

      -- pass-through if no decoration necessary
      : x
}
