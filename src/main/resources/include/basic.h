/*
 * basic.h - part of WadC
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"
#"spawns.h"

-- a set of generic structural components for maps, built with some
-- conventions. dimensions are based on the variables below, and
-- cursor positioning is such that it is always ready for the next
-- component (ahead & to the left)

setwidth(n) { set("width", n) }     -- current width of segment
setlight(n) { set("light", n) }
setfloorheight(n) { set("floor", n) }
setceilheight(n)  { set("ceil",  n) }

getwidth() { get("width") }
getlight() { get("light") }
getfloorheight() { get("floor") }
getceilheight()  { get("ceil")  }

sectordefaults(f, c, l, w) {      -- needs to be called before all else!
  setwidth(w)
  setlight(l)
  setfloorheight(f)
  setceilheight(c)
}

defaultsector()  { leftsector(getfloorheight, getceilheight, getlight)  } -- default counter clockwise
defaultsectorr() { rightsector(getfloorheight, getceilheight, getlight) }

floorup(n) { setfloorheight(add(getfloorheight, n)) }
ceilup(n)  { setceilheight(add(getceilheight, n))   }


------------------------------------------
-- segments, the generic building block --
------------------------------------------

seg2(w1, w2) {   -- very common, box parametrized over 2 side walls
  w1
  !segmark
  left(getwidth)
  rotleft
  w2
  left(getwidth)
  defaultsector
  ^segmark
}

seg(wall) { seg2(wall, wall) }
segplain(n) { seg(straight(n)) }
segtrigger(type, tag, wall) { seg2(wall linetype(type, tag), linetype(0, 0) wall) }

segwiden(s,r) {
  step(s,r)
  !segwmark
  left(add(getwidth,mul(r,2)))
  rotleft
  step(s,sub(0,r))
  left(getwidth)
  defaultsector
  ^segwmark
  setwidth(add(getwidth,mul(r,2)))
}


--------------------
-- generic stairs --
--------------------

stairs(s, t, u) { stairsd(s, t, u, 32) }

stairsd(steps, tex, up, depth) {    -- number of steps, step texture, up (1) or down (-1)
  eq(steps, 0)
    ? 0
    : !stairs
      floor(tex)
      { eq(up,0) ? 0 : floorup(16) }
      seg(straight(depth))
      { eq(up,0) ? floorup(-16) : 0 }
      ^stairs
      movestep(depth, 0)
      stairsd(sub(steps, 1), tex, up, depth)
}


---------------------------------
-- easy placement from a point --
---------------------------------

place(s, r, x) { !placemark movestep(s, r) x ^placemark }

placeitem(s, r, x) { place(s, r, x thing) }
placeitem3(s, r, dist, x, y, z) { place(s, r, x thing movestep(0,dist) y thing movestep(0,sub(0,mul(dist,2))) z thing) }
placeitemrev(s, r, x) { placeitem(s, r, turnaround x) }
placeitem3rev(s, r, dist, x, y, z) { placeitem3(s, r, dist, turnaround x, y, z) }
placeitem9rev(s, r, dist, t) { placeitem3rev(s, r, dist, t, t, t) placeitem3rev(add(s,dist), r, dist, t, t, t) placeitem3rev(sub(s,dist), r, dist, t, t, t) }


-----------------------------------
-- generic segments with borders --
-----------------------------------

setbord(width, rh, lh) {
  set("bordw", width)
  set("bordrh", rh)
  set("bordlh", lh)
}

getbordw() { get("bordw") }

bord(wi, wo, h, issect) {  -- inner/outer wall
  !bord
  wi
  ^bord
  right(getbordw)
  rotleft
  wo
  left(getbordw)
  { issect ? leftsector(add(getfloorheight,h), getceilheight, getlight) : 0 }
  rotright
}

segbord2d(wi1, wo1, wi2, wo2, issect) { seg2(bord(wi1, wo1, get("bordrh"), issect), bord(wi2, wo2, get("bordlh"), issect)) }
segbord2(w1, w2, issect) { segbord2d(w1, w1, w2, w2, issect) }
segbordd(i, o, issect) { segbord2d(i, o, i, o, issect) }
segbord(w, issect) { segbord2d(w, w, w, w, issect) }
segbordplain(n, issect) { segbord(straight(n), issect) }

segbordpillar(s,r,f) { segbordd(eleftdent(s,r),erightdent(s,r),f) }


-----------------
-- curvy bends --
-----------------

curvebend(s, t) { curvebendd(s, t, 7) }

curvebendd(s, t, d) {       -- size of inner curve, left (t==1), right (t!=1)
  curvebend2(curve(add(getwidth, s), sub(sub(0, s), getwidth), d, 1),
             curve(s, s, d, 1),
             t)
}

curvebend2(a, b, t) { eq(t, 1) ? seg2(a, b) : seg2(b, a) }

curvebendbord(s, t, issect) { curvebendbordd(s, t, 7, issect) }

curvebendbordd(s, t, d, issect) {
  curvebendbord2(curve(add(getwidth, s), sub(sub(0, s), getwidth), d, 1),
                 curve(add(getwidth, add(s,getbordw)), sub(sub(0, add(s,getbordw)), getwidth), d, 1),
                 curve(s, s, d, 1),
                 curve(sub(s,getbordw), sub(s,getbordw), d, 1),
                 t, issect)
}

curvebendbord2(ai, ao, bi, bo, t, issect) { eq(t, 1) ? segbord2d(ai, ao, bi, bo, issect) : segbord2d(bi, bo, ai, ao, issect) }


----------------------------
-- octagonal inner sector --
----------------------------

placeoctainner(s,r,w,h,sl,fdelta,cdelta,light) {
  !octainner
  movestep(s,r)
  left(w)
  eright(sl)
  straight(h)
  eright(sl)
  straight(w)
  eright(sl)
  straight(h)
  eright(sl)
  innerrightsector(add(getfloorheight,fdelta), add(getceilheight,cdelta), light)
  ^octainner
}

-------------------------------
-- easy player start prefabs --
-------------------------------

playerstarts() {                       -- 3 starts in front of standard door
  straight(div(sub(getwidth,64),2))
  pushpop(mid("DOORSTOP") right(16)
          mid("DOOR3") xo(0, left(64))
          mid("DOORSTOP") left(16)
          placeitem3(32, -32, 64, player1start, player2start, player3start))
  unpeg(straight(64))
  pushpop(ceil("flat23")
          rightsector(getfloorheight, 72, getlight))
  straight(div(sub(getwidth,64),2))
  rotleft
}

keypillar(type, t, tag) {
  typesector(0, tag, typeline(type, tag, pushpop2(wall(t) xo(0, ibox(getfloorheight, getfloorheight, getlight, 16, 16)))))
  movestep(0,32)
  popsector
}

playerstartskeyedexit() {                 -- 3 starts in front of 3 colour pillars
  straight(div(sub(getwidth,64),2))       -- needing 3 keys, leading to sky exit
  pushpop(floor("F_SKY1")
          movestep(0, 96)
          typeline(52, 0, box(sub(getfloorheight, 16), getceilheight, getlight, 64, 64)))
  box(getfloorheight, getceilheight, getlight, 64, 96)
  pushpop(movestep(24, 8)
          keypillar(133, "DOORBLU2", $blueexit)
          keypillar(135, "DOORRED2", $redexit)
          keypillar(137, "DOORYEL2", $yelexit))
  pushpop(straight(64) rotleft placeitem3(32, -32, 64, player1start, player2start, player3start))
  straight(64)
  straight(div(sub(getwidth,64),2))
  rotleft
}

---------------------------------------------
-- places a nice collection of guns & ammo --
---------------------------------------------

placeall(s,r) {
  !placeall
  movestep(s,r)
  pl(megasphere) pl(backpack)
  pl(doublebarreled) pl(chaingun) pl(rocketlauncher) pl(plasmagun)
  plr(boxofammo) plr(boxofshells) plr(cellcharge) plr(boxofrockets)
  ^placeall
}

pl(x) { x thing movestep(0, -32) }
plr(x) { movestep(32,192) for(1,6,pl(x)) }


------------------------------------------
-- pretty standard trap wall around seg --
------------------------------------------

trapwall(tag, h, x, y, z) {
  rightdent(16,192)
  !trapwallend
  straight(-192)
  sectortype(0, tag)
  leftsector(h, h, 96)
  sectortype(0, 0)
  movestep(0, 16)
  rightdent(64,192)
  leftsector(getfloorheight, h, 96)
  movestep(-128,0)
  rotright
  placeitem3rev(32, -32, 64, x, y, z)
  ^trapwallend
}

segtrap(tag, x, y, z) {    -- use linetype 36, because 109 fucks up wall texturing
  segtrigger(36, tag, trapwall(tag, add(getfloorheight, 96), x, y, z))
}


-------------------------------------------
-- constructs monster tele trigger + box --
-------------------------------------------

setnoisesector() { set("noisesector", lastsector()) }    -- call after sector that needs to wake up box

-- tag for use in box, tag to teleport to, segment size, max radius of monsters contained
-- ahead/side offset from current pos to place box, amount of monster triples, 3 monsters to repeat

-- after calling these 2 functions, insert "teleportlanding" things into sector tagged with desttag

segmonstertele(tag, desttag, n, rad, ahead, side, nmonsters, m1, m2, m3) {
  segtrigger(36, tag, straight(n))
  monsterbox(tag, desttag, rad, ahead, side, nmonsters, m1, m2, m3)
  ^mtrig
}

monstertrigger(tag, x) { typeline(36, tag, x) }

monsterbox(tag, desttag, rad, ahead, side, nmonsters, m1, m2, m3) {
  !mtrig
  movestep(ahead,side)
  forcesector(get("noisesector"))
  box(0, 256, 0, mul(rad, add(nmonsters,1)), mul(rad,3))
  pushpop(movestep(sub(rad,16), 16)
          typesector(0, tag, typeline(97, desttag,
            ibox(384, 288, 0, 16, sub(mul(rad,3),32)))))     -- wont work if noise sector floor >256!
  movestep(div(rad,2), add(rad,div(rad,2)))
  for(1, nmonsters, movestep(rad,0) placeitem3rev(0, 0, rad, m1, m2, m3))
  ^mtrig
}


------------
-- lights --
------------

-- very basic light, produces a round light at current
-- position (should be in middle of a sector), with n
-- concentric rings, each d apart from eachother, starting
-- at light level 224 and counting down 32 for each ring

light(n, d) {
  eq(n,0)
    ? 0
    : !lightcentre
      movestep(mul(n,d),0)
      rotright
      quad(curve(mul(n,d), mul(n,d), 5, 1))
      innerrightsector(getfloorheight, getceilheight, sub(256, mul(n,32)))
      ^lightcentre
      light(sub(n, 1), d)
}

-- similarly, but now places a 180 degree light to the left

light180(n, d) {
  eq(n,0)
    ? 0
    : light180(sub(n, 1), d)
      !walllightcentre
      straight(mul(n,d))
      rotleft
      twice(curve(mul(n,d), sub(0, mul(n,d)), 5, 1))
      left(d)
      leftsector(getfloorheight, getceilheight, sub(256, mul(n,32)))
      ^walllightcentre   
}

-- makes wall + alcove + light, and places mid in it

walllight(n, d, s, mid) {
  straight(s)
  rotright place(16, -16, mid) rotleft
  rightdent(32,32)
  step(-32,0)
  leftsector(add(getfloorheight,16), sub(getceilheight,16), 255)
  step(16,0)
  light180(n, d)
  movestep(16,0)
  straight(s)
}

-- a cluster of 9 things
cluster(x,gap) {
  !cluster
  movestep(mul(-1,gap),mul(-1,gap))
  forXY(3, 3,
    movestep(gap,mul(-1,mul(gap,3))),
    x movestep(0,gap)
  )
  ^cluster
}

flip {
 ifelse(eq(0,get("flip")),
    set("flip", 1),
    set("flip", 0)
   )
}
