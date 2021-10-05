/*
 * Copyright © 2021 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import javax.swing.JSlider;
import javax.swing.JLabel;
import javax.swing.JPanel;
import java.util.Hashtable;

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

    private Hashtable<String,Integer> tuneables;

    public TuneablePanel()
    {
        this.setLayout(new GridBagLayout());
        tuneables = new Hashtable<>();
    }
     
    // temporary values, which will eventually be part of the Tuneable interface
    private int min = 0;
    private int max = 100;

    public void addTuneable(String s, int i)
    {
        if(!tuneables.containsKey(s))
        {
            tuneables.put(s,i);

            JLabel label = new JLabel(s);
            JSlider js = new JSlider(min, max, i);
            js.setLabelTable(js.createStandardLabels(max/2));
            js.setPaintLabels(true);
            final int _row = row;
            this.add(label, new LabelConstraints() {{ gridy = _row; }});
            this.add(js, new InputConstraints() {{ gridy = _row; }});
            ++row;

            this.updateUI();
        }
    }
}
