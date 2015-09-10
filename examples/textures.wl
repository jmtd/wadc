#"standard.h"

inc(i) {
  set(i, add(1, get(i)))
}

main {

    -- simple example of a new texture with two patches
    texture("ZOMG", 64, 128)
    addpatch("RW24_2", 0, 64)
    addpatch("RW24_2", 48, 8)

    -- generate 4 textures with a different BFALLx on each
    set("i", 1)
    for(1, 4,
      texture(cat("ZOMG", get("i")), 128, 128)
      addpatch("RW24_2", 0, 0)
      addpatch("RW24_2",64, 0)
      addpatch(cat("BFALL",get("i")), 32, 0)
      inc("i")
    )

    -- generate a bunch of new textures, adding some new lumps
    -- onto them (the WINUMx menu graphics)
    set("i", 0)
    for(0, 9,
      texture(cat("LOL", get("i")), 128, 128)
      addpatch("RW24_2", 0, 0)
      newpatch(cat("WINUM",get("i")))
      addpatch(cat("WINUM",get("i")), 32, 0)
      print(get("i"))
      inc("i")
    )
}
