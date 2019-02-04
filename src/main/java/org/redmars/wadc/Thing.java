/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;

public class Thing {
  int idx;
  int x,y;
  int angle;
  int type = 1;
  int opt; // flags
  int special = 0;
  int specialargs[] = new int[5];

  int tid = 0;
  int zpos = 0;

  Thing() {
    for(int i = 0; i<5; i++) {
      specialargs[i] = 0;
    }
  }
}
