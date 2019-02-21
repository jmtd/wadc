/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;
import java.util.*;

class Id extends Exp {
  String s;
  Vector<Exp> v = null;

  Id(String t) {
    s = t;
  }

  String sval() {
    return s;
  }

  Exp eval(WadRun wr) {
    return wr.call(this);
  }

  Exp replace(Vector n, Vector r) {
    if(v == null) {
      for (int i = 0;i < n.size();i++) {
        if(((String)n.elementAt(i)).compareTo(s)==0) return (Exp)r.elementAt(i);
      }
      return this;
    }
    Id newid = new Id(s);
    newid.v = replaceVector(v,n,r);
    return newid;
  }

  String show() {
    String t = s;
    if(v!=null) {
      t += "(";
      for(int i = 0;i<v.size();i++) {
        t += (((Exp)v.elementAt(i)).show())+(i<v.size()-1?",":"");
      }
      t += ")";
    }
    return t;
  }
}

