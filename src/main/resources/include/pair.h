/*
 * pair.h - part of WadC
 * Copyright © 2017 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * Pairs (2 element tuples)
 */

#"standard.h"

pair(fst,snd)
{
    _pair(onew,fst,snd)
}
_pair(_t,fst,snd)
{
    oset(_t,"fst",fst)
    oset(_t,"snd",snd)
    _t
}

fst(t)
{
    oget(t,"fst")
}
snd(t)
{
    oget(t,"snd")
}

-- only works if eq() works for the types stored in the pair
pair_eq(t1,t2)
{
    and(eq(fst(t1),fst(t2)),
        eq(snd(t1),snd(t2)))
}

pair_str(t)
{
    cat("(",
    cat(fst(t),
    cat(",",
    cat(snd(t),
        ")"
    ))))
}

pair_test
{
    set("t1", pair(1,2))
    set("t2", pair(1,2))
    set("t3", pair(3,2))

    assert(eq(1,pair_eq(get("t1"),get("t2"))))
    assert(eq(0,pair_eq(get("t1"),get("t3"))))
    print(pair_str(get("t1")))

    test_pair_rotate
}

pair_add(t1,t2)
{
  pair(
  add(fst(t1), fst(t2)),
  add(snd(t1), snd(t2))
  )
}

-- orient has to be strict
pair_rotate(t,_orient)
{
  ifelse(eq(north, _orient),
    t,                                         -- North
    ifelse(eq(east, _orient),
      pair(mul(-1,snd(t)), fst(t)),           -- East
      ifelse(eq(south, _orient),
        pair(mul(-1,fst(t)), mul(-1,snd(t))), -- South
        pair(snd(t), mul(-1,fst(t))),         -- West
  )))
}

test_pair_rotate
{
  assert(pair_eq(pair(1,0), pair_rotate(pair(1,0), north)))
  assert(pair_eq(pair(0,1), pair_rotate(pair(1,0), east)))
}
