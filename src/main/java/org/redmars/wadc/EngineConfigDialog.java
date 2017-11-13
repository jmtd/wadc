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

import java.awt.BorderLayout;
import java.awt.Dimension;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Insets;
import java.awt.Rectangle;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.KeyEvent;
import java.io.File;

import javax.swing.BorderFactory;
import javax.swing.border.Border;
import javax.swing.JButton;
import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;
import javax.swing.event.ChangeEvent;
import javax.swing.event.ChangeListener;
import javax.swing.event.DocumentListener;
import javax.swing.event.DocumentEvent;

import java.awt.TextField;
import java.awt.event.TextListener;
import java.awt.event.TextEvent;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

import java.util.prefs.Preferences;
import java.util.prefs.BackingStoreException;
import java.util.prefs.PreferenceChangeListener;
import java.util.prefs.PreferenceChangeEvent;

public class EngineConfigDialog extends JDialog implements PreferenceChangeListener {
    private final static String windowTitle = "WadC Preferences";

    private final JPanel configPanel;

    private final TextField doomargsField;
    private final JPathPanel enginePath;
    private final JPathPanel bspPath;
    private final JPathPanel iwadPath;
    private final JPathPanel twad1Path;
    private final JPathPanel twad2Path;
    private final JPathPanel twad3Path;

    public EngineConfigDialog(final JFrame frame, WadCPrefs prefs) {
        super(frame, windowTitle, true);

        prefs.addPreferenceChangeListener(this);

        this.addWindowListener(new WindowAdapter() {
            public void windowClosing(WindowEvent e) {
                savePrefs(prefs);
            }
        });

        configPanel = new JPanel();
        //configPanel.setBorder(LookAndFeelDefaults.PADDINGBORDER);
        configPanel.setLayout(new GridBagLayout());

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

        int row = 1;

        Border leftBorder = BorderFactory
            .createEmptyBorder(0, 0, 0, 0);//LookAndFeelDefaults.FRAMEPADDING);


        {
            JLabel label = new JLabel("Doom engine path");
            enginePath = new JPathPanel(prefs.get("doomexe"));

            label.setBorder(leftBorder);

            final int row_ = row;
            configPanel.add(label, new LabelConstraints() {{ gridy = row_; }});
            configPanel.add(enginePath, new InputConstraints() {{ gridy = row_; }});
            ++row;
        }
        {
            JLabel label = new JLabel("Doom engine arguments");
            label.setBorder(leftBorder);

            doomargsField = new TextField(prefs.get("doomargs"), 40);

            final int row_ = row;
            configPanel.add(label, new LabelConstraints() {{ gridy = row_; }});
            configPanel.add(doomargsField, new InputConstraints() {{ gridy = row_; }});
            ++row;
        }
        {
            JLabel label = new JLabel("BSP command path");
            label.setBorder(leftBorder);

            bspPath = new JPathPanel(prefs.get("bspcmd"));

            final int row_ = row;
            configPanel.add(label, new LabelConstraints() {{ gridy = row_; }});
            configPanel.add(bspPath, new InputConstraints() {{ gridy = row_; }});
            ++row;
        }
        {
            JLabel label = new JLabel("Doom IWAD path");
            label.setBorder(leftBorder);

            iwadPath = new JPathPanel(prefs.get("iwad"));

            final int row_ = row;
            configPanel.add(label, new LabelConstraints() {{ gridy = row_; }});
            configPanel.add(iwadPath, new InputConstraints() {{ gridy = row_; }});
            ++row;
        }
        {
            JLabel label = new JLabel("Resource WAD #1");
            label.setBorder(leftBorder);

            twad1Path = new JPathPanel(prefs.get("twad1"));

            final int row_ = row;
            configPanel.add(label, new LabelConstraints() {{ gridy = row_; }});
            configPanel.add(twad1Path, new InputConstraints() {{ gridy = row_; }});
            ++row;
        }
        {
            JLabel label = new JLabel("Resource WAD #2");
            label.setBorder(leftBorder);

            twad2Path = new JPathPanel(prefs.get("twad2"));

            final int row_ = row;
            configPanel.add(label, new LabelConstraints() {{ gridy = row_; }});
            configPanel.add(twad2Path, new InputConstraints() {{ gridy = row_; }});
            ++row;
        }
        {
            JLabel label = new JLabel("Resource WAD #3");
            label.setBorder(leftBorder);

            twad3Path = new JPathPanel(prefs.get("twad3"));

            final int row_ = row;
            configPanel.add(label, new LabelConstraints() {{ gridy = row_; }});
            configPanel.add(twad3Path, new InputConstraints() {{ gridy = row_; }});
            ++row;
        }

        add(configPanel, BorderLayout.CENTER);

        final JButton okay = new JButton("Okay");
        okay.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent e) {
                setVisible(false);
                savePrefs(prefs);
                dispose();
            }
        });
        add(okay, BorderLayout.PAGE_END);
    }

    public void savePrefs(WadCPrefs prefs) {
        prefs.put("doomargs", doomargsField.getText());
        prefs.put("doomexe", enginePath.getPath().toString());
        prefs.put("bspcmd", bspPath.getPath().toString());
        prefs.put("iwad", iwadPath.getPath().toString());
        prefs.put("twad1", twad1Path.getPath().toString());
        prefs.put("twad2", twad2Path.getPath().toString());
        prefs.put("twad3", twad3Path.getPath().toString());
    }

    public void preferenceChange(PreferenceChangeEvent evt) {
        String key = evt.getKey();
        if(key.equals("doomexe")) {
            enginePath.setPath(evt.getNewValue());
        }
        if(key.equals("doomargs")) {
            doomargsField.setText(evt.getNewValue());
        }
        if(key.equals("bspcmd")) {
            bspPath.setPath(evt.getNewValue());
        }
        if(key.equals("iwad")) {
            iwadPath.setPath(evt.getNewValue());
        }
        if(key.equals("twad1")) {
            twad1Path.setPath(evt.getNewValue());
        }
        if(key.equals("twad2")) {
            twad2Path.setPath(evt.getNewValue());
        }
        if(key.equals("twad3")) {
            twad3Path.setPath(evt.getNewValue());
        }
    }

    public static void main(String [] args) {
        WadCPrefs prefs = new WadCPrefs();
        final JFrame frame = new JFrame();
        final EngineConfigDialog ecd = new EngineConfigDialog(frame, prefs);

        prefs.addPreferenceChangeListener(ecd);

        frame.setEnabled(true);
        frame.pack();
        frame.setVisible(true);
        ecd.pack();
        ecd.setVisible(true);
    }
}
