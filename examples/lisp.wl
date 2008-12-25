-- example LISP style lists using objects!

main {
  map(append(list3(1, 2, 3),
             list3(4, 5, 6)),
      print(mapvar))
}

-- basic constructor/accessor functions

cons(a, b) { sethdtl(onew, a, b) }
sethdtl(_o, a, b) { sethd(_o, a) settl(_o, b) _o }    -- '_' essential here
sethd(o, h) { oset(o, "hd", h) }
settl(o, t) { oset(o, "tl", t) }
hd(o) { oget(o, "hd") }
tl(o) { oget(o, "tl") }
nil() { -1 }  -- int value of other objects is >=0!

-- for convenience

list1(a)             { cons(a, nil) }
list2(a, b)          { cons(a, cons(b, nil)) }
list3(a, b, c)       { cons(a, cons(b, cons(c, nil))) }
list4(a, b, c, d)    { cons(a, cons(b, cons(c, cons(d, nil)))) }
list5(a, b, c, d, e) { cons(a, cons(b, cons(c, cons(d, cons(e, nil))))) }

-- useful functions

-- can be made a lot faster when made eager, i.e. _x and _y...
-- (currently normal order evaluation)

append(x, y) {
  eq(x, nil)
    ? y
    : cons(hd(x), append(tl(x), y))
}

map(x, f) {
  eq(x, nil)
    ? nil
    : cons(set("mapvar", hd(x)) f, map(tl(x), f))
}

mapvar() { get("mapvar") }   -- our closures can't take arguments
