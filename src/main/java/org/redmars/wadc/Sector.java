/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;
import java.util.*;

class Sector {
  int idx;
  int ceil, floor;
  String ctex, ftex;
  int light;
  int type, tag;
  int boundlen;

  Sector(String c, String f, int h, int l, int ll, List<Sector> addto, int type, int tag) {
    ctex = c; ftex = f;
    ceil = h; floor = l;
    this.type = type;
    this.tag = tag;
    light = ll;
    boundlen = 0;
    idx = addto.size();
    addto.add(this);
  }
}
