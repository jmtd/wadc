/*
 * demo of a looping sewer pipe/corridor, which dips down under
 * a water level and back up again
 *                                                 -- jmtd
 */

#"sewer.h"
#"water.h"

sewerwater(x) {
        water(x, get("sewerfloor"), get("sewerceil"))
}

main { pipeloop }

pipeloop {

    sewerinit
    controlinit
    movestep(-512,-512)
    waterinit_fwater(-64)

    -- TODO: I write this a lot. Should I put it in standard.h?
    pushpop( movestep(128,128) thing )

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
