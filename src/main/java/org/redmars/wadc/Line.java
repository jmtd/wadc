/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;
import java.util.*;

class Line {
  int idx;
  Vertex from, to;
  Side right = null, left = null;
  String t,m,b;
  int xoff, yoff;
  boolean undefx;
  int flags = 0;
  int type = 0;
  int tag = 0;
  int specialargs[] = new int[4];
  boolean midtex = false;

  Line() {
    for(int i = 0; i<4; i++) specialargs[i] = 0;
  }

  Line(boolean mt) {
    this();
    midtex = mt;
  }

  void copyattrs(Line line, List<Side> sidesv) {
    if (line.right != null) {
      right = line.right.cloneadd(this,sidesv);
    }

    if (line.left != null) {
      left = line.left.cloneadd(this,sidesv);
    }

    t = line.t;
    m = line.m;
    b = line.m;
    xoff = line.xoff;
    yoff = line.yoff;
    flags = line.flags;
    undefx = line.undefx;
    type = line.type;
    tag = line.tag;
    System.arraycopy(line.specialargs, 0, specialargs, 0, 4);
  }

  int width() {
    int xs = Math.abs(from.x-to.x);
    int ys = Math.abs(from.y-to.y);
    return xs>ys ? xs : ys;
  }
}

