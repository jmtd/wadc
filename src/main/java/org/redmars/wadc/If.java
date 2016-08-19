/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;
import java.util.*;

class If extends Exp {
  private Exp bool;
  Exp then;
  Exp els;

  If(Exp b) {
    bool = b;
  }

  Exp eval(WadRun wr) {
    return bool.eval(wr).ival()!=0?then.eval(wr):els.eval(wr);
  }

  Exp replace(Vector n, Vector r) {
    If i = new If(bool.replace(n,r));
    i.then = then.replace(n,r);
    i.els = els.replace(n,r);
    return i;
  }

  String show() {
    return bool.show()+" ? "+then.show()+" : "+els.show();
  }
}

