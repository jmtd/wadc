/*
 * Copyright © 2021 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * Randomness interface for WadC. Mostly a lightweight wrapper around
 * Java's java.util.Random, but with some WadC specifics.
 */

package org.redmars.wadc;

import java.util.ArrayList;

public class Random
{
    private static java.util.Random rnd = new java.util.Random();
    private static long seed;
    private static ArrayList<RandomListener> randListeners = new ArrayList<>();

// reproducing java.util.Random's interface (but with Listeners) /////////////

    public static void setSeed(long s)
    {
      seed = s;
      rnd.setSeed(seed);
      for(RandomListener l : randListeners)
      {
          l.seedChanged(seed);
      }
    }

    public static int nextInt()
    {
        int r = rnd.nextInt();
        return r;
    }

    public static int nextInt(int bound)
    {
        int r = rnd.nextInt(bound);
        return r;
    }

// stuff not in java.util.Random's interface /////////////////////////////////

    public static long getSeed()
    {
        return seed;
    }

    public static void addRandomListener(RandomListener l)
    {
        randListeners.add(l);
    }

    public static void removeRandomListener(RandomListener l)
    {
        randListeners.remove(l);
    }
}
