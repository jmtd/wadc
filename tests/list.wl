/*
 * lisp.wl: example LISP style lists using objects!
 * part of WadC
 *
 * Copyright © 2001-2008 Wouter van Oortmerssen
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"
#"list.h"

main
{
  map(append(list3(1, 2, 3),
             list3(4, 5, 6)),
      print(mapvar))

  -- test in_list
  assert(eq(1, in_list(1, list3(0,1,2))))
  assert(eq(0, in_list(3, list3(0,1,2))))

  -- test list_get
  assert(eq(0,  list_get(list3(0,1,2), 0)))
  assert(eq(1,  list_get(list3(0,1,2), 1)))
  assert(eq(2,  list_get(list3(0,1,2), 2)))
  assert(eq(-1, list_get(list3(0,1,2), 3)))

  -- test list_remove
  assert(eq(2, list_length(list_remove(list3(0,1,2), 0))))
  assert(eq(1, list_get(list_remove(list3(0,1,2), 0),0)))
}
