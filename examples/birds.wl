/*
 * birds.wl: A Dead Simple/Tower of Babel style map for Heretic
 * part of WadC
 *
 * Copyright © 2017 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * This map was included  as E1M6 in the "Heretic Upstart Mapping Project":
 * <https://www.doomworld.com/forum/topic/95636-heretic-upstart-mapping-project-released/>
 *
 * The original concept behind this map was to create some kind of internal
 * environment with large open windows, quite pleasant. THe idea was you would
 * be fighting gargoyles: the lowest tier enemy, normally written off as a
 * frustration. But, they would have much more freedoom of movement than you,
 * because they can fly through the windows, short-circuiting routes between
 * corridors. They are also more menacing in numbers, and I wanted to add more
 * and more via waves. In terms of arsenal, I quite enjoy the Dragon Claw so
 * I imagined that being the weapon of choice for these encounters.
 *
 * I struggled to come up with a pleasant internal layout and put in place a
 * cross/star-shaped arrangement of corridors as a placeholder. Once that was
 * in place, a lot of the rest of the map came quite easily, and so I stuck with
 * it. A common criticism of algorithmic level generation is that the resulting
 * levels are very symmetrical, and that's certainly true of this level; but in
 * this case the limitation was with my creativity, rather than the tool.
 *
 * The next big challenge with a Heretic map is texturing. Heretic has a remarkably
 * small set of textures and flats compared to other Doom games. However I find
 * that a little easier, as an infrequent mapper, not as overwhelming. I settled
 * quite quickly on a pairing of dark black metal versus sand. At the last minute
 * I ended up embellishing the black areas with green marble. Hopefully I came up
 * with something that doesn't just look like "every other Heretic map". I was
 * particularly happy with how the black metal/panel texture looked once mutated
 * into a diagonal around my diagonal windows: a happy accident.
 *
 * The ugliest function(s) are undoubtable "courtyard". It started off simple,
 * defining a closed, convex geometric region, defining some anchor points around
 * the perimiter as it was originally drawn, then jumping back to those anchors to
 * add walls, etc.
 *
 * As time went on, that perimeter got more and more complicated, with odd shaped
 * cut-outs for the star-shaped turrets, the gallows, etc. As a result the legibility
 * has greatly suffered. I've been trying to think of how that could be avoided.
 * One thing I'm becoming more convinced about is, where two or more regions share
 * a complex boundary, that boundary should be defined once, in its own function.
 * I'm only recently coming to the realisation of the power of collecting a bunch
 * of draw instructions separately from the sector-definition functions that
 * normally follow.
 */

#"standard.h"
#"basic.h"
#"heretic.h"
#"control.h"
#"sectors.h"

skyheight    { knob("skyheight",    0, 192, 2048) }
wallheight   { knob("wallheight",   0, 96,  256) }
turretheight { knob("turretheight", 0, 160, 1024) }
ceilheight   { knob("ceilheight",   0, 136, 1024) }
skybright    { knob("skybright",    0, 150, 255) }
housebright  { knob("housebright",  0, 200, 255) }

main {
  hereticdefaults
  mapname("E1M8")
  housetex
  controlinit
  movestep(1664,768)
  undefx
  set("flip", 0)
  !start

  hub(!north,!east,!south,!west)

  ^north spoke(turnaround starts,
    $tomb1, $tomb1, floor_w1_down_HnF, crystalvial, $spoke1)

  ^east spoke(turnaround deathmatchstart thing artitomeofpower thing,
    $tomb1, $tomb2, floor_w1_down_HnF, amgwndwimpy, $spoke2)

  ^west spoke(turnaround dragonclaw thing deathmatchstart thing,
    $tomb2, $tomb3, floor_w1_down_HnF, amblsrwimpy, $spoke3)

  ^south spoke(turnaround deathmatchstart thing phoenixrod thing,
    $tomb3, $window, floor_w1_down_LnF_TxTy, amblsrwimpy, $spoke4)

  -- northeast
  -- outertag, innertag, walktag, triggertype, outer button tag, outer button type
  ^north
  courtyard($tomb1, $pillar2, $pillar3, floor_w1_down_LnF_TxTy, 0, 0)

  ^east
  courtyard($tomb2, $pillar3, $pillar4, floor_w1_down_LnF_TxTy, 0, 0)

  ^south
  courtyard($tomb3, $pillar4, $lastbutton, floor_w1_down_LnF_TxTy, $crushme, crusher_w1_slow)

  ^west
  courtyard($window, $window, $pillar2, floor_w1_down_LnF_TxTy, 0, 0)

  -- monster boxes!
  setlineflags(or(getlineflags,never_automap))
  control(
    monsterbawx($pillar2, $spoke1, cluster(easyonly imp thing hurtmeplenty mummy thing, 48))
    monsterbawx($pillar3, $spoke2, cluster(easyonly imp thing hurtmeplenty mummy thing, 48))
    monsterbawx($pillar4, $spoke3, cluster(easyonly imp thing hurtmeplenty mummy thing, 48))
    monsterbawx($window,  $spoke4, cluster(easyonly imp thing hurtmeplenty mummy thing, 48))

    monsterbawx($pillar2, $pillar2, easyonly imp cluster(thing, 48) hurtmeplenty iron_liche thing)
    monsterbawx($pillar3, $pillar3, easyonly imp cluster(thing, 48) hurtmeplenty iron_liche thing)
    monsterbawx($pillar4, $pillar4, clearflag(skill4_5) setflag(or(skill1_2, skill3)) imp cluster(thing, 48) ultraviolence iron_liche thing)

    -- doesn't teleport, will be crushed to trigger tag 666 on skill1_2
    crushbox(0, 0, easyonly iron_liche thing)
  )
}



housetex {
  floor("FLOOR18")
  ceil("FLOOR30")
  top("METL2")
  mid("METL1")
  bot("METL2")
}

outdoors {
  floor("FLOOR27")
  ceil("F_SKY1")
  mid("SNDPLAIN")
  bot("SNDPLAIN")
}



hub(n,e,s,w) {
  !hub

  pushpop( move(32) rotleft w )
  mid("METL2") step(192, 0)
  mid("METL1") step(128, 128)
  pushpop( movestep(0,32) n )
  rotright
  mid("METL2") step(192, 0)
  mid("METL1") step(128,128)
  pushpop( movestep(0,32) e )
  rotright
  mid("METL2") step(192, 0)
  mid("METL1") step(128,128)
  pushpop( movestep(0,32) s )
  rotright
  mid("METL2") step(192, 0)
  mid("METL1") step(128, 128)
  rotright

  rightsector(8, ceilheight, housebright)
  set("hubsector", lastsector)

  movestep(0,128)
  ceil("F_SKY1")
  edged_ibox(0, skyheight, add(24,housebright), 192, 192, 32)

  movestep(64, 64)
  floor("FLOOR21")
  edged_ibox(8, skyheight, add(48,housebright), 64, 64, 16)

  movestep(32, 0)
  linetype(exit_w1_normal, 0)
  quad(curve(32, 32, 4, 0))
  sectortype(0, 666)
  innerrightsector(128, add(16, ceilheight), add(housebright, 16))
  set("exitsector", lastsector)
  linetype(0, 0)
  sectortype(0, 0)
  place(0, 32, teleglitgen2 thing)

  ^hub
}


spoke(x,tombtag,walktag,trig,ammo,spoketag) {
  !spoke

  sectortype(0, spoketag)
  place(256,64, teleportman thing)
  bot("METL2")
  box(8, ceilheight, housebright, 512, 128)

  sectortype(0, 0)

  ammo
  place(96,64,  easyonly fori(1,3, thing move(128)))
  place(160,64, easy fori(1,3, thing move(128)))

  movestep(16,32)

  floor("FLAT520")
  sectortype(0,tombtag)
  bot("SKULLSB1")
  ibox(48, ceilheight, housebright, 16, 64)
  sectortype(0,0)
  popsector

  -- ceiling openings & windows
  ^spoke movestep(0,16) skylights(512)
  ^spoke movestep(0,128) windows(512)
  ^spoke move(512) turnaround windows(512)

  -- diamond tip
  ^spoke
  movestep(512, 0)
  mid("METL2")
  step(64,-64)
  step(64,0)
  step(128,128)
  step(-128,128)
  step(-64,0)
  step(-64,-64)
  step(0,-128)

  rightsector(8, ceilheight, housebright)

  movestep(64,32)
  nicebutton(16, ceilheight, 200, 0, 0, trig, walktag)
  movestep(16, 16)
  x
}

-- nicebutton: draws a nice 64x64 button, with a raised 32x32 button
-- on the inside. Outer and inner lines are set to outer/inner trigger
-- and tag values. The button sector triggers itself (expected to be
-- used with floor lowering types)
nicebutton(f,c,l, outertrig, outertag, innertrig, innertag) {
  floor("FLAT500")
  bot("GRSKULL1")
  linetype(outertrig, outertag)
  ibox(f,c,l, 64, 64)
  movestep(16,16)
  linetype(innertrig, innertag)

  sectortype(0, innertag)
  ibox(add(8,f), c, l, 32, 32)
  sectortype(0, 0)
  linetype(0, 0)
}


/*
 * a box (w wide h tall) with a wedge cut out of the corners (wedge length √(2e²))
 */
edged_ibox(f, c, l, w, h, e) {
  move(e)
  straight(sub(h, mul(2,e))) step(e,e) rotright
  straight(sub(w, mul(2,e))) step(e,e) rotright
  straight(sub(h, mul(2,e))) step(e,e) rotright
  straight(sub(w, mul(2,e))) step(e,e) rotright
  innerrightsector(f, c, l)
  move(mul(e,-1))
}

skylights(x) {
  lessthaneq(256,x)
    ? {
      move(48)
      ceil("FLAT500") top("SKULLSB1")
      edged_ibox(8, sub(skyheight, 32), add(housebright, 16), 96, 160, 16)
      place(17, 17,
        ceil("F_SKY1")top("METL2")
        edged_ibox(8, skyheight, add(housebright, 24), sub(96,34), sub(160,34), 8)
      )
      twice(popsector)
      move(add(80,128))
      skylights(sub(x,256))
    }
    : 0
}

windows(x) {
  walltorch
  lessthaneq(256,x)
    ? {
      place(0, -8, thing)
      move(64)
      window
      move(192)
      place(0, -8, thing)
      windows(sub(x,256))
    }
    : 0
}

-- a pointy-ceiling. TODO: generalise/extrapolate the 32/16 specifics
step_slope_ceiling(f, c, l) {
  fori(1,32, box(f, add(i,c), l, 2, 16) move(2)) -- slope up
  fori(1,32, box(f, sub(add(c,32),i), l, 2, 16) move(2)) -- slope down
}

window {
  !window
  floor("FLOOR30") ceil("FLOOR30")
  mid("METL2") -- the returns
  top("METL1") bot("METL2") -- for outside
  sectortype(0,$window)

  step_slope_ceiling(40, 64, housebright)

  ^window
  sectortype(0, 0)
}

/*
   courtyard - one of 4 outdoor regions (NE,SE,SW,NW) between the spokes

   The ugliest function in this map. Broadly operates by:
   * walking the outline of the region, with cut-outs for detailing that is
     added later, dropping !anchors as we go
   * returning to each of those anchors to perform the detailing

   The outer area of the courtyard has three walls with a turret structure
   at the joins.
 */
courtyard(outertag, innertag, walktag, triggertype, outer_button_tag, outer_button_type) {

  movestep(-64,64)
  movestep(0, 184)
  movestep(0, -24)
  movestep(8,8) --XXX merge

  !courtyard

  step(88, -88)
    straight(416) !lightcast1 straight(64)
      step(64,64)
        straight(64)
          step(144,-144)

            outdoors
            straight(240)
            !courtyard_wall1
            rotright
              straight(192)
              !gallows
              top("WOODWL")
                right(128) left(32) left(128) rotright
                  straight(128) !turret1

                    bot("METL2")
                    step(32,32)
                    step(0,64)
                    step(64,0)
                    step(32,32)
                    step(32,-32)

                      outdoors
                      !courtyard_wall2
                      step(640, 640)

                    bot("METL2")
                    step(-32,32)
                    !turret2
                    step(32,32) step(0,64) step(64,0) step(32,32)

                  outdoors
                  !courtyard_wall3
                  right(192)
                !gallows2
                right(128) left(32) left(128) rotright
              straight(128)
            right(240)

          mid("METL1")
          step(144, 144)
        straight(64)
      step(64,-64)
    straight(448) !lightcast2 straight(32)
  step(88, 88)

  rightsector(0, skyheight, skybright)

  -- three timebombs along the diagonal outside edge of the hub
  timebomb
  movestep(-44, -44)
  movestep(-16, 16)
  thing
  movestep(44, 44)
  thing
  movestep(44,44) thing

  -- light casting from the spoke windows
  ^lightcast1
  outdoors
  lightcast1
  ^lightcast2
  lightcast2

  -- outdoor "crate" secret
  ^courtyard
  movestep(0, 832) movestep(-8,-8) outdoors bot("SANDSQ2")
  ammosecret
  easy -- reset thing flags

  ^courtyard
  outdoors
  movestep(280, 280)
  implights
  movestep(32, 32)
  impbox(outertag, innertag, triggertype, walktag, outer_button_type, outer_button_tag)

  ^turret1 newturret
  ^turret2 newturret

  ^courtyard_wall1
  straight(64)
  right(384) -- 384 416
  right(32) rotright
  step(32,-32)
  straight(128)
  top("WOODWL")
  right(48) left(32) left(48) rotright
  straight(192)
  rotright
  rightsector(wallheight, skyheight, skybright)
  pushpop(^gallows rotleft move(48) rotright gallows(24))
  pushpop(^gallows2 movestep(0,-48) gallows(16))
  move(64)
  box(0, 0, skybright, 64, 384)
  movestep(64, 384) rotright
  straight(96)
  step(-32,32)
  turnaround straight(64)
  right(32)
  rightsector(0, 0, skybright)
  movestep(0,96)
  right(96) right(32)right(64)step(32,32)
  rightsector(0, 0, skybright)

  ^courtyard_wall2 -- facing east
  straight(64)
  left(64)
  step(-640, 640)
  step(0,-64) step(-64,0)
  turnaround
  step(-640, 640)
  rightsector(wallheight, skyheight, skybright)
  --sky box
  turnaround -- facing north
  movestep(64,64)
  step(32,32)
  step(32,-32)
  step(64,0)
  step(-768,768) !xtrasky
  step(0,-64)
  step(32,-32) step(-32,-32)
  step(640, -640)
  rightsector(0, 0, skybright)
  -- little extra skybox
  ^xtrasky -- north facing
  step(-32,32) step(-64,0)
  step(32,-32) step(64,0)
  rightsector(0, 0, skybright)

  ^courtyard_wall3
  step(32,-32)
  bot("METL2") step(32,0)
  right(384) right(64) right(128)
  right(48) left(32) left(48) rotright !gallows2
  straight(192) rotright
  rightsector(wallheight, skyheight, skybright)
  movestep(64,-32)
  straight(32)
  left(64)
  step(32,32) turnaround
  straight(480) right(64) right(384)
  rightsector(0, 0, skybright)

  -- ammo
  ^courtyard_wall2
  amphrdwimpy
  movestep(64,128)
  triple(thing movestep(234,234))
  ^courtyard_wall2 rotleft
  movestep(-256,128)
  amgwndhefty
  twice(thing movestep(-256,256))
}

-- secret box crate thing
ammosecret {
  set("boxtrig", newtag)
  linetype(sr_lift, get("boxtrig"))
  sectortype(0, get("boxtrig"))
  ibox(56,skyheight,skybright,64,64)
  movestep(2,2)
  sectortype(sectortype_secret,0)
  quad(straight(60) rotright)
  innerrightsector(8,skyheight,skybright)
  linetype(0,0)
  sectortype(0,0)
  twice(popsector)	
  place(30,30, easy clearflag(skill4_5) quartz_flask thing
  ultraviolence ifelse(eq(0,get("flip")), quartz_flask, crystalvial) flip thing)
}


-- david's star-style turrets: six points around a square with recessed fire braziers
newturret {
  bot("METL2") mid("METL2")
  quad(
    step(32,-32) step(0,64) step(-32,-32)
    rightsector(128, skyheight, 200)
    movestep(128,128) rotleft
  )
  movestep(32,96) rotleft
  quad(
    step(64,0) step(-64,64) step(0,-64)
    rightsector(128, skyheight, 200)
    move(192) rotright
  )
  move(64)
  quad(straight(64) step(64,64) rotright)
  rightsector(160, skyheight, 200)
  movestep(-32,32)
  ibox(sub(160,32), skyheight, 256, 128,128)
  movestep(64,64)
  firebrazier
  cluster(thing, 32)
}

/*
   lightcast/cone/etc. - pools of light from the spoke windows
   the pools of light from the windows nearest the hub intersect
   hence lightcast1 (non-intersected cone) and lightcast2
   (intersected); both defined in terms of segments lightcone_l1,
   lightcone_l2, lightcone_r1, lightcone_r2

   innercone is the inner, brighter cone of light; these do not
   intersect
 */
lightcast1 {
  rotright
  movestep(8,0)
  lightcone
  innerrightsector(0, skyheight, add(skybright, 16))
  pushpop(
    movestep(8,14)
    innercone
    innerrightsector(0, skyheight, add(skybright, 32))
  )
  twice(popsector)
  movestep(0,256)
  lightcone_l
  up lightcone_r1 down
  lightcone_r2
  pushpop(movestep(8,14) !innercone)
}

lightcast2 {
  rotright
  movestep(8,0)
  lightcone_l1
  up lightcone_l2 down
  lightcone_r
  innerrightsector(0, skyheight, add(skybright, 16))
  pushpop(
    movestep(8,14)
    innercone
    innerrightsector(0, skyheight, add(skybright, 32))
  )
  popsector
  pushpop(
    ^innercone
    innercone
    innerrightsector(0, skyheight, add(skybright, 16))
  )
  twice(popsector)
  movestep(0,256)
  lightcone
  innerrightsector(0, skyheight, add(skybright, 16))
  pushpop(
    movestep(8,14)
    innercone
    innerrightsector(0, skyheight, add(skybright, 32))
  )
  twice(popsector)
}

-- a cone of light sector, decomposed into left and right halves,
-- and further decomposed into L part 1, part 2 etc.; the division
-- corresponds to where two light cones overlap in the map
lightcone {
  lightcone_l
  lightcone_r
}
lightcone_l {
  lightcone_l1
  lightcone_l2
}
lightcone_l1 {
  step(64,-32)
    step(64,-8)
      step(36,4)
} lightcone_l2 {
      step(28,4)
        step(56,64)
          step(16,32)
}
lightcone_r {
  lightcone_r1
  lightcone_r2
}
lightcone_r1 {
          step(-16,32)
        step(-56,64) 
      step(-28,4)
} lightcone_r2 {
      step(-36,4)
    step(-64,-8)
  step(-64,-32)

  step(0,-128)
}

-- 80% the size of lightcone; no overlap
innercone {
  step(51,-26)
    step(51,-6)
      step(29,3)
      step(22,3)
        step(45,51)
          step(13,26)
         step(-13,26)
        step(-45,51)
      step(-22,3)
      step(-29,3)
    step(-51,-6)
  step(-51,-26)
  step(0,-102)
}

-- variable height gallows
gallows(s) {
  ceil("floor10")
  top("WOODWL")
  box(wallheight, sub(skyheight, s), skybright, 32, 48)
  place(1,1, ibox(0, 0, skybright, 30, 30))
  movestep(0,48)
  box(0, sub(skyheight, s), skybright, 32, 128)
  ceil("floor10")
  place(16, 120, hangingcorpse thing deathmatchstart thing)
}

/*
   "flower" of light cast by braziers around the imp boxes
 */
implights {
  !implights
  move(128)
  rotright
  -- outer 'flower' shape
  quad(turnaround triple(curve(128, 128, 4, 0)))
  innerrightsector(0, skyheight, add(skybright, 16))

  -- inner
  rotleft movestep(128, -96)
  movestep(-96, 96) rotleft
  quad( 
    triple(curve(96, 96, 4, 0))
    step(30,4) right(62) left(62) rotright step(30,-4)
    innerrightsector(0, skyheight, add(skybright, 32))
    popsector
    rotright movestep(96, 160)
  )

  ^implights
}

/*
    imp boxes
    large enclosed region containing imps
    also containing an inner pillar textured SAINT1
    which is dropped by a trigger and contains a nicebutton
    (which triggers the next one along)
*/
-- three tags
--   first tag controls dropping the box walls
--   second tag controls dropping the inner pillar
--   third tag is triggered when walked over the pillar
impbox(outertag, innertag, triggertype, walktag, outer_button_type, outer_button_tag) {
  !impbox
  ceil("F_SKY1")
  floor("FLOOR30")
  bot("METL1")
  sectortype(0, outertag)
  ibox(skyheight, skyheight, add(skybright, 32), 192, 192)
  sectortype(0, 0)
  pushpop(
    movestep(8,8)
    floor("FLOOR27")
    ibox(-8, skyheight, add(skybright, 32), 176, 176)

    -- exit technique
    pushpop(movestep(56, 56)
      floor("FLAT500")
      sectortype(0, innertag)
      bot("SAINT1")
      place(-4, -4, ibox(128, skyheight, add(skybright, 32), 72, 72))
      sectortype(0, 0)
      nicebutton(0, skyheight, add(skybright, 32), outer_button_type, outer_button_tag, triggertype, walktag)
      movestep(16,16) teleportman thing
    )
    linetype(0,0)
    sectortype(0,0)
  )
  movestep(88, 88)
  rotleft
  imp cluster(thing, 48)
  ^impbox movestep(-32,-32) firebrazier quad(thing move(256) rotright)
}

starts {
  !starts
  move(-64)
  player1start thing
  deathmatchstart thing
  move(128)
  player2start thing
  movestep(-64,-64)
  player3start thing
  movestep(0,128)
  player4start thing
  ^starts
}

/*
    off-map joined-sector for waking up monsters and later
    teleporting them into the game area

    XXX: we could look at using monsterbox from basic.h
*/
monsterbawx(opentag, desttag, monsters) {
    forcesector(get("hubsector"))
    linetype(teleport_wr, desttag)
    box(0,0,0, 256, 256)
    place(128, 128, monsters)
    move(256)
    sectortype(0, opentag)
    box(128,128,0, 64, 256)
    sectortype(0, 0)
    linetype(0, 0)
    movestep(-256, 320)
}

-- variation of the above: no joined sector; no teleport line
crushbox(opentag, desttag, monsters) {
    sectortype(0, $crushme)
    box(0,128,200, 256, 256)
    place(128, 128, monsters)
    move(256)
    sectortype(0, 0)
    linetype(0, 0)
    movestep(-256, 320)
}
