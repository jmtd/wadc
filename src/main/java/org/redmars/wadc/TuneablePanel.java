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
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JSlider;
import javax.swing.JTextField;
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
    private Hashtable<JSlider,String> tuneables = new Hashtable<>();
    private static KnobJockey knobs;

    public TuneablePanel(KnobJockey knobs)
    {
        this.setLayout(new GridBagLayout());
        this.knobs = knobs;
        knobs.addListener(this);
        addSeedControls();
    }

    private JTextField rngSeed;

    public void setSeed(int s)
    {
        rngSeed.setText(""+s);
    }

    void addSeedControls()
    {
            rngSeed = new JTextField();
            rngSeed.setText(""+Choice.seed);
            final int _row = row;
            this.add(new JButton("Seed ♺"), new LabelConstraints() {{ gridy = _row; }});
            this.add(rngSeed, new InputConstraints() {{ gridy = _row; }});
            ++row;
    }

//////////////////////////////////////////////////////////////////////////////
// KnobEventListener interface methods

    public void knobAdded(String label, int min, int val, int max)
    {
        if(!tuneables.containsValue(label))
        {
            JLabel jl = new JLabel(label);
            JSlider js = new JSlider(min, max, val);
            js.setLabelTable(js.createStandardLabels(max/2));
            js.setPaintLabels(true);
            js.addChangeListener(this);

            tuneables.put(js, label);

            final int _row = row;
            this.add(jl, new LabelConstraints() {{ gridy = _row; }});
            this.add(js, new InputConstraints() {{ gridy = _row; }});
            ++row;

            this.updateUI();
        }
    }

    public void clear()
    {
        this.removeAll();
        this.updateUI();
        tuneables.clear();
        addSeedControls();
    }

//////////////////////////////////////////////////////////////////////////////
// JSlider ChangeListener interface

    public void stateChanged(ChangeEvent e)
    {
        JSlider js = (JSlider)e.getSource();
        String s   = tuneables.get(js);
        Knob k     = knobs.get(s);
        int val    = js.getValue();

        if(k.val() != val)
        {
            knobs.set(s,val);
            System.err.println(s + " changed value from " + k.val() + " + to " + val);
        }
    }
}
