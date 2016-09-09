#"standard.h"
#"usepipes.wl"
#"boom.h"

main {
    pushpop( move(-512) rotright controlinit ) unpegged

    set("slime1", onew)
    slimeinit(get("slime1"), 0, 128, 140, 24, "SLIME04", "WATERMAP", 80)

    set("slime05", onew)
    slimeinit(get("slime05"), -256, 128, 140, 16, "SLIME04", "WATERMAP", 80)

    set("slime2", onew)
    slimeinit(get("slime2"), -256, add(-256,128), 120, 16, "SLIME04", "WATERMAP", 80)

    slimeset(get("slime1"))

    /* upper circle */

    rotright
    pushpop(movestep(64,64) thing)

    slimeswitch(512, genceiling(2/*S1*/, 2 /*speed*/, 0/*model*/, 1/*direction*/, 0/*target*/, 0, 0), $bars1)
    slimebars($bars1)
    slimechoke    slimecurve_l  slimechoke

    slimecorridor(96)
    slimechoke
    slimelift(get("slime05"), 0, 0, 256, $lift1)
    slimechoke
    slimecorridor(96)

    slimechoke    slimecurve_l   slimechoke

    slimecorridor(96)
    slimechoke
    slimelift(get("slime05"), 0, 0, 24, $lift2)
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

    slimechoke    slimecurve_l   slimechoke
    slimecorridor(512)
    slimechoke   slimecurve_l   slimechoke
    slimecorridor(512)
    slimechoke    slimecurve_l   slimechoke

    slimecorridor(96) slimechoke
    move(256) slimechoke
    slimecorridor(96)

    slimechoke
    slimecurve_l
    slimechoke

    print(get("controlstats"))
    print("control sectors")
}
