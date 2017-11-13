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

    // The default setting for useSystemAAFontSettings is off; and the result
    // looks awful on (at least my) Linux systems. We want to switch the default
    // to on, but leave it possible for the user to override our choice.
    if(null == System.getenv("_JAVA_OPTIONS") ||
        !System.getenv("_JAVA_OPTIONS").contains("useSystemAAFontSettings"))
    {
        System.setProperty("awt.useSystemAAFontSettings", "on");
    }

    // native theme
    try { UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName()); } catch(Exception e) {}

    WadCMainFrame mainFrame1 = new WadC();
  }
}
