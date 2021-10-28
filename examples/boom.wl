/*
 * boom.wl: Test of (some) Boom generalised linedef types
 * part of WadC
 *
 * Copyright © 2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * Untested: locked doors, stairs and crushers, and various flag combinations
 */

#"standard.h"
#"boom.h"
#"sectors.h"

main {

  pushpop (movestep(64,64) thing)
  mid("SW1BRIK")

  -- generalised lifts
  linetype(genlift(
	trigger_sr,
	0, -- target
	lift_delay_1s,
	0, -- no monster
	speed_turbo),
	$genlift)
  straight(64)

  -- generalised floor
  linetype(genfloor(
	trigger_sr,
	speed_turbo,
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
  linetype(enable_wind, $wind1) right(512) linetype(0,0)

  linetype(enable_friction, $friction1) right(256) linetype(0,0)
  right(128) rightsector(0, 160, 160)

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
  box(0, 160, 160, 256,512)
  
  /*
   * generalised floors
   */

  movestep(112,64)

  sectortype(gen_sector(
      light_flicker,
      damage_10pers,
      0, 0, 0),
    0)
  ibox(24, 160, 160, 64, 64)
  movestep(0,128) popsector

  -- slippy sector
  sectortype(gen_sector(
      light_oscillate, 0,
      0, 1 /* friction */, 0),
    $friction1)
  ibox(16, 160, 255, 64, 64)
  movestep(-64,128) popsector


  -- windy sector
  sectortype(gen_sector(
      0, 0,
      0, 0, 1 /* wind */),
    $wind1)
  ibox(-16, 160, 160, 128, 128)


}
