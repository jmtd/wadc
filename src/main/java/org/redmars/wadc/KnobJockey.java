/*
 * Copyright © 2021 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * The KnobJockey interface captures managing Wad Language program
 * values that are marked "knobs" and can be tweaked via the WadC
 * UI (or command-line arguments, or...) independently from the
 * program source.
 */

package org.redmars.wadc;

public interface KnobJockey
{
    // XXX we probably want a Listener interface to notify things
    // when a knob value changes

    // if there exists a Knob with key 's', clamp its value to
    // between min and max; update the registered min and max
    // values to those supplied, and return the clamped value.
    public int getOrSet(String s, int min, int val, int max);
}
