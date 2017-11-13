/*
 * logo.wl: A WadC Logo Drawn using WadC
 *
 * part of WadC
 *
 * Copyright © 2015-2017 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"

main {

  pushpop(
    thing
    movestep(-448 ,-384) 
    box(0, 192, 200, 1024, 1728) 
  )

  W        movestep(0,320)
  A        movestep(0,320)
  D        movestep(0,320)
  C
}

W {
  step(-256,  -128)
    step( 640,    0)
     step(   0,   64)
      step(-384,    0)
       step( 128,   64)
       step(-128,   64)
      step( 384,    0)
     step(   0,   64)
    step(-512,    0)
   step(   0,  -64)
  step( 128,  -64)
  innerrightsector(0, 128, 128)
  popsector
}

A {
  step(   0,  -64)
   step(-128,  -0)
    step(   0,  -64)
     step( 384,    0)
      step( 128,   64)
       step(   0,  128)
      step(-128,   64)
     step(-384,    0)
    step(   0,  -64)
   step( 128,   -0)
  step(0, -64)
  innerrightsector(0, 128, 128)

  pushpop(
    movestep( 64, 0)
    
    step(0, -48)
     step(128, 0)
      step(64,48)
      step(-64,48)
     step(-128,0)
    step(0,-48)
    innerrightsector(0, 128, 200)
  )
  popsector popsector
}

D {
  Dn(32)
  innerrightsector(0, 128, 128)
  movestep(-64, 128)  
  Dn(16)
  innerrightsector(0, 128, 200)
  popsector popsector
}

Dn(n) {
  movestep( mul(4,n), mul(-4,n))

  step( mul(8,n),    0)
   step(   0, mul(4,n))
    step(mul(-4,n), mul(4,n))
     step(mul(-8,n),    0)
    step(mul(-4,n), mul(-4,n))
   step(   0, mul(-4,n))
  step( mul(8,n),    0)
}

C {
  movestep(0, -64)

  step( 128,    0)
   step( 128,  128)
    step(   0,  128)
     step( -64,    0)
      step(   0, -128)
       step( -64,  -64)
        step(-128,    0)
        step(-128,    0)
       step( -64,   64)
      step(   0,  128)
     step( -192,    0)
    step(   128, -128)
   step( 128, -128)
  step( 128,    0)
  innerrightsector(0, 128, 128)
  popsector
}
