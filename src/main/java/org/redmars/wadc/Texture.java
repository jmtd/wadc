/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;
import java.util.*;

/*
 * A doom texture definition
 */

class Texture {
    String name;
    int width, height;
    ArrayList<Patch> patches;

    public Texture(String n, int w, int h) {
        name = n;
        width = w;
        height = h;
        patches = new ArrayList<>();
    }
}
