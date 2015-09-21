/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2015 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

import java.util.*;

class Fun {
  String name;
  Vector args = new Vector();
  Exp body;
  Builtin builtin = null;
  Fun(String s) { name = s; }
}

