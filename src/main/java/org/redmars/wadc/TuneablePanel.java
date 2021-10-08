/*
 * Copyright © 2021 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;

import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.JSlider;
import javax.swing.JLabel;
import javax.swing.JPanel;
import java.util.Hashtable;

public class TuneablePanel
    extends JPanel
    implements ChangeListener
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

    record Knob (String label, int val, JSlider slider) {}

    private Hashtable<String,Knob> tuneables;

    public void clear()
    {
        this.removeAll();
        this.updateUI();
        tuneables.clear();
    }

    public TuneablePanel()
    {
        this.setLayout(new GridBagLayout());
        tuneables = new Hashtable<>();
    }
     
    public void addTuneable(String s, int min, int i, int max)
    {
        if(!tuneables.containsKey(s))
        {

            JLabel label = new JLabel(s);
            JSlider js = new JSlider(min, max, i);
            js.setLabelTable(js.createStandardLabels(max/2));
            js.setPaintLabels(true);
            js.addChangeListener(this);

            tuneables.put(s, new Knob(s, i, js));

            final int _row = row;
            this.add(label, new LabelConstraints() {{ gridy = _row; }});
            this.add(js, new InputConstraints() {{ gridy = _row; }});
            ++row;

            this.updateUI();
        }
    }

    public int getOrSet(String s, int min, int val, int max)
    {

        if(!tuneables.containsKey(s))
        {
            addTuneable(s,min,val,max);
            return val;
        }
        else
        {
            Knob k = tuneables.get(s);
            // XXX update min/max
            // XXX clamp value
            return k.val;
        }
    }

    // ChangeListener interface
    public void stateChanged(ChangeEvent e)
    {
        JSlider js = (JSlider)e.getSource();
        for(Knob k : tuneables.values())
        {
            if(k.slider == js)
            {
                int val = js.getValue();
                if(k.val != val)
                {
                    Knob k2 = new Knob(k.label, val, js);
                    tuneables.put(k2.label, k2);
                    System.err.println(k2.label + " changed value from " + k.val + " + to " + k2.val);
                }
            }
        }
    }
}
