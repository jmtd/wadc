#"standard.h"
#"usepipes.wl"
#"boom.h"

main {
    pushpop( move(-512) rotright controlinit ) unpegged

    set("slime1", onew) -- upper sewers
    slimeinit(get("slime1"), 0, 128, 160, 24, "SLIME04", "WATERMAP", 80)

    set("slime1_5", onew) -- quads between upper/middle
    slimeinit(get("slime1_5"), -256, 128, 160, 16, "SLIME04", "WATERMAP", 80)

    set("slime2", onew) -- middle sewers
    slimeinit(get("slime2"), -256, add(-256,128), 140, 16, "SLIME04", "WATERMAP", 80)

    set("slime2_5", onew) -- quads between middle/bottom
    slimeinit(get("slime2_5"), -512, add(-256,128), 140, 16, "SLIME04", "WATERMAP", 80)

    set("slime3", onew) -- bottom sewers
    slimeinit(get("slime3"), -512, add(-512,128), 120, 40, "SLIME04", "WATERMAP", 80)

    slimeset(get("slime1"))

    /* upper circle */
    pushpop(movestep(-320,256) thing)
    rotright

    slimechoke
    slimeramp
    slimebars(0)
    slimeswitch(448, genceiling(2/*S1*/, 2 /*speed*/, 0/*model*/, 1/*direction*/, 0/*target*/, 0, 0), $bars1)
    slimebars($bars1)
    slimechoke    slimecurve_l  slimechoke

    slimecorridor(96)
    slimechoke
    slimelift(get("slime1_5"), 0, 0, 256, $lift1)
    slimechoke
    slimecorridor(96)

    slimechoke    slimecurve_l   slimechoke

    slimecorridor(96)
    slimechoke
    slimelift(get("slime1_5"), 0, 0, 24, $lift2)
    slimechoke
    slimecorridor(96)

    slimechoke
    slimecurve_l
    slimechoke
    slimecorridor(512)
    slimechoke
    slimecurve_l

    /* middle circle */

    movestep(512,-512)
    movestep(64, -32) slimeset(get("slime2"))

    slimecorridor(96) slimechoke
    move(256)
    slimechoke slimecorridor(96)
    !bottom
    slimelift(get("slime2_5"), 0, 0, 256, $lift3)

    slimechoke    slimecurve_l   slimechoke
    slimecorridor(512)
    slimechoke   slimecurve_l   slimechoke
    slimeramp
    slimecorridor(512)
    slimecorridor(256)
    slimechoke    slimecurve_l   slimechoke

    slimecorridor(96) slimechoke
    move(256) slimechoke
    slimebars(0)
    slimecorridor(64)

    slimechoke
    slimecurve_l
    slimechoke

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





    print(get("controlstats"))
    print("control sectors")
}
