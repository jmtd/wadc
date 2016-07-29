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
 
    pushpop( -- temporary button
      movestep(64,64)
      button(polyobj_doorslide, 2, 100, byteangle_e, 120, 100)
    )

    movestep(256, 64)

    linetypehexen(polyobj_doorslide, 2, 100, byteangle_e, 120, 100)
    doorway
    linetype(0,0)
    
    polyobj(2, 0, 0,
        mid("DOOR51") movestep(-16,-64) straight(32),

        linetypehexen(polyobj_doorslide, 2, 100, byteangle_e, 48, 100)
        right(128) right(32) right(128)
        linetypehexen(0,0,0,0,0,0),

        ^doorway movestep(32,64)
    )
    polyobj_space


    /*
     * second doorway: split sliding doors
     */

    box(0,190,160,256,256)

    movestep(256,0) rotright

    -- temp button
    pushpop(
      movestep(64,64)
      button(polyobj_doorslide, 3, 100, byteangle_s, 60, 50)
    )

    movestep(256, 64)

    split_doorway

    -- left door
    polyobj(3, 4, 0,
        mid("D_WD09")
        movestep(-16,0) straight(32),

        linetypehexen(polyobj_doorslide, 3, 100, byteangle_s, 60, 100)
        right(64) right(32) right(64)
        linetypehexen(0,0,0,0,0,0),

        ^split_doorway movestep(32,0)
    )
    polyobj_space

    -- right door (mirrored)
    polyobj(4, 0, 0,
        rotright mid("D_WD10")
        movestep(-16,-64) straight(32),

        linetypehexen(polyobj_doorslide, 3, 100, byteangle_n, 60, 100)
        right(64) right(32) right(64)
        linetypehexen(0,0,0,0,0,0),

        ^split_doorway movestep(32,128)
    )
    polyobj_space


    /*
     * third doorway: split rotating doors
     */


    box(0,190,160,256,256)
    movestep(256,0) rotright
    
    -- temp button
    pushpop(
      movestep(64,64)
      button(polyobj_doorswing, 5, 100, byteangle_n, 100, 0)
    )
    movestep(256, 64)

    split_doorway

    -- left door
    polyobj(5, 6, 0,
        turnaround
        mid("D_WD09")
        movestep(-16,0) straight(32),

        linetypehexen(polyobj_doorswing, 5, 100, byteangle_e, 100, 0)
        right(64) right(32) right(64)
        linetypehexen(0,0,0,0,0,0),

        ^split_doorway movestep(32,0)
    )
    polyobj_space

    -- right door
    polyobj(6, 0, 0,
        rotright mid("D_WD10")
        movestep(-16,-64) straight(32),

        linetypehexen(polyobj_doorswing, 5, 100, byteangle_e, 100, 0)
        right(64) right(32) right(64)
        linetypehexen(0,0,0,0,0,0),

        ^split_doorway movestep(32,128)
    )
    polyobj_space

    /*
     * rotating column in the last room
     */

    box(0,190,160,256,256)

    pushpop(
      movestep(64,64)
      button(polyobj_rotateleft, 1, 8, byteangle_se, 0, 0)
      movestep(64,64) -- centre
      !column

      polyobj(1, 0, 0,                   -- polyobj number, mirror, sound
          movestep(-32,-32) straight(32),-- first line, relative to anchor
          right(32) right(32) right(32), -- remaining lines
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

/*
 * simple box button
 */
button(type, arg1, arg2, arg3, arg4, arg5) {
  linetypehexen(type, arg1, arg2, arg3, arg4, arg5)
  bot("SW52_OFF")
  rotleft quad(right(32)) rotright
  innerrightsector(32,190,160)
  linetypehexen(0,0,0,0,0,0)
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

