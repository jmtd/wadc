#"sewer.h"
#"water.h"

sewerwater(x) {
        water(x, get("sewerfloor"), get("sewerceil"))
}

pipeloop {

    sewerinit
    waterinit_fwater(-64)
    movestep(-512,-512) -- XXX: should be handle by sewercontrol really

    pushpop( movestep(128,128) thing ) -- XXX: put in standard.h or something

    -- stairs down
    for(0,8,
        dec("sewerfloor", 16)
        dec("sewerceil",  16)
        sewerwater(sewerpipe(64))
    )

    twice(sewerwater(sewerleft))

    -- stairs up
    for(0,8,
        inc("sewerfloor", 16)
        inc("sewerceil",  16)
        sewerwater(sewerpipe(64))
    )

    twice(sewerwater(sewerleft))

}
