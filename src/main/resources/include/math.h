/*
 * math.h - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * Math routines
 */

pow(a,b) {
  eq(b,0) ? 1 : {
      mul(a, pow(a, sub(b,1)))
  }
}

lshift(a,b) {
    mul(a, pow(2,b))
}

rshift(a,b) { -- signed right shift
    div(a, pow(2,b))
}

even(x) {
  eq(x,mul(2,div(x,2)))
}

odd(x) {
    even(x) ? 0 : 1
}
