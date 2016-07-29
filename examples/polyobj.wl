#"standard.h"
#"hexen.h"
#"control.h"

main {
    hexendefaults
    pushpop(move(-64) turnaround controlinit)

    pushpop(movestep(32,32) thing)

    box(0,190,160,256,256)
    movestep(256,64)

    !doorway
    movestep(64,128)
    turnaround
    box(0,128,160,64,128)
    turnaround movestep(0,-192)

    box(0,190,160,256,256)

    -- we'll put the anchor in the centre of the doorway space for now
    polyobj(1, ^doorway movestep(32,64))
}

/*
 * polyobj - create a polyobject
 * args:
 *      number - the polyobject number to create
 *      anchor - this argument should set the cursor to the position
 *               that the polyobj anchor thing will be placed in the
 *               map
 */
polyobj(number, anchor) {
    control(
        -- PolyObj_StartLine (polyobj num; mirror; sound)
        linetypehexen(1, number, 0, 0, 0, 0)
        straight(32)

        -- PolyObj_DoorSlide. Not working.
        linetypehexen(8, number, 32, 128, 64, 105)
        right(64)
        linetypehexen(0, 0, 0, 0, 0, 0)
        right(32)
        linetypehexen(8, number, 32, 128, 64, 105)
        right(64)
        linetypehexen(0, 0, 0, 0, 0, 0)

        leftsector(0,0,0) -- deliberately inside-out!
        rotright

        -- force thing angle to reference polyobj 1
        movestep(16,32)
        forceangle(number) setthing(3000) thing
    )

    anchor
    forceangle(number) setthing(3001) thing
}
