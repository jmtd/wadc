/*
 * blockmap.wl: example of using a blockmap to bound random drawing
 *
 * part of WadC
 *
 * Copyright © 2019 Jonathan Dowland
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * draws a random assortment of rooms, using a blocklist to avoid overdrawing,
 * and a drawlist to determine where the rooms can be added
 */

#"basic.h"
#"blockmap.h"

quantity { knob("quantity", 1, 16, 128) }
brightness { knob("brightness", 0, 160, 255) }

------------------------------------------------------------------------------

drawlist
{
  get("drawlist")
}
drawlist_init
{
  set("drawlist", nil)
}
drawlist_add(t)
{
  _drawlist_add(t,getorient)
}
_drawlist_add(t,_orient)
{
  ifelse(eq(1,pair_in_list(pair(t,_orient),drawlist)),
         0,
         -- sidecar the orientation into the tuple
         set("drawlist", cons(pair(t,_orient),drawlist)))
}
drawlist_dump
{
  map(drawlist,
      print(cat(pair_str(fst(mapvar)),cat(",", snd(mapvar))))
  )
}

------------------------------------------------------------------------------

door
{
  box(0,128, brightness, 64,128)
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

possible_future_room(t)
{
  -- populate drawlist
  -- XXX the 'and' trick is working around a bug in not()/blockmap_check
  if(and(1,not(blockmap_check(pair_add(t,pair_rotate(pair(1,0),getorient))))),
     drawlist_add(pair_add(t,pair_rotate(pair(1,0),getorient))))
}

-- a basic square room, possibly with a door to the "top", and another to
-- the right.
basic_room(t)
{
  box(0,160, brightness, 256,256)
  inner_arrow
  possible_future_room(t)
  rotright
  possible_future_room(t)
  rotleft
}

right_turn(t)
{
  movestep(0,64)
  straight(192)
  right(192)
  possible_future_room(t)
  right(128)
  right(64)
  left(64)
  right(128)
  rotright
  rightsector(0,160,160)
}

left_turn(t)
{
  movestep(0,64)
  straight(64)
  left(64)
  possible_future_room(t)
  right(128)
  right(192)
  right(192)
  right(128)
  rotright
  rightsector(0,160,160)
}

tee(t)
{
  movestep(0,64)
  straight(64)
  left(64)
  possible_future_room(t)
  right(128)
  right(256)
  possible_future_room(t)
  right(128)
  right(64)
  left(64)
  right(128)
  rotright
  rightsector(0,160,160)
}

random_room(t)
{
  basic_room(t) | right_turn(t) | left_turn(t) | tee(t)
}

main
{
  seed(rand(0,191617415))
  !start
  blockmap_init
  drawlist_init

  place(64,96, thing)
  drawlist_add(pair(0,0))

  fori(1, quantity, place_random_room)
}

place_random_room
{
  -- XXX the drawlist might be empty!
  ifelse(eq(0, list_length(drawlist)),
         print("drawlist is empty!"),

         -- random index into drawlist
         _random_room(rand(0,sub(list_length(drawlist),1))))
}

_random_room(_i)
{
  if(and(1,not(blockmap_check(fst(list_get(drawlist, _i))))),
    set("weeeee2", list_get(drawlist, _i))
    set("drawlist", list_remove(drawlist, _i))

    orientfix(fst(get("weeeee2")), snd(get("weeeee2")))
    place(-64,64, door)
    random_room(fst(get("weeeee2")))
   _blockmap_mark(fst(get("weeeee2")))
  )
}

-- assume we are at the bottom-left of a blockmap space. move/rotate according
-- to orientation

orientfix(_t, _o)
{
  ^start
  movestep(mul(320,fst(_t)),mul(320,snd(_t)))

  orientswitch(_o,
    /* north */ 0,
    /* south */ movestep(256,256) turnaround,
    /* east  */ move(256) rotright,
    /* west  */ movestep(0,256) rotleft
  )
}

orientswitch(orient, n, s, e, w)
{
  ifelse(eq(orient, north), n,
         ifelse(eq(orient, south), s,
                ifelse(eq(orient, east), e,w
  )))
}
