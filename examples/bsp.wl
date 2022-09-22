/*
 * bsp.wl: binary space partitioning experiment
 * part of WadC
 *
 * Copyright © 2019 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"

minseg  { 512 }
minroom  { 128 }

size { knob("size", 0, 2048, 8192) }

main
{
    seed(rand(0,1337))
    bsp(size, size, 0)
    pushpop( movestep(32,32) thing)
}

-- always split vertically (rotate in recursion)
bsp(x, y, depth)
{
    bsp_(x, y, depth, rand(minseg,sub(y,minseg)))
}
bsp_(x, y, depth, _split)
{
    drawseg(x, y) -- DEBUG
    movestep(0,_split)
    rotleft

    ifelse(lessthaneq(_split, minseg),
       room(_split, x, depth),
       bsp(_split, x, add(depth,1))
    )

    rotright
    movestep(x,0) 
    rotright

    ifelse(lessthaneq(_split, minseg),
        room(sub(y,_split), x, depth),
        bsp(sub(y,_split), x, add(depth,1))
    )

    rotright
    movestep(x,_split)
    turnaround
}

-- just a box, but smaller than the space given.
room(w, h, depth)
{
    print(cat(w,cat(",",h)))    
      _room(ifelse(lessthaneq(w,minroom), w, rand(minroom, w)),
            ifelse(lessthaneq(h,minroom), h, rand(minroom, h)),
            depth)
}
_room(_w, _h, depth)
{
    print(cat("    ",cat(_w,cat(",",_h))))    
    box(sub(0, mul(depth,8)), 128, 160, _w,_h)
}

drawseg(x, y)
{
  straight(x)
  right(y)
  right(x)
  right(y)
  rotright
}

/* bad seeds:

    -1246253629
    -1231509699

	need a separate minquad number for controlling recursion, from a minsize argument
 	for room size generation (done)

	rooms can still be adjacent, so perhaps always sub an additional 8 from sizes
*/
