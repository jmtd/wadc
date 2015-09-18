/*
 * Copyright © 2008 Wouter van Oortmerssen
 * Copyright © 2008-2015 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

/*
 * A doom texture definition
 */
import java.util.*;

class Texture {
    String name;
    int width, height;
    ArrayList<Patch> patches;
    public Texture(String n, int w, int h) {
        name = n;
        width = w;
        height = h;
        patches = new ArrayList<Patch>();
    }
}
