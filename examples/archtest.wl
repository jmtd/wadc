/*
 * archtest.wl: simple test of WadC's arch() built-in
 * part of WadC
 *
 * Copyright © 2001-2008 Wouter van Oortmerssen
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

#"standard.h"

main {
  thing
  move(-32)
  unpegged
  arch(64,128,32,128,32,160)
  straight(32)
  arch(128,256,32,256,32,240)
  straight(32)
  arch(64,128,32,128,32,160)
  straight(32)
  left(256)
  left(512)
  straight(128)
  left(256)
  left(32)
  leftsector(0,320,128)
}
