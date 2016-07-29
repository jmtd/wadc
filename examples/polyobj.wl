#"standard.h"
#"hexen.h"

main {
    hexendefaults
    pushpop(movestep(32,32) thing)

    box(0,190,160,256,256)
    movestep(256,64)

    !doorway
    movestep(64,128)
    turnaround
    box(0,128,160,64,128)
    turnaround movestep(0,-192)

    box(0,190,160,256,256)

    movestep(0,add(128,256))

    -- PolyObj_StartLine (polyobj num; mirror; sound)
    linetypehexen(1, 1, 0, 0, 0, 0)
    straight(32)

    -- PolyObj_DoorSlide. Not working.
    linetypehexen(8, 1, 32, 128, 64, 105)
    right(64)
    linetypehexen(0, 0, 0, 0, 0, 0)
    right(32)
    linetypehexen(8, 1, 32, 128, 64, 105)
    right(64)
    linetypehexen(0, 0, 0, 0, 0, 0)

    leftsector(0,0,0) -- deliberately inside-out!
    rotright

    forceangle(1) -- force thing angle to reference polyobj 1
    setthing(3000)
    movestep(16,32) thing

    -- anchor for polyobj. we'll put it in the
    -- centre of the space for now
    ^doorway
    setthing(3001)
    movestep(32,64) rotright thing
}
