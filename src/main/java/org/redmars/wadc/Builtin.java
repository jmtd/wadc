/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;

class Builtin {
  static Exp n = new Int(0);
  int nargs;
  Exp eval() { return null; }
  Exp eval(Exp a) { return null; }
  Exp eval(Exp a, Exp b) { return null; }
  Exp eval(Exp a, Exp b, Exp c) { return null; }
  Exp eval(Exp a, Exp b, Exp c, Exp d) { return null; }
  Exp eval(Exp a, Exp b, Exp c, Exp d, Exp e) { return null; }
  Exp eval(Exp a, Exp b, Exp c, Exp d, Exp e, Exp f) { return null; }
  Exp eval(Exp a, Exp b, Exp c, Exp d, Exp e, Exp f, Exp g) { return null; }
  Exp eval(Exp a, Exp b, Exp c, Exp d, Exp e, Exp f, Exp g, Exp h) { return null; }
};

