/*
 * 2countrev.wl: 2 bit binary counter which activates trap doors when it overflows.
 * See also counter.wl
 * part of WadC
 *
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"control.h"
#"basic.h"
#"boom.h"
#"monsters.h"

main {
    -- control lines for scrolling
    linetype(253, $scroll_north_ish) step(256,-64)
    linetype(253, $scroll_east_ish)  step(64,256)
    linetype(253, $scroll_south_ish) step(-256,64)
    linetype(253, $scroll_west_ish)  step(-64,-256)
    leftsector(0,0,0)
    linetype(0,0)

    countertextures

    move(512)
    !main
    counters(2)
    
    ^main
    movestep(256,-64) rotleft
    revdoor
    movestep(0,-64)
    revroom
 
    ^main
    movestep(448,64)
    revdoor
    movestep(0,-64)
    revroom

    ^digits
    movestep(64,64)
    revdoor
    movestep(0,-64)
    revroom

}

revdoor {
  top("BIGDOOR1")
  box(0,80,160,16,128)
  move(16)
  sectortype(0,$revdoor)
  top("BIGDOOR1")
  box(0,0,160,16,128)
  top("BRICK7")
  sectortype(0,0)
  move(16)
  box(0,80,160,16,128)
  move(16)
}

revroom {
  box(0,80,160,256,256)
  movestep(224,224)
  turnaround
  revenant
  for(0,3,
    for(0,2, thing move(64))
    movestep(-192,64)
  )
}


/*
 * some custom textures for the counter display
 * (etc)
 */
countertextures {
    -- custom texture for binary display
    texture("RIPPLE", 64, 128)
    addpatch("COMP03_1", 0, 0)
    addpatch("COMP03_2", 0, 64)
    addpatch("WINUM0",   0, 116)
    addpatch("WINUM1",  32, 116)

    -- redefine switch textures
    texture("SW1STRTN", 64, 128)
    addpatch("RW24_2", 0, 0)
    addpatch("SW1S0", 16, 72)
    texture("SW2STRTN", 64, 128)
    addpatch("RW24_2", 0, 0)
    addpatch("SW1S1", 16, 72)
}

counters(x) {
    -- ripple counters themselves
    -- from most signifiant bit to least
    set("carry", $revdoor)
    fori(1, x,
      set("current", newtag)
      set(cat("show",i), counter(get("current"), get("carry")))
      set("carry", get("current"))
      movestep(0,256)
    ) 

    -- viewing space
    ^main
    movestep(192,-64)
    unpegged
    sectortype(0, 0)

    counterswitch
    straight(128)
    counterswitch

    rotright
    counterswitch
    straight(sub(mul(x,256),64))
    !digits

    counterswitch
    rotright
    counterswitch
    straight(128)
    counterswitch
    rotright
    counterswitch
    straight(sub(mul(x,256),64))
    counterswitch
    rightsector(0,128,160)

    ^digits
    move(-64) rotleft
    fori(1, x,
      digit(get(cat("show",i))) movestep(0,-64)
    )

    placeitem(-64, 0, turnaround player1start)
}

counterswitch {
    linetype(gendoor(trigger_s1,
      speed_turbo,
      door_open_delay_close,
      0,
      door_delay_1s), get("current"))
    mid("SW1STRTN")
    straight(64)
    mid("BRICK7")
    linetype(0,0)
}

/*
 * a big 1/0 digit display
 */
digit(tag) {
  !digit
    top("RIPPLE") bot("RIPPLE")
    straight(2) xoff(32) yoff(96) right(32) xoff(0) yoff(0) right(2) right(32) rotright rightsector(48,80,144)
    move(2)
    sectortype(0,tag)
    straight(2) yoff(96) right(32) yoff(0) right(2) right(32) rotright rightsector(48,80,144)
    sectortype(0,0)
    move(2)
    box(80,80,144,2,32)
  ^digit
}

/*
 * counter - a binary ripple register
 * 	tag - the sector tag value for activating/incrementing this register
 * 	carry - the sector tag value of the next counter register to carry into 
 * 	returns: a tag value to use for displaying the register value
 */
counter(tag, carry) {
    -- XXX: these directions are a bit misleading because of the WadC/Doom
    -- disagreement on the X axis direction
    set("counter", newtag)
    sectortype(0, $scroll_east_ish)  trapezium(get("counter"),83)  guard(tag,carry) movestep(0,192) rotleft
    sectortype(0, $scroll_north_ish) trapezium(0,0)                                 movestep(0,192) rotleft
    sectortype(0, $scroll_west_ish)  trapezium(get("counter"),84)  guard(tag,0)     movestep(0,192) rotleft
    sectortype(0, $scroll_south_ish) trapezium(0,0)                                 movestep(0,192) rotleft
    placeitem(96,32,rotright player1start)

    get("counter")
}

/*
 * recv is the receiver of the value (counter display)
 */
trapezium(recv,type) {
    step(80,80)
    step(0,32)
    { eq(recv,0) ? 0 : linetype(type, recv) } step(-80,80) linetype(0,0)
    impassable step(0,-192) impassable
    rightsector(16,80,120)
}

/*
 * door used to gate the counters
 */
guard(tag,carry) {
  !guard
    movestep(72,100)
    left(8)
    { eq(0,carry) ? 0 : linetype(gendoor(
          trigger_wr,
          speed_turbo,
          door_open_delay_close,
          0,
          door_delay_1s), carry) } left(64) linetype(0,0)
    left(8)
    left(64)
    sectortype(0,tag) innerleftsector(16,16,0) sectortype(0,0)
  ^guard
}
