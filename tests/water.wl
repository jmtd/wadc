/*
 * water.wl - a demonstration of the Boom water routines
 * both using the basic water* routines and the more advanced
 * owater* routines (at the same time)
 */

#"standard.h"
#"water.h"

main {
    waterinit_fwater(-16)
    movestep(0,64) -- out of the way of control sectors
    pushpop(movestep(32,32) thing)

    !main
    -- a ramp of rooms, descending in floor and ceiling height
    fori(0, 7,
        set("floorheight", sub(0, mul(i,24)))
        set("ceilheight",  add(128, get("floorheight")))
        water(
            box(get("floorheight"), get("ceilheight"), 200, 256, 256),
            get("floorheight"),
            get("ceilheight"),
        )
        movestep(-256,0)
    )

    ^main movestep(256,256) rotright

    -- again, but with a custom water variable
    set("newwater", onew)
    pushpop( -- control sectors again
      movestep(0,-64)
    owaterinit(get("newwater"), -32, "SLIME01", "WATERMAP", 40)
    )
    fori(1, 7,
        set("floorheight", sub(0, mul(i,24)))
        set("ceilheight",  add(128, get("floorheight")))
        owater(
            get("newwater"),
            box(get("floorheight"), get("ceilheight"), 200, 256, 256),
            get("floorheight"),
            get("ceilheight"),
        )
        movestep(256,0)
    )
}
