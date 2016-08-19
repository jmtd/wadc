/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;
import java.util.*;

class Fun {
  String name;
  Vector<String> args = new Vector<>();
  Exp body;
  Builtin builtin = null;

  Fun(String s) {
    name = s;
  }
}

