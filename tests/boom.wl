/*
 * boom.wl - part of WadC
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * Test of (some) Boom generalised linedef types
 * Untested: locked doors, stairs and crushers, and various flag combinations
 */

#"standard.h"
#"boom.h"

trigger_sr { 3 }
lift_delay_1s { 0 }
lift_speed_turbo { 3 }
floor_speed_turbo { 3 }

main {

  pushpop (movestep(64,64) thing)
  mid("SW1BRIK")

  -- generalised lifts
  linetype(genlift(
	trigger_sr,
	0, -- target
	lift_delay_1s,
	0, -- no monster
	lift_speed_turbo),
	$genlift)
  straight(64)

  -- generalised floor
  linetype(genfloor(
	trigger_sr,
	floor_speed_turbo,
	0, -- model XXX ?
	0, -- down/up
	1, -- target
	2, -- change txtonly
	0, -- crush no
	), $genfloor)
  straight(64)

  -- generalised ceiling
  linetype(genceiling(
	trigger_sr,
	0, -- speed (slow)
	0, -- model ?
	1, -- direction up
	0, -- target
	2, -- change txtonly
	0, -- crush no
	), $genceiling)
  straight(64)

  -- generalised door
  linetype(gendoor(
	trigger_sr,
	0, -- speed
	0, -- kind
	0, -- monster
	0, -- delay
	), $gendoor)
  straight(64)

  linetype(0,0) mid("BRICK7")
  straight(128)
  right(64) top("BIGDOOR1") straight(128) top("BRICK7") straight(64)
  right(512) right(256) right(128) rightsector(0, 160, 160)

  sectortype(0,$genlift)
  movestep(-64, 128)
  ibox(128, 160, 160, 64, 64)
  popsector

  sectortype(0, $genfloor)
  move(128)
  ibox(128, 160, 160, 64, 64)
  popsector

  sectortype(0, $genceiling)
  ceil("LAVA1")
  move(128)
  ibox(0, 64, 160, 64, 64)

  sectortype(0, $gendoor)
  ceil("FLAT23")
  movestep(192,-64)
  box(0, 0, 160, 16, 128)
  ceil("RROCK10")

  sectortype(0,0)
  movestep(16, -64)
  box(0, 160, 160, 256,256)
}
