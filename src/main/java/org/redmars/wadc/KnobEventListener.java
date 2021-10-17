/*
 * Copyright © 2021 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * KnobEventListener receive and respond to knob fiddling
 */

package org.redmars.wadc;

public interface KnobEventListener extends RandomListener
{
    // add a new Knob
    public void knobAdded(String label, int min, int val, int max);

    // RNG seed changed
    public void seedChanged(long seed);

    // remove all Knobs
    public void clear();
}
