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
    implements ChangeListener, KnobEventListener
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

    private Hashtable<String,JSlider> tuneables;

    public void clear()
    {
        this.removeAll();
        this.updateUI();
        tuneables.clear();
    }

    private static KnobJockey knobs;
    public TuneablePanel(KnobJockey knobs)
    {
        this.setLayout(new GridBagLayout());
        this.knobs = knobs;
        tuneables = new Hashtable<>();
        knobs.addListener(this);
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

            tuneables.put(s, js);

            final int _row = row;
            this.add(label, new LabelConstraints() {{ gridy = _row; }});
            this.add(js, new InputConstraints() {{ gridy = _row; }});
            ++row;

            this.updateUI();
        }
    }

    // KnobEventListener interface
    public void knobAdded(String label, int min, int val, int max)
    {
        addTuneable(label, min, val, max);
    }

    // ChangeListener interface
    public void stateChanged(ChangeEvent e)
    {
        JSlider js = (JSlider)e.getSource();
        for(String s : tuneables.keySet())
        {
            JSlider slider = tuneables.get(s);
            if(slider == js)
            {
                int val = js.getValue();

                Knob k = knobs.get(s);

                if(k.val() != val)
                {
                    // XXX this will send a listener event back here, will we ignore it?
                    knobs.set(s,val);
                    System.err.println(s + " changed value from " + k.val() + " + to " + val);
                }
            }
        }
    }
}
