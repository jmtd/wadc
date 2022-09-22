/*
 * Copyright © 2021 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * a JPanel containing an embedded text field and button that
 * listens to and generates Random seed change events
 */

package org.redmars.wadc;

import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;

public class SeedPanel extends JPanel implements RandomListener
{
    private JButton refreshButton;
    private JTextField seedField;

    public SeedPanel()
    {
        refreshButton = new JButton("♺");
        refreshButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
              KnobJockey.getInstance().setSeed(System.currentTimeMillis());
            }
        });

        seedField = new JTextField();
        seedField.setEditable(false);

        setLayout(new BoxLayout(this, BoxLayout.LINE_AXIS));
        add(seedField);
        add(refreshButton);
    }

    public void seedChanged(long seed)
    {
        seedField.setText(""+seed);
    }
}
