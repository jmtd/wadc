/*
 * Copyright © 2021 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * RandomListener receives notifications of random seed changes
 */

package org.redmars.wadc;

public interface RandomListener
{
    // RNG seed changed
    public void seedChanged(long seed);
}

