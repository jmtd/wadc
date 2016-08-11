#"standard.h"

/*
 * prove that mixing linetype/linetypehexen works OK:
 *     * using linetype() in hexen-format WADs sets type and tag correctly
 *     * linetype() resets args 2-5 so they don't bleed out to later lines
 */

main {
    hexenformat
    linetypehexen(1,2,3,4,5,6)
    straight(128) /* should be 1,2,3,4,5,6 */
    linetype(0,0)
    right(128)    /* should be 0,0,0,0,0,0 */
    linetype(7,8)
    right(128)    /* should be 7,8,0,0,0,0 */
    linetype(0,0)
    right(128)    /* should be 0,0,0,0,0,0 */
    rightsector(0,128,160)
    rotright
    movestep(64,64)
    thing
}
