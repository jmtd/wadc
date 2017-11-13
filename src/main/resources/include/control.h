/*
 * control.h - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * routines for managing control sectors for Boom-style special effects
 * 
 * Usage: first move the cursor and orientation to an area of your map where the
 * control sectors can go. This library will draw forwards and to the right of
 * that location. Then, call 'controlinit'.
 *
 * When you want to draw a control sector, wrap the instructions in 'control()'.
 * Please move the cursor forward to the outside edge of the control sectors that
 * you have drawn and only extend forwards and to the right. XXX: things will need
 * manual handling if you need a control sector wider than 8 units.
 *
 * TODO: de-duplicate control sectors, possibly using a map data structure
 */

#"standard.h"
#"lines.h"

controlinit {
    !control -- where the next control sector will go
    !controlmargin
    set("controlstats", 0)
}

control(x) {
  inc("controlstats", 1)
  !control_return
  ^control
  set("control_lineflags_backup", getlineflags)
  setlineflags(or(getlineflags, never_automap))
  x
  up step(16,0) down
  setlineflags(get("control_lineflags_backup"))
  !control
  ^control_return
}

/*
 * control_carriage_return - temporary measure for performing a 'carriage return'
 * for control sector placement
 */
control_carriage_return {
  !control_carriage_return
  ^controlmargin
  up step(0,16) down
  !controlmargin
  !control
  ^control_carriage_return
}
