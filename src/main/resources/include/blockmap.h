/*
 * blockmap.h - part of WadC
 * Copyright © 2019 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * Blockmap-management
 */

#"list.h"
#"pair.h"

-- we're going to maintain a list of pairs, which are coordinates in a blockmap

pair_in_list(t,l)
{
    ifelse(eq(l,nil), 0,
        ifelse(pair_eq(hd(l), t),
           1,
           pair_in_list(t, tl(l))
    ))
}

test_pair_in_list
{
    set("mylist", list2(pair(1,2), pair(2,3)))
    map(get("mylist"), print(pair_str(mapvar)))

    assert(eq(1, pair_in_list(
        pair(0,1),
        list2(pair(0,1), pair(1,2))
    )))

    assert(eq(1, pair_in_list(
        pair(0,1),
        list3(pair(3,3), pair(0,1), pair(1,2))
    )))

    assert(eq(0, pair_in_list(
        pair(3,1),
        list2(pair(0,1), pair(1,2))
    )))
}

-- blockmap stuff proper -----------------------------------------------------

blockmap
{
    get("blockmap")
}
blockmap_init
{
    set("blockmap", nil)
}

blockmap_check(t)
{
    pair_in_list(t, blockmap)
}

blockmap_mark(x,y)
{
    _blockmap_mark(pair(x,y))
}
_blockmap_mark(t)
{
    ifelse(eq(1,pair_in_list(t,blockmap)),
       0,
       set("blockmap", cons(t,blockmap)))
}

test_blockmap
{
    blockmap_init
    assert(eq(0, blockmap_check(pair(0,0))))    -- nothing marked by default
    assert(eq(0, list_length(blockmap))) -- list is empty
    blockmap_mark(0,0)                   -- mark one block
    assert(eq(1, blockmap_check(pair(0,0))))    -- test it is marked
    assert(eq(1, list_length(blockmap))) -- list has grown by 1
    blockmap_mark(0,0)                   -- ask to mark the same block
    assert(eq(1, blockmap_check(pair(0,0))))    -- test it is marked still
    assert(eq(1, list_length(blockmap))) -- list has not grown
    blockmap_mark(0,1)
    assert(eq(1, blockmap_check(pair(0,0))))    -- test it is marked still
    assert(eq(1, blockmap_check(pair(0,1))))    -- test it is marked
    assert(eq(2, list_length(blockmap))) -- list has grown by 1
}

blockmap_debug_draw(scale)
{
  map(blockmap,

    !blockmap_debug_draw
    movestep(
      mul(scale, fst(mapvar)),
      mul(scale, snd(mapvar))
    )
    movestep(64,64) 
    drawx
    ^blockmap_debug_draw
  )
}

-- 128x128 X shaped sector
drawx
{
  step(64,48)
  step(64,-48)
  step(0,32)
  step(-48,32)
  step(48,32)
  step(0,32)
  step(-64,-48)
  step(-64,48)
  step(0,-32)
  step(48,-32)
  step(-48,-32)
  step(0,-32)
  rightsector(0,0,0)
}
