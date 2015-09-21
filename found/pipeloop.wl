#"pipes.wl"

pipeloop {


    slimeinit(0, 140, 128)
    slime_control
    movestep(-512,-512)

    pushpop( movestep(128,128) thing )

    twice( slimecurve_l )

    -- stairs down
    for(0,8,
        set("slimefloor", sub(get("slimefloor"), 16))
        set("slimeceil", sub(get("slimeceil"), 16))
        slimecorridor(64)
    )

    twice( slimecurve_l )

    -- stairs up
    for(0,8,
        set("slimefloor", add(get("slimefloor"), 16))
        set("slimeceil", add(get("slimeceil"), 16))
        slimecorridor(64)
    )

}
