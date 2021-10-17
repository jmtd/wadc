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
import java.util.Random;

public class KnobJockey
{
    private Hashtable<String,Knob> tuneables;
    static private ArrayList<KnobEventListener> listeners;
    static private ArrayList<RandomListener> randListeners;

    public static Random rnd = new Random();

    public static void setSeed(long s)
    {
      rnd.setSeed(s);
      for(RandomListener l : randListeners)
      {
          l.seedChanged(s);
      }
    }

    private static KnobJockey singleton = new KnobJockey();
    public static KnobJockey getInstance()
    {
        return singleton;
    }
    private KnobJockey()
    {
        tuneables = new Hashtable<>();
        listeners = new ArrayList<>();
        randListeners = new ArrayList<>();
    }

    public void addListener(KnobEventListener l)
    {
        listeners.add(l);
    }
    public void addRandomListener(RandomListener l)
    {
        randListeners.add(l);
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
            Knob k = new Knob(s, min, clamp(min,val,max), max);
            tuneables.put(s, k);
            notifyAdd(k);
            return val;
        }
        else
        {
            Knob k = tuneables.get(s);
            int  v = clamp(min, k.val(), max);

            // possibly update the min/max values
            // XXX probably need to notify in that case
            tuneables.replace(s, new Knob(s, min, v, max));

            return v;
        }
    }

    private int clamp(int min, int val, int max)
    {
        if(val < min) val = min;
        if(val > max) val = max;
        return val;
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
