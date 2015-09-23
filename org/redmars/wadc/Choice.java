/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2015 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;
import java.util.*;

class Choice extends Exp {
  static Random rnd;
  public Choice(Random r) {
    rnd = r;
  }
  Vector v = new Vector();
  void add(Exp e) { v.addElement(e); }
  Exp replace(Vector n, Vector r) {
    return ((Exp)v.elementAt(Math.abs(rnd.nextInt())%v.size())).replace(n,r);
  }
  String show() { return "[choice]"; };
}
