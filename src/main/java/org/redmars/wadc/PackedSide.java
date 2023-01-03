/*
 * Copyright © 2022 Piotr Wieczorek <pwiecz@gmail.com>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;
import java.util.*;

class PackedSide {
    int xoff;
    int yoff;
    String t;
    String b;
    String m;
    Sector s;

    PackedSide(int xoff, int yoff, String t, String b, String m, Sector s) {
	this.xoff = xoff;
	this.yoff = yoff;
	this.t = t;
	this.b = b;
	this.m = m;
	this.s = s;
    }

    public int hashCode() {
	return ((xoff * yoff) >> 8) ^ t.hashCode() ^ b.hashCode() ^ m.hashCode() ^ s.hashCode();
    }

    public boolean equals(Object o) {
	if (o == null) {
	    return false;
	}
	if (!(o instanceof PackedSide)) {
	    return false;
	}
	PackedSide op = (PackedSide)o;
	return xoff == op.xoff && yoff == op.yoff && t.equals(op.t) && b.equals(op.b) &&
	    m.equals(op.m) && s.equals(op.s);
    }

}

