-- standard usefull functions

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
yo(x, y) { yoff(x) y undefy } 

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
