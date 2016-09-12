#"standard.h"
#"usepipes.wl"
#"boom.h"

main {
    pushpop( move(-512) rotright controlinit ) unpegged

    set("slime1", onew) -- upper sewers
    slimeinit(get("slime1"), 0, 128, 160, 24, "SLIME04", "WATERMAP", 80, "BRICK7")

    set("slime1_5", onew) -- quads between upper/middle
    slimeinit(get("slime1_5"), -256, 128, 160, 16, "SLIME04", "WATERMAP", 80, "BRICK7")

    set("slime2", onew) -- middle sewers
    slimeinit(get("slime2"), -256, add(-256,128), 140, 16, "SLIME04", "WATERMAP", 80, "GRAY1")

    set("slime2_5", onew) -- quads between middle/bottom
    slimeinit(get("slime2_5"), -512, add(-256,128), 140, 16, "SLIME04", "WATERMAP", 80, "GRAY1")

    set("slime3", onew) -- bottom sewers
    slimeinit(get("slime3"), -512, add(-512,128), 120, 32, "SLIME04", "WATERMAP", 80, "ICKWALL3")

    slimeset(get("slime1"))

    /* upper circle */
    pushpop(movestep(-320,256) thing)
    rotright

    slimechoke
    slimeramp(480, 0)
  --  slimeswitch(448, genceiling(2/*S1*/, 2 /*speed*/, 0/*model*/, 1/*direction*/, 0/*target*/, 0, 0), $bars1)
    slimebars($bars1)
    slimechoke
    slimecurve_l
    slimechoke

    slimesecret2
    slimecorridor(448)
    slimechoke
    slimecurve_l
    slimechoke

    slimecorridor(96)
    slimechoke
    slimequad(get("slime1_5"), get("slime1"), get("slime1"), get("slime2"), get("slime2"))
    slimechoke
    slimecorridor(96)

    slimechoke
    slimecurve_l
    slimechoke
    slimecorridor(512)
    slimechoke
    slimecurve_l

    /* middle circle */

    movestep(1024,-512) -- XXX magic numbers...
    movestep(64, -32)
    slimeset(get("slime2"))

    !bottom
    slimequad(get("slime2_5"), get("slime3"), get("slime3"), get("slime2"), get("slime2"))

    slimechoke
    slimecurve_l
    slimechoke

    slimecorridor(96)
    slimechoke
    slimequad(get("slime2_5"), get("slime2"), get("slime2"), get("slime3"), get("slime3"))
    slimechoke
    slimecorridor(96)

    slimechoke
    slimecurve_l
    slimechoke
    slimeramp(512,0)
    slimecorridor(256)
    slimechoke    slimecurve_l   slimechoke

    slimecorridor(96) slimechoke
    move(256) slimechoke
    slimebars(0) slimefade(0)

    /* bottom circle */
    ^bottom rotright movestep(256,-256)
    slimeset(get("slime3"))
    slimechoke
    slimecorridor(96)
    slimechoke
    slimecurve_l
    slimechoke
    slimecorridor(512)
    slimechoke
    slimecurve_l
    slimechoke
    slimecorridor(512)
    slimechoke
    slimecurve_l
    slimechoke
    slimecorridor(256)
    move(256)
    slimechoke
    slimecurve_l
    slimechoke
    slimecorridor(96)
    slimechoke


    print(cat(get("controlstats"), " control sectors"))
}
