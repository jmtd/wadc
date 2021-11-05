/*
 * vanilla_conveyor.wl - part of WadC
 * Copyright © 2019 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * Simple demonstration of vanilla conveyors
 */

#"standard.h"
#"basic.h"
#"decoration.h"
#"spawns.h"
#"lines.h"
#"pickups.h"
#"control.h"
#"vanilla_conveyor.h"

main
{
  rotright
  controlinit
  conveyor
  rotleft

  !start

  -- player area
  box(add(lowest, 32), add(lowest,add(32,128)), 160, 128, 768)
  linetype(crusher_s1_slow, $conveyor1)
  place(64,32, bot("SW1EXIT") ibox(add(lowest, 64), add(lowest,add(32,128)), 160, 16, 32))
  linetype(0,0)

  -- stuff so we can see the results of triggers 
  movestep(128,0)

  -- a series of doors to open
  movestep(0,64)
  top("BIGDOOR2")
  gap
  testdoor($door1)
  gap
  testdoor($door2)
  gap
  testdoor($door3)
  gap


  ^start
  place(32, 32, player1start thing)
}

conveyor
{
  conveyor_init($conveyor1)

  conveyor_trigger(door_w1_openclose,$door1, 128)
  conveyor_trigger(door_w1_openclose,$door2, 128)
  conveyor_trigger(door_w1_openclose,$door3, 128)

  conveyor_finish
}

testdoor(tag)
{
  sectortype(0,tag)
  box(add(lowest, 32), add(lowest, 32), 160, 16, 128)
  sectortype(0,0)
  move(16)
}

gap
{
  box(add(lowest, 32), add(lowest, 144), 160, 16, 128)
  move(16)
}
