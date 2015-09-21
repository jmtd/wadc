#"pipes.wl"

pipeloop {

    slimeinit(0, 140, 128)
    slime_control
    movestep(-512,-512) -- XXX: should be handle by slimecontrol really

    pushpop( movestep(128,128) thing ) -- XXX: put in standard.h or something

    twice( slimecurve_l )

    -- stairs down
    for(0,8,
        dec("slimefloor", 16)
        dec("slimeceil",  16)
        slimecorridor(64)
    )

    twice( slimecurve_l )

    -- stairs up
    for(0,8,
        inc("slimefloor", 16)
        inc("slimeceil",  16)
        slimecorridor(64)
    )

}
