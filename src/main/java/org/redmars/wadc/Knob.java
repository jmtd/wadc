/*
 * Copyright © 2021 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;

public class Knob
{
  public String label;
  public int min;
  public int val;
  public int max;

  public Knob(String l, int mi, int v, int ma)
  {
    label = l;
    min = mi;
    val = v;
    max = ma;
  }
}
