/*
 * choz.wl: A large approximation of a sphere
 * part of WadC
 *
 * Copyright © 2001-2008 Wouter van Oortmerssen
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"

main {
  circle(512)
  rightsector(0,0,0)
  movestep(0,4)
  innercircles(508,16,4,128)
  thing
}

circle(r) { quad(curve(r,r,10,1)) }

delta(r) { div(sin(add(900,asin(mul(r,2)))),3) }

innercircles(_r,_minr,_step,_ll) {
  eq(_r,_minr)
    ? 0
    : circle(_r)
      innerrightsector(sub(0,delta(_r)),add(0,delta(_r)),_ll)
      movestep(0,_step)
      innercircles(sub(_r,_step),_minr,_step,add(_ll,1))
}
