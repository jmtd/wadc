/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;

class Str extends Exp {
  String s;

  Str(String t) {
    s = t;
  }

  String sval() {
    return s;
  }

  String show() {
    return "\""+s+"\"";
  }
}

