/*
 * vanilla_conveyor.h - part of WadC
 * Copyright © 2019 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * routines for building vanilla-compatible vanilla conveyors
 *
 * EXPERIMENTAL — skill1 is currently broken
 */

#"standard.h"
#"basic.h"
#"decoration.h"
#"spawns.h"
#"lines.h"
#"pickups.h"
#"control.h"

lowest { -32768 }

-- set up the conveyor infrastructure.
conveyor_init(crush)
{
  set("conveyor_stats", 0)
  control(
    -- crusher
    sectortype(0,crush)
    box(add(lowest, 32), add(lowest,52), 160, 128, 64)
    barrel
    place(64, 32, easyonly thing)
    place(64, 32, hurtmeplenty thing)
    move(128)
    sectortype(0,0)

    -- voodoo platform
    box(add(lowest, 1), add(lowest,128), 160, 64, 64)

    place(64,32, easy player1start thing)
    place(100,32, -- XXX is this far enoug not to be picked up immediately?
      stimpak thing
      healthpotion thing thing thing thing thing thing
    )
    move(64)

    !conveyor_current
    conveyor_trigger(crusher_w1_stop, crush,64)
  )
  -- we will need to grow vertically in the control area we've been allocated
  quad(control_carriage_return)
  control_carriage_return
}

conveyor_trigger(type, tag, len)
{
  !conveyor_trigger
  ^conveyor_current
  inc("conveyor_stats",1)

  straight(len)
  linetype(type, tag)
  right(64)
  linetype(0,0)
  right(len)
  right(64)
  rotright
  rightsector(lowest, add(lowest,128), 160)
  sectortype(0, 0)
  move(len)

  !conveyor_current
  ^conveyor_trigger
}

conveyor_finish
{
  !conveyor_finish
  ^conveyor_current
  conveyor_trigger(0,0, 128)
  ^conveyor_finish
}
