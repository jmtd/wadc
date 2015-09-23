-- standard usefull functions

turnaround { rotleft rotleft }

movestep(n,o) { up step(n,o) down }
move(n) { up step(n,0) down }
straight(n) { step(n,0) }
left(n) { rotleft step(n,0) }
right(n) { rotright step(n,0) }
eleft(n) { rotleft step(n,n) }
eright(n) { step(n,n) rotright }

licurve(f,s,d,i) { rotleft curve(f,s,d,i) rotleft }
ricurve(f,s,d,i) { rotright curve(f,s,d,i) rotright }

quad(x) { x x x x }
triple(x) { x x x }
twice(x) { x x }

wall(x) { mid(x) top(x) bot(x) }

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

