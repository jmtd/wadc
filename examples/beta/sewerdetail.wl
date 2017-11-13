#"standard.h"
#"basic.h"
#"pipes.wl"
#"monsters.h"

/*
 * TODO
 * proper implementation of slimequad. corridor always put ceiling a fixed height
 * above floor, so either rework corridor, or reimplement slimequad not in terms
 * of corridor.x
 */

sbox(f,c,l,w,h) {
    swater(box(f,c,l,w,h),f,c)
}

main {
  pushpop(rotright controlinit)
  move(1024)
  unpegged
  set("slime1", onew) -- upper sewers
  slimeinit(get("slime1"), 0, 128, 160, 16, "SLIME04", "WATERMAP", 80, "BRICK7")
  set("slime1_5", onew) -- quads between upper/middle
  slimeinit(get("slime1_5"), -256, 128, 160, 16, "SLIME04", "WATERMAP", 80, "BRICK7")

  set("slime2", onew) -- middle sewers
  slimeinit(get("slime2"), -256, add(-256,128), 140, 16, "SLIME04", "WATERMAP", 80, "GRAY1")

  set("slime2_5", onew) -- quads between middle/bottom
  slimeinit(get("slime2_5"), -512, add(-256,128), 140, 16, "SLIME04", "WATERMAP", 80, "GRAY1")

  set("slime3", onew) -- bottom sewers
  slimeinit(get("slime3"), -512, add(-512,128), 120, 32, "SLIME04", "WATERMAP", 80, "ICKWALL3")

  slimeset(get("slime1"))

  unpegged -- ?

  -- upper loop
  !start
  rotright
  entrance_area(player1start)
  curveleft
  corridor(64)

  !quad1
  slimeset(get("slime1_5"))
  sewerquad
  slimeset(get("slime1"))

  corridor(128)
  curveleft
  corridor(128)
  control_carriage_return

  !quad2
  slimeset(get("slime1_5"))
  sewerquad
  slimeset(get("slime1"))

  corridor(64)
  curveleft
  corridor(512)
  curveleft

  -- middle loop
  control_carriage_return
  ^quad1
  move(320)
  rotright
  slimeset(get("slime2"))
  move(320) -- skip slimequad
  corridor(64)
  curveleft
  corridor(512)
  control_carriage_return
  curveleft
  entrance_area(formersergeant)
  curveleft
  corridor(64)
  move(320) -- skip slimequad
  control_carriage_return
  sewerfade

  print(cat(get("controlstats")," control sectors"))
}

entrance_area(x) {
  !entrance
  corridor(512)
  ^entrance
  movestep(64,-128)
  box(24,160,140,384,128)
  ^entrance
  movestep(64,320)
  box(24,160,140,384,128)
  place(128,64, rotleft x thing)
  ^entrance
  move(512)
}

sewerquad {
  corridor(320)
}


-- sewerfade: light level fade-off
sewerfade {
    set("slimefade", oget(get("slime"), "light"))
    _sewerfade(16)
    oset(get("slime"), "light", get("slimefade"))
}
_sewerfade(i) {
    lessthaneq(i,0) ? 0 : {
        oset(get("slime"), "light", sub(oget(get("slime"), "light"), 8))
        corridor(16)
        _sewerfade(sub(i,1))
    }
}

-- like fori but you must increment i yourself
fori_(from, to, body) {
  set("i", from)
  lessthaneq(i,to) ? body for(i,to,body) : 0
}

-- corridor bit with conduit
pipebit(y) {
  _pipebit(y,oget(get("slime"), "floor"), oget(get("slime"), "ceil"), oget(get("slime"), "light"))
}
_pipebit(y,f,c,l) {
      sbox(f, add(f,152), l, y, 80)
      movestep(0, 80)
      ceil("CEIL5_2") sbox(f, add(f,140), l, y, 32)
      movestep(0, 32)
      ceil("RROCK10") sbox(f, add(f,152), l, y, 80)
      movestep(y, -112)
}

/* draws a diamond pattern of side-length x and creates
   an inner sector with properties f,c,l */
idiamond(x,f,c,l) {
    down
    step(x,x)
    step(mul(-1,x),x)
    step(mul(-1,x),mul(-1,x))
    step(x,mul(-1,x))
    innerrightsector(f,c,l)
}

lightbox {
  _lightbox(oget(get("slime"), "floor"), oget(get("slime"), "ceil"), oget(get("slime"), "light"))
}
_lightbox(f,c,l) {
      ceil("TLITE6_1") sbox(f, add(f,132), l, 64, 64)
      pushpop(
        -- light cone
        movestep(32,8) swater(quad(curve(24,24,4,0)) innerrightsector(f,add(f,132),add(l,30)),f,add(f,132))
        -- diamond light cut-out
        movestep(0,8) swater(idiamond(16,f,add(f,124),add(l,60)),f,add(f,124))
      )
}

corridor(y) {

  _corridor(y,oget(get("slime"), "floor"), oget(get("slime"), "ceil"), oget(get("slime"), "light"))
}
_corridor(y,f,c,l) {
  !corridor
  fori(0,3,

    sbox(add(f,16), add(mul(i,16),add(f,88)), l, y, 16)
    movestep(0,16)
    xoff(mul(add(1,i),16))
  )
 
  top("METAL")

  fori_(0, y,
    -- headroom will be sub(y, i)

    -- if we have 192px or more, we'll have a light
    lessthaneq(192, sub(y,i)) ? {

      pipebit(128)

      ceil("RROCK10") sbox(f, add(f,152), l, 64, 64)
      movestep(0,64)
      lightbox
      movestep(0, 64)
      ceil("RROCK10") sbox(f, add(f,152), l, 64, 64)
      movestep(64,-128)

      inc("i", 192)

    } : { eq(i,y) ? 0 : { -- no room for a light

      pipebit(sub(y,i))
      inc("i", sub(y, i))
    }}
  )

  ^corridor
  movestep(0,256)

  fori(0,3,
    sbox(add(f,16), sub(add(f,136),mul(i,16)), l, y, 16)

    movestep(0,16)
    xoff(mul(add(1,i),16))
  )
  
  ^corridor move(y)
}

-- you can't superimpose curves unless they are drawn exactly the same
-- direction, so we draw all the curves first and define sectors after

curveleft {
  _curveleft(oget(get("slime"), "floor"), oget(get("slime"), "ceil"), oget(get("slime"), "light"))
}
_curveleft(f,c,l) {
  corridor(32) -- gives us more favourable alignment for lights
  !curveleft

  -- inner-curves
  fori(0,4,
      ^curveleft
      movestep(0,mul(i,16))
      curve(add(mul(i,16),160), add(mul(i,-16),-160), 24, 1)
  )
  ^curveleft
  movestep(160,-160)
  fori(0,3,
    swater(straight(16) rightsector(f, add(mul(i,16),88), l),
      f, add(mul(i,16),88))
  )

  -- middle curves
  ^curveleft
  movestep(0, 144)
  ceil("CEIL5_2") sbox(f, add(f,140), l, 32, 32) -- first bit of conduit
  movestep(32,-16)
  lightbox

  move(64)
  !curveleft2 swater(
    curve(128, -96, 32, 1)
    rotright
    step(0,32)
    step(16,0)
    rotright
    curve(96, 144, 32, 1)
    right(32) ceil("CEIL5_2") 
    rightsector(f, add(f,140), l)
  , f, add(f,140))

  ^curveleft
  move(224)
  lightbox

  !curveleft2
   move(32)
   curve(48, -160, 32, 1)
   ^curveleft2
   swater(

    move(64)
    step(0,16)
    ceil("CEIL5_2") 	
    curve(48, -176, 32, 1) left(32) leftsector(f, add(f,140), l)
  , f, add(f,140))

  -- outer curves
  fori(0,4,
    ^curveleft
    movestep(0,add(256,mul(i,16)))
    curve(add(mul(i,16),416), add(mul(i,-16),-416), 48, 1)
  )
  rotleft
  fori(0,3, swater(straight(16) leftsector(add(f,16), add(mul(i,16),88), l),
      add(f,16), add(mul(i,16),88)))

  -- middle sectors
  swater( straight(80) ceil("RROCK10") leftsector(f, add(f,152), l), f, add(f,152))
  move(32)
  swater( straight(80) ceil("RROCK10") leftsector(f, add(f,152), l), f, add(f,152))

  move(64) rotright
  corridor(32)
}
