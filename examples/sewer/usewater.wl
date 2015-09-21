/*
 * usewater.wl - a demonstration of the Boom water routines
 */

#"standard.h"
#"water.h"

main {
    waterinit_fwater(-16)
    movestep(0,64) -- out of the way of control sectors
    pushpop(movestep(32,32) thing)

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
}