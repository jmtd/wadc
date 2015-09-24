/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2015 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;
import java.util.*;

public class Thing {
  int idx;
  int x,y;
  int angle;
  int type;
  int opt;
  int special = 0;
  int specialargs[] = new int[5];
  Thing() { for(int i = 0; i<5; i++) specialargs[i] = 0; }
}
