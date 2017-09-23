/*
 * standard.h - part of WadC
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * standard useful functions
 * Nearly every WadC program will need these
 */

#"thingflags.h"

turnaround { rotleft rotleft }

movestep(n,o) { up step(n,o) down }
move(n) { up step(n,0) down }
straight(n) { step(n,0) }
left(n) { rotleft step(n,0) }
right(n) { rotright step(n,0) }
eleft(n) { rotleft step(n,n) }
eright(n) { step(n,n) rotright }

unpeg(x) { unpegged x unpegged }
typeline(t, tag, x) { linetype(t, tag) x linetype(0, 0) }
typesector(t, tag, x) { sectortype(t, tag) x sectortype(0, 0) }
xo(x, y) { xoff(x) y undefx }
yo(x, y) { yoff(x) y }

pushpop(x)  { !pushpop  x ^pushpop  }
pushpop2(x) { !pushpop2 x ^pushpop2 }  -- one level of nesting :)

licurve(f,s,d,i) { rotleft curve(f,s,d,i) rotleft }
ricurve(f,s,d,i) { rotright curve(f,s,d,i) rotright }

quad(x) { x x x x }
triple(x) { x x x }
twice(x) { x x }

wall(x) { mid(x) top(x) bot(x) }
autotexall() { wall("?") floor("?") ceil("?") }

abs(x) { lessthaneq(x,-1) ? sub(0,x) : x }

for(from,to,body) {
  lessthaneq(from,to) ? body for(add(from,1),to,body) : 0
}

fori(from, to, body) {
    set("i", from)
    for(from, to,
        body
        inc("i",1)
    )
}
i { get("i") }

/*
 * forXY
 * x: number of columns
 * y: number of rows
 * row: callback for ending a row (like carriage return)
 * cell: callback for new cells
 */
forXY(x,y,row,cell) {
  set("x", 1)
  for(1, y,
    set("y", 1)
    for(1, x, cell inc("y",1))
    inc("x", 1)
    row
  )
}
x { get("x") }
y { get("y") }

inc(i,n) {
    set(i, add(get(i), n))
}

dec(i,n) {
    set(i, sub(get(i), n))
}

box(floor,ceil,light,x,y) {
  straight(x)
  right(y)
  right(x)
  right(y)
  rightsector(floor,ceil,light)
  rotright
}

ibox(floor,ceil,light,x,y) {
  right(y)
  left(x)
  left(y)
  left(x)
  innerleftsector(floor,ceil,light)
  turnaround
}

-- common shapes

erightdent(r,s) { eright(r) left(s) eleft(r) rotright }
eleftdent(l,s) { eleft(l) right(s) eright(l) rotleft }
rightdent(r,s) { right(r) left(s) left(r) rotright }
leftdent(l,s) { left(l) right(s) right(l) rotleft }

-- angle constants for use with thingangle(x)

angle_west  { 0 }
angle_sw    { 45 }
angle_south { 90 }
angle_se    { 135 }
angle_east  { 180 }
angle_ne    { 225 }
angle_north { 270 }
angle_nw    { 315 }
