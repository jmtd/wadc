/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;
import java.util.*;

class Exp {
  int ival() {
    return 0;
  }

  String sval() {
    return "";
  }

  Exp eval(WadRun wr) {
    return this;
  }

  Exp replace(Vector n, Vector r) {
    return this;
  }

  Vector<Exp> replaceVector(Vector<Exp> v, Vector n, Vector r) {
    Vector<Exp> newv = new Vector<>();

    for(int i = 0;i < v.size(); i++) {
      newv.addElement((v.elementAt(i)).replace(n,r));
    }

    return newv;
  }
  String show() {
    return "[exp]";
  }
}

