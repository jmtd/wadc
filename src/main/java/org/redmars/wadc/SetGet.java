/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;

class SetGet extends Exp {
  String name;
  boolean set;
  static Exp n = new Int(0);
  Exp eval(WadRun wr) {
    Variable v = (Variable)wr.wp.globs.get(name);
    if(set) {
      if(v==null) v = new Variable();
      v.x = wr.xp;
      v.y = wr.yp;
      v.o = wr.orient;
      v.f = wr.texfloor;
      v.c = wr.texceil;
      v.t = wr.textop;
      v.m = wr.texmid;
      v.b = wr.texbot;
      wr.wp.globs.put(name,v);
    } else {
      if(v==null) wr.varerr(name);
      wr.xp = v.x;
      wr.yp = v.y;
      wr.orient = v.o;
      wr.texfloor = v.f;
      wr.texceil = v.c;
      wr.textop = v.t;
      wr.texmid = v.m;
      wr.texbot = v.b;
      wr.makevertex();
    };
    return n;
  }
  String show() { return "[setget]"; };
}

