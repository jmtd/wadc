/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;

/*
 * A doom texture patch, as represented in a Texture
 */
class Patch {
    String name;
    int xoff, yoff;

    Patch(String n, int x, int y) {
        name = n;
        xoff = x;
        yoff = y;
    }
}
