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

import java.util.ArrayList;
import java.util.Hashtable;

public class KnobJockey
{
    private Hashtable<String,Knob> tuneables;
    private ArrayList<KnobEventListener> listeners;

    public KnobJockey()
    {
        tuneables = new Hashtable<>();
        listeners = new ArrayList<>();
    }

    public void addListener(KnobEventListener l)
    {
        listeners.add(l);
    }

    private void notifyAdd(Knob k)
    {
        for(KnobEventListener l : listeners)
        {
            l.knobAdded(k.label(), k.min(), k.val(), k.max());
        }
    }

    // if there exists a Knob with key 's', clamp its value to
    // between min and max; update the registered min and max
    // values to those supplied, and return the clamped value.
    public int getOrSet(String s, int min, int val, int max)
    {
        if(!tuneables.containsKey(s))
        {
            Knob k = new Knob(s, min, val, max);
            tuneables.put(s, k);
            notifyAdd(k);
            return val;
        }
        else
        {
            Knob k = tuneables.get(s);
            // XXX update min/max
            // XXX clamp value
            return k.val();
        }
    }

    public Knob get(String s)
    {
        return tuneables.get(s);
    }

    public void set(String s, int val)
    {
        if(tuneables.containsKey(s))
        {
            Knob o = tuneables.get(s);
            Knob k = new Knob(s, o.min(), val, o.max());
            tuneables.put(s, k);
        }
    }

    // clear out all the Knobs, such as when a new map is started
    // or loaded
    public void clear()
    {
        for(KnobEventListener l : listeners)
        {
            l.clear();
        }
        tuneables.clear();
    }

    // for debugging
    public void dumpAll()
    {
        for(Knob k: tuneables.values())
        {
            System.err.println(k);
        }
    }
}
