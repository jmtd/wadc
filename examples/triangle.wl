/*
 * triangle.wl: Random triangle sectors, similar to hexagon.wl
 * part of WadC
 *
 * Copyright © 2001-2008 Wouter van Oortmerssen
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

-- similar thing to hexagon.wl, but more hierarchical and more compact code
-- doesn't look as good in Doom as hexagons though, probably because of the
-- sharp angles

#"standard.h"

main {
  seed(rand(0,1337))
  thing
  gentoptri(2048)
}

gentoptri(n) {
  eq(n,128) ? largetri : rectri(n,gentoptri(div(n,2))) 
}

rectri(n,sub) {
  sub
  movestep(0,n)
  sub
  movestep(n,sub(0,div(n,2)))
  sub
  turnaround
  movestep(0,sub(0,n))
  sub
  movestep(n,div(n,2))
  turnaround
  movestep(0,sub(0,n))
}

pickvar(sub,n) { 
  sub
  | { sky(n)
    | { sky16(n) | ceiln(n) | ceilhi(n) }
    | { pond(n) | { sky48(n) | 0 } }
    }
} 

largetri { pickvar(rectri(128,medtri),4) }
medtri { pickvar(rectri(64,smalltri),2) }
smalltri { pickvar(0,1) }

sky(n)    { base(n,0,0,192,160,0) }
sky16(n)  { base(n,floor("RROCK19"),16,192,160,0) }
sky48(n)  { base(n,0,48,192,192,0) }
ceiln(n)  { base(n,ceil("RROCK11"),0,128,64,0) }
ceilhi(n) { base(n,ceil("RROCK11"),0,160,96,0) }
pond(n)   { base(n,0,0,192,192,innertri(n,floor("FWATER1"),-16,192,160)) }

base(n,tex,fl,cl,l,after) {
  floor("GRASS2")
  ceil("F_SKY1") 
  wall({ "TANROCK5" | "ZIMMER3" | "TANROCK4" | "ASHWALL3" | "ZIMMER5" })
  tex
  for(1,n,step(0,64))  
  for(1,n,step(64,-32))
  for(1,n,step(-64,-32)) 
  leftsector(fl,cl,l)
  after 
}

innertri(n,tex,fl,cl,l) { inner(n,tex,mul(n,40),sub(0,mul(n,20)),fl,cl,l) }

inner(n,tex,f,h,fl,cl,l) {
  !startinner
  movestep(mul(n,8),mul(n,12))
  step(0,f)  
  step(f,h)
  step(sub(0,f),h)
  tex
  innerleftsector(fl,cl,l) 
  ^startinner
}
