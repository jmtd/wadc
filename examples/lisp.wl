#"lisp.h"

-- example LISP style lists using objects!

main {
  map(append(list3(1, 2, 3),
             list3(4, 5, 6)),
      print(mapvar))
}
