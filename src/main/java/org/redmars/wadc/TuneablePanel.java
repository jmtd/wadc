
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
import javax.swing.JPanel;

public class TuneablePanel extends JPanel
{
    private TextArea ta;

    public TuneablePanel()
    {
        ta = new TextArea(5,20);
        this.add(ta);
    }
    
    public void append(String s)
    {
        ta.append(s);
    }
}
