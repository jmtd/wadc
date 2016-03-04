/*
 * This is part of pipes.wl/usepipes.wl, an "Underhalls" tribute
 * I started in around 2006 and never finished.
 *                                                 -- jmtd
 */

#"standard.h"
#"usepipes.wl"

usepipestest {
  slimeinit(0, 128, 120)
  pushpop( move(-1024) rotright slimeinit_once)
  pushpop(movestep(64,64) thing)
  slimecorridor(128)
  slimesecret(0, doublebarreled thing)
  slimecorridor(128)
}
