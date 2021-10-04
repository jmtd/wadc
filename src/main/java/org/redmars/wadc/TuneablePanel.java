
/*
 * Copyright © 2017 Jonathan Dowland <jon@dow.land>
 * Copyright © 2009 Hauke Rehfeld
 *
 * Adapted from QuakeInjector:
 *     https://www.quaddicted.com/tools/quake_injector
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;

import java.awt.TextArea;

public class TuneablePanel extends TextArea
{
    public TuneablePanel()
    {
        super(5,20);
    }
    
    public void append(String s)
    {
        super.append(s);
    }
}
