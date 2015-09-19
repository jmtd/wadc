#"standard.h"

/*
 * an example of a sewer-like pattern, with curving corridor sections.
 * a 'header' for use in more than one .wl file.
 */

-- XXX! these need filling out
slimeinit {
    print("slimeinit needs implementing")
}

slimebars(y,f,c,l) {
    print("slimebars needs implementing")
    --slimecorridor(y,f,c,l)
}

slimechoke(a,b) {
    print("slimechoke needs implementing")
}

slimeopening(y,f,c,l) {
    print("slimeopening needs implementing")
    move(y)
}

slimeswitch(y,f,c,l,t) {
    print("slimeswitch needs implementing")
}

slimesecret(y,f,l, things) {
    print("slimesecret needs implementing")
    slimecorridor(y,f,add(128,f), l)
    things
}

slimesplit(f,l,left, right) {
    print("slimesplit needs implementing")
    box(f,add(128,f),l, 256, 256)

    !slimesplit
    rotleft
    left

    ^slimesplit
    movestep(256,256)
    rotright
    right
}

-- normal corridor
slimecorridor(y,f,c,l) {
  box(add(32,f),sub(c,32),l,y,32)
  movestep(0,32)
  box(f,c,l,y,sub(256,64))
  movestep(0,sub(256,64))
  box(add(32,f),sub(c,32),l,y,32)
  movestep(0,mul(-1,sub(256,32)))

  move(y)
}

-- a curve to the right
slimecurve_r(f,c,l) {
  !omglol
  curve(add(128,mul(2,128)),add(128,mul(2,128)),64,1)
  ^omglol
  movestep(0,32)
  curve(add(96,mul(2,128)),add(96,mul(2,128)),64,1)
  ^omglol
  movestep(0,sub(256,32))
  curve(add(32,128),add(32,128),32,1)
  ^omglol
  movestep(0,256)
  curve(128,128,32,1)

  rotleft

  straight(32)
  leftsector(add(f,32),sub(c,32),l)
  straight(sub(256,64))
  leftsector(f,c,l)
  straight(32)
  leftsector(add(f,32),sub(c,32),l)

  rotright
}

-- a curve to the left
slimecurve(f,c,l) {
  curve(128,mul(-1,128),32,1)
  rotright
  straight(32)
  !secondbit
  rotright
  curve(add(32,128),add(32,128),32,1)
  rotright
  straight(32)
  rightsector(add(32,f),sub(c,32),l)

  ^secondbit
  move(sub(256,64))
  !thirdbit
  rotright
  -- dodgy bit
  curve(add(96,mul(2,128)),add(96,mul(2,128)),32,1)
  rotright
  straight(sub(265,64))
  ^secondbit
  straight(sub(256,64))
  rightsector(f,c,l)

  ^thirdbit
  straight(32)
  rotright
  curve(add(128,mul(2,128)),add(128,mul(2,128)),32,1)
  right(32)
  rightsector(add(32,f),sub(c,32),l) -- this bit failing

  ^secondbit
  rotleft
  movestep(0,-32)
}

scurve(f,c,l) { slimecurve(f,c,l) | slimecurve_r(f,c,l) }

