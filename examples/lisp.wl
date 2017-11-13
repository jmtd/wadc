/*
 * lisp.wl: example LISP style lists using objects!
 * part of WadC
 *
 * Copyright © 2001-2008 Wouter van Oortmerssen
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"lisp.h"

main {
  map(append(list3(1, 2, 3),
             list3(4, 5, 6)),
      print(mapvar))
}
