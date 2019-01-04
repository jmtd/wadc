/*
 * blockmap.wl: example of using a blockmap to bound random drawing
 *
 * part of WadC
 *
 * Copyright © 2019 Jonathan Dowland
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"basic.h"
#"blockmap.h"

door
{
      box(0,128, 160, 64,128)
}

inner_arrow
{
    pushpop(
      movestep(64,96)
      step(96,0)
      step(0,-32)
      step(64,64)
      step(-64,64)
      step(0,-32)
      step(-96,0)
      step(0,-64)
      innerrightsector(0,160,0)
    )

}

-- a basic square room, possibly with a door to the "top", and another to
-- the right. Attempt to recursively draw further rooms atop and to the right
-- if:
--    * the blockmap doesn't indicate that the space is already occupied
--    * the variable "rooms" is ≥ 1
basic_room(t)
{
    box(0,160, 160, 256,256)
    inner_arrow
    _blockmap_mark(t)

    print(cat(tuple_str(t),
          cat("=>",
          cat(tuple_str(tuple_add(t, tuple_rotate(tuple(1,0),getorient))),
          cat(",",
              tuple_str(tuple_add(t, tuple_rotate(tuple(0,1),getorient)))
    )))))

    if(and(lessthan(1, get("rooms")),
           not(blockmap_check(tuple_add(t,tuple_rotate(tuple(1,0),getorient))))),

      -- doorway 1
      movestep(256,64)
      door
      movestep(64,-64)
      dec("rooms", 1)
      basic_room(tuple_add(t,tuple_rotate(tuple(1,0),getorient)))
      movestep(-256,0)
      movestep(-64, 0)
    )

    -- doorway 2
    if(and(lessthan(1, get("rooms")),
           not(blockmap_check(tuple_add(t,tuple_rotate(tuple(0,1),getorient))))),

      movestep(192,256)
      set("fuck", getorient) -- we need to capture it prior to rotating :/
      rotright
      door
      movestep(64,-64)
      dec("rooms", 1)

      basic_room(tuple_add(t,tuple_rotate(tuple(0,1),get("fuck"))))
      movestep(-64,0)
      movestep(-256,256)
      rotleft
    )
}

main
{
    blockmap_init
    set("rooms", 7)

     -- mark the blockmap in a few places to force the rooms to spread
    blockmap_mark(3,0)
    blockmap_mark(3,1)
    blockmap_mark(2,3)
    blockmap_mark(0,2)

    blockmap_debug_draw(320)

    basic_room(tuple(0,0))
    place(64,64, thing)
}
