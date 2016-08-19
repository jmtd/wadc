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
    Variable variable = (Variable)wr.wp.globs.get(name);
    if(set) {
      if (variable==null) {
        variable = new Variable();
      }
      variable.x = wr.xp;
      variable.y = wr.yp;
      variable.o = wr.orient;
      variable.f = wr.texfloor;
      variable.c = wr.texceil;
      variable.t = wr.textop;
      variable.m = wr.texmid;
      variable.b = wr.texbot;

      wr.wp.globs.put(name,variable);

    } else {
      if(variable==null) wr.varerr(name);
      wr.xp = variable.x;
      wr.yp = variable.y;
      wr.orient = variable.o;
      wr.texfloor = variable.f;
      wr.texceil = variable.c;
      wr.textop = variable.t;
      wr.texmid = variable.m;
      wr.texbot = variable.b;
      wr.makevertex();
    };
    return n;
  }
  String show() { return "[setget]"; };
}

