/*
 * Copyright © 2017 Jonathan Dowland <jon@dow.land>
 * Copyright © 2009 Hauke Rehfeld
 *
 * Adapted from QuakeInjector:
 *     https://www.quaddicted.com/tools/quake_injector
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * XXX: we want to implement some Event-firing interface, so the parent can register for change events and then
 * we aggregate out change events from either the chooser or manually editing the text field
 */

package org.redmars.wadc;

import java.awt.FileDialog;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.io.File;
import java.util.ArrayList;

import javax.swing.BoxLayout;
import javax.swing.JButton;
import javax.swing.JComponent;
import javax.swing.JFileChooser;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.event.ChangeListener;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;

import java.awt.TextField;
import java.awt.event.TextListener;
import java.awt.event.TextEvent;

import java.nio.file.Paths;

/**
 * A Panel to input paths
 */
public class JPathPanel extends JPanel {
    private final static int inputLength = 32;

    private final TextField path;
    private final JButton fileChooserButton;
    private final FileDialog chooser;
    private final JFrame frame;

    private final ArrayList<ActionListener> actionListeners = new ArrayList<>();
    public void addActionListener(ActionListener al) {
        actionListeners.add(al);
    }
    private void triggerListeners(ActionEvent e) {
        for(ActionListener al : actionListeners) {
            al.actionPerformed(e);
        }
    }

    public JPathPanel(String basePath) {
        this(basePath, JFileChooser.FILES_ONLY);
    }
    /**
     * @param filesAndOrDirectories what kind of files can be selected with the filechooser:
     *        one of JFileChooser.DIRECTORIES_ONLY,
     *               JFileChooser.FILES_AND_DIRECTORIES,
     *               JFileChooser.FILES_ONLY
     */

    public JPathPanel(String basePath, int filesAndOrDirectories) {

        this.frame = (JFrame) SwingUtilities.getWindowAncestor(this);

        setLayout(new BoxLayout(this, BoxLayout.LINE_AXIS));

        path = new TextField(basePath, inputLength);
        path.addTextListener(new TextListener() {
            public void textValueChanged(TextEvent e) {
                triggerListeners(new ActionEvent(path, ActionEvent.ACTION_PERFORMED, ""));
            }
        });
        add(path);

        this.chooser = new FileDialog(frame, "...", FileDialog.LOAD);
        chooser.setDirectory(getPath().toString());

        this.fileChooserButton = new JButton("Select");
        fileChooserButton.addActionListener(new ActionListener() {
                public void actionPerformed(ActionEvent e) {
                    chooser.setVisible(true);
                    String dn = chooser.getDirectory();
                    String bn = chooser.getFile();
                    if(null!=dn && null != bn)
                    {
                        setPath(Paths.get(dn,bn).toString());
                    }
                }
            });
        add(fileChooserButton);
    }

    public void setPath(String s) {
        path.setText(s);
    }

    public void setPath(File fp) {
        path.setText(fp.getAbsolutePath());
    }

    /**
     * get a file representing what this pathpanel is pointing to
     */
    public File getPath() {
        String p = path.getText();
        if (p == null) {
            p = "";
        }

        File file = new File(p);
        return file;
    }
}
