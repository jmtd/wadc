#"standard.h"

inc(i) {
  set(i, add(1, get(i)))
}

main {

    texture("ZOMG", 64, 128)
    addpatch("RW24_2", 0, 64)
    addpatch("RW24_2", 48, 8)

    set("i", 1)
    for(1, 4,

      texture(cat("ZOMG", get("i")), 128, 128)
      addpatch("RW24_2", 0, 0)
      addpatch("RW24_2",64, 0)
      addpatch(cat("BFALL",get("i")), 32, 0)
  
      inc("i")
    )
}
