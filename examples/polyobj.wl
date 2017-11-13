/*
 * polyobj.wl: Poly Object examples in a Hexen map
 *
 * part of WadC
 *
 * Copyright © 2016-2017 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"
#"hexen.h"
#"control.h"

main {

    hexendefaults
    pushpop(move(-64) turnaround controlinit)

    pushpop(movestep(32,32) thing)
    box(0,190,160,256,256)

    /*
     * first doorway: big sliding door
     */

    movestep(256, 64)
    doorway

    polyobj(2, 0, 0,
        mid("D_END2") movestep(-16,-64) straight(32),

        mid("DOOR51")
        setlineflags(or(getlineflags, or(repeat, use)))
        linetypehexen(polyobj_doorslide, 2, 100, byteangle_e, 120, 100)
        right(128) mid("D_END2") right(32) mid("DOOR51") right(128)
        linetypehexen(0,0,0,0,0,0) setlineflags(0),

        ^doorway movestep(32,64)
    )
    polyobj_space

    /*
     * second doorway: split sliding doors
     */

    box(0,190,160,256,256)

    movestep(256,0) rotright
    movestep(256, 64)

    split_doorway

    -- left door
    polyobj(3, 4, 0,
        mid("D_END2")
        movestep(-16,0) straight(32),

        mid("D_WD09")
        setlineflags(or(getlineflags, or(repeat, use)))
        linetypehexen(polyobj_doorslide, 3, 100, byteangle_s, 60, 50)
        right(64) mid("D_END2") right(32) mid("D_WD09") right(64)
        linetypehexen(0,0,0,0,0,0) setlineflags(0),

        ^split_doorway movestep(32,0)
    )
    polyobj_space

    -- right door (mirrored)
    polyobj(4, 0, 0,
        rotright
        mid("D_END2")
        movestep(-16,-64) straight(32),

        mid("D_WD10")
        setlineflags(or(getlineflags, or(repeat, use)))
        linetypehexen(polyobj_doorslide, 3, 100, byteangle_s, 60, 50)
        right(64) mid("D_END2") right(32) mid("D_WD10") right(64)
        linetypehexen(0,0,0,0,0,0) setlineflags(0),

        ^split_doorway movestep(32,128)
    )
    polyobj_space

    /*
     * third doorway: split rotating doors
     */

    box(0,190,160,256,256)
    movestep(256,0) rotright
    movestep(256, 64)

    split_doorway

    -- left door
    polyobj(5, 6, snd_creak,
        turnaround
        mid("D_END2")
        movestep(-16,0) straight(16),

        mid("D_WD09")
        setlineflags(or(getlineflags, or(repeat, use)))
        linetypehexen(polyobj_doorswing, 5, 100, byteangle_n, 100, 0)
        right(64) mid("D_END2") right(16) mid("D_WD09") right(64)
        linetypehexen(0,0,0,0,0,0) setlineflags(0),

        ^split_doorway movestep(32,0)
    )
    polyobj_space

    -- right door
    polyobj(6, 0, 0,
        rotright mid("D_END2")
        movestep(-16,-64) straight(16),

        mid("D_WD10")
        setlineflags(or(getlineflags, or(repeat, use)))
        linetypehexen(polyobj_doorswing, 5, 100, byteangle_n, 100, 0)
        right(64) mid("D_END2") right(16) mid("D_WD10") right(64)
        linetypehexen(0,0,0,0,0,0) setlineflags(0),

        ^split_doorway movestep(32,128)
    )
    polyobj_space

    /*
     * rotating column in the last room
     */

    box(0,190,160,256,256)

    pushpop(
      movestep(64,64)
      movestep(64,64) -- centre
      !column

      polyobj(1, 0, 0,                   -- polyobj number, mirror, sound

          movestep(-32,-32) straight(32),-- first line, relative to anchor

          -- remaining lines
          linetypehexen(polyobj_rotateleft, 1, 8, byteangle_se, 0, 0)
          setlineflags(or(getlineflags, or(repeat, use)))
          right(32) right(32) right(32)
          linetype(0,0) setlineflags(0),

          ^column                        -- spawn point in map
      )
    )
    polyobj_space
}

/*
 * a simple doorway, drawn backwards to work around WadC line splitting bugs
 */
doorway {
    !doorway
    pushpop(
      movestep(64, 128)
      turnaround
      box(0,128,140,64,128)
    )
    movestep(64,-64)
}

/*
 * a simple doorway in two sectors (so we have two segs for polyobs)
 */
split_doorway {
   !split_doorway
   pushpop(
      movestep(64, 128)
      turnaround
      box(0,128,140,64,64)
      movestep(0,64)
      box(0,128,140,64,64)
  )
    movestep(64,-64)
}

/* stuff that should probably go to polyobj.h *********************************************************/


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
        setthing(3000) thingangle(number)

        -- PolyObj_StartLine (polyobj num; mirror; sound)
        linetypehexen(1, number, mirror, sound, 0, 0)
        firstline
        linetypehexen(0, 0, 0, 0, 0, 0)
        restlines
        leftsector(0,0,0) -- deliberately inside-out!
    )
    spawn
    setthing(3001) thingangle(number)

    ^polyobj
}


polyobj_space {
    -- make sure the polyobjs are separated enough
    -- TODO: some finer controls over control spacing would make 
    -- this redundant

    !polyobj_space
    ^control
    movestep(0,256)
    !control
    ^polyobj_space

}

/* some helpful constants for working with polyobjs */

polyobj_doorslide  { 8 }
polyobj_rotateleft { 2 }
polyobj_doorswing  { 7 }


byteangle_e    { 0 }
byteangle_ne   { 32 }
byteangle_n    { 64 }
byteangle_nw   { 96 }
byteangle_w    { 128 }
byteangle_sw   { 160 }
byteangle_s    { 192 }
byteangle_se   { 224 }


snd_heavy { 1 }
snd_metal { 2 }
snd_creak { 3 }
snd_silence { 4 }
snd_lava { 5 }
snd_water { 6 }
snd_ice { 7 }
snd_earth { 8 }
snd_metal2 { 9 }
