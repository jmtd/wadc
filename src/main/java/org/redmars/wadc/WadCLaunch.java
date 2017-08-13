/*
 * Copyright © 2017 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 *
 * Launch the WadC GUI. Necessarily a seperate class than WadC
 * which extends JFrame, so that the properties are set before
 * any AWT/Swing code runs, or they won't work.
 */

package org.redmars.wadc;

import javax.swing.UIManager;

public class WadCLaunch
{
  public static void main(String[] args)
  {
    // Apple specific look and feel tweaks
    System.setProperty("apple.awt.application.name", "Wad Compiler");
    System.setProperty("apple.laf.useScreenMenuBar", "true");

    // native theme
    try { UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); } catch(Exception e) {}

    WadCMainFrame mainFrame1 = new WadC();
  }
}
