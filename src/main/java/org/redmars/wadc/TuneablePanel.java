
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

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.TextField;
import javax.swing.JLabel;
import javax.swing.JPanel;

public class TuneablePanel extends JPanel
{
    class LabelConstraints extends GridBagConstraints {{
            anchor = LINE_START;
            fill = NONE;
            gridx = 0;
            gridwidth = 1;
            gridheight = 1;
            weightx = 0;
            weighty = 0;

    }};
    class InputConstraints extends GridBagConstraints {{
            anchor = LINE_END;
            fill = HORIZONTAL;
            gridx = 1;
            gridwidth = 2;
            gridheight = 1;
            weightx = 1;
            weighty = 0;
    }};
 
    private int row = 1;

    public TuneablePanel()
    {
        this.setLayout(new GridBagLayout());
    }
    
    public void addTuneable(String s, int i)
    {
        JLabel label = new JLabel(s);
        final int inputLength = 5; // reasonable default?
        TextField tf = new TextField(""+i, inputLength);
        final int _row = row;
        this.add(label, new LabelConstraints() {{ gridy = _row; }});
        this.add(tf, new InputConstraints() {{ gridy = _row; }});
        ++row;
    }
}
