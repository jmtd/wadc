/*
 * Copyright © 2015 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

/*
 * an attempt to group together WadC preferences
 * XXX can we extend or implement some interface to get a get/set
 * string method? HashMap? or Preferences API directly?
 */

package org.redmars.wadc;

import java.util.HashMap;
import java.util.prefs.Preferences;
import java.util.prefs.PreferenceChangeListener;
import java.util.prefs.BackingStoreException;

public class WadCPrefs {

  private Preferences prefs;

  private HashMap<String,String> defs = new HashMap<String,String>();

  public String get(String key) {
      return prefs.get(key, defs.getOrDefault(key, "?"));
  }
  public boolean getBoolean(String key) {
      if(key.equals("renderverts") || key.equals("renderthings") || key.equals("renderturtle")) {
          return prefs.getBoolean(key, true);
      }
      return prefs.getBoolean(key, false);
  }

  public SectorFill getEnum(String key) {
      return SectorFill.values()[prefs.getInt(key, 0)]; // XXX overflow?
  }
  public void putEnum(String key, SectorFill e) {
      prefs.putInt(key, e.ordinal());
  }

  public void put(String key, String value) {
      prefs.put(key, value);
  }
  public void putBoolean(String key, boolean value) {
      prefs.putBoolean(key, value);
  }

  public int getInt(String key, int def) {
      return prefs.getInt(key, def);
  }
  public void putInt(String key, int v) {
      prefs.putInt(key,v);
  }

  public void toggle(String key) {
      putBoolean(key, !getBoolean(key));
  }

  void addPreferenceChangeListener(PreferenceChangeListener pcl) {
      prefs.addPreferenceChangeListener(pcl);
  }

  public WadCPrefs() {
      prefs = Preferences.userNodeForPackage(WadCPrefs.class);

      defs.put("bspcmd",   "c:\\doom2\\bsp");
      defs.put("doomexe",  "c:\\doom\\zdoom.exe");
      defs.put("doomargs", "-warp 1 -file");
      defs.put("iwad",     "c:\\doom2\\doomw.wad");
      defs.put("twad1",    "");
      defs.put("twad2",    "");
      defs.put("twad3",    "");
      defs.put("basename",  "untitled.wl"); // current (or last) file edited (aka lastfile)
  }
}
