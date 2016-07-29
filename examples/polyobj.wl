#"standard.h"
#"hexen.h"
#"control.h"

byteangle_e    { 0 }
byteangle_ne   { 32 }
byteangle_n    { 64 }
byteangle_nw   { 96 }
byteangle_w    { 128 }
byteangle_sw   { 160 }
byteangle_s    { 192 }
byteangle_se   { 224 }

main {
    hexendefaults
    pushpop(move(-64) turnaround controlinit)

    pushpop(movestep(32,32) thing)

    box(0,190,160,256,256)

    pushpop( movestep(64,64)

        --linetypehexen(8, 1, 32, 128, 64, 105)
        -- Polyobj_RotateLeft (po, speed, angle)
        linetypehexen(2, 1, 8, byteangle_se, 0, 0)
        -- PolyObj_DoorSlide. Not working.
        --linetypehexen(8, 1, 100, 128, 48, 100)
        ibox(32,190,160,32,32)
        linetypehexen(0,0,0,0,0,0)

    )

    movestep(256,64)

    !doorway
    movestep(64,128)
    turnaround

    box(0,128,160,64,128)

    -- we'll put the spawn in the centre of the doorway space for now
    polyobj(1, 0, 0,                   -- polyobj number, mirror, sound
        movestep(-16,-32) straight(32),-- first line, relative to anchor
        right(64) right(32) right(64), -- remaining lines
        ^doorway movestep(32,64)       -- spawn point in map
    )

    turnaround movestep(0,-192)
    box(0,190,160,256,256)

}

/*
 * polyobj - create a polyobject
 * args:
 *      number - the polyobject number to create
 *      firstline - the first linedef for the polyobj (needs tagging)
 *      restlines - all other linedefs for the polyobj (connect to first!)
 *      spawn - this argument should set the cursor to the position
 *              that the polyobj spawn point will be placed in the
 *              map
 */
polyobj(number, mirror, sound, firstline, restlines, spawn) {
    !polyobj
    control(
        -- force thing angle to reference polyobj 1
        forceangle(number) setthing(3000) thing

        -- PolyObj_StartLine (polyobj num; mirror; sound)
        linetypehexen(1, number, mirror, sound, 0, 0)
        firstline
        linetypehexen(0, 0, 0, 0, 0, 0)
        restlines
        leftsector(0,0,0) -- deliberately inside-out!
    )
    spawn
    forceangle(number) setthing(3001) thing

    ^polyobj
}
