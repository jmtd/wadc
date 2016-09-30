/* case of overlapping lines, boiled down from the old "turnaround" workaround */

#"standard.h"

main {

    pushpop(
    movestep(64,64)
    rotright
    quad(right(64))
    rightsector(0,128,160)
    )

    movestep(64,0)

    straight(128)
    triple(right(128)) 
    rightsector(0,128,160)

}
