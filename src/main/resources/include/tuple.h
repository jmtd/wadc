/*
 * tuple.h - part of WadC
 * Copyright © 2017 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * Tuples (pairs really)
 */

#"standard.h"

tuple(fst,snd)
{
    _tuple(onew,fst,snd)
}
_tuple(_t,fst,snd)
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

-- only works if eq() works for the types stored in the tuple
tuple_eq(t1,t2)
{
    and(eq(fst(t1),fst(t2)),
        eq(snd(t1),snd(t2)))
}

tuple_str(t)
{
    cat("(",
    cat(fst(t),
    cat(",",
    cat(snd(t),
        ")"
    ))))
}

tuple_test
{
    set("t1", tuple(1,2))
    set("t2", tuple(1,2))
    set("t3", tuple(3,2))

    assert(eq(1,tuple_eq(get("t1"),get("t2"))))
    assert(eq(0,tuple_eq(get("t1"),get("t3"))))
    print(tuple_str(get("t1")))
}
