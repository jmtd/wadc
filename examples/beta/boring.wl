/*
 * boring.wl - boring stuff
 * used by usepipes.wl for the non-sewer pipe areas around
 * the entrance.
 *                                                 -- jmtd
 */

room(f,c,l,x,y) {
  movestep(x,y) turnaround
  box(f,c,l,x,y)
  movestep(0,y) turnaround
}

door(f,c,l) {
  !door
  top("DOOR3")
  move(24)

  linetype(1,0)
  unpegged
  right(64)
  movestep(0,-16) turnaround
  straight(64)
  unpegged
  movestep(0,-16) rotright
  linetype(0,0)
  room(f,f,l,16,64)
  ^door

  room(f,c,l,24,64)
  move(16)
  room(f,c,l,24,64)
}

bigdoor(f,c,l) {
  !bigdoor
  top("BIGDOOR1")
  move(24)

  linetype(1,0)
  unpegged
  right(128)
  movestep(0,-16) turnaround
  straight(128)
  unpegged
  movestep(0,-16) rotright
  linetype(0,0)
  room(f,f,l,16,128)
  ^bigdoor

  room(f,c,l,24,128)
  move(16)
  room(f,c,l,24,128)
}
