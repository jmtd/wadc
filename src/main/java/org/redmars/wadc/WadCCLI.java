/*
 * Copyright © 2015 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

// XXX: should probably use nio

package org.redmars.wadc;
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.FileInputStream;
import java.util.Vector;

/*
 * an initial, very hacky CLI for WadC
 */

public class WadCCLI implements WadCMainFrame {

    public static void usage() {
        System.err.println("usage: WadCCLI <infile>");
        System.exit(1);
    }

    public static void main(String [] args) {

        String infile = "";
        boolean writesrc = true;

        if (args.length < 1) {
            usage();

        // presently undocumented hack
        } else if(args.length == 2) {
            if(!"-nosrc".equals(args[0])) {
                usage();
            }
            writesrc = false;
            infile = args[1];

        } else {
            infile = args[0];
        }

        WadCCLI w = new WadCCLI(infile, writesrc);
    }

    // XXX: copied verbatim from MainFrame. should be a static interface method?
    String getPrefs() {
        String prefDir = System.getProperty("user.home") + File.separator + ".wadc";
        return loadtextfile(prefDir + File.separator + "wadc.cfg");
    }

    void read_in_prefs() {
        // XXX: copied from MainFrame. should be a static interface method?
        String cfg = getPrefs();
        if(!"".equals(cfg)) {
            WadParse prefs = new WadParse(cfg, this);
            if(prefs.err==null) prefs.run();
        }
    }

    // XXX: copied verbatim from MainFrame. should be a static interface method?
    String loadtextfile(String name) {
      try {
        BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(name)));
        String c = "";
        String t;
        while((t = in.readLine())!=null) c+=t+"\n";
        in.close();
        msg("file "+name+" read");
        return c;
      } catch(IOException i) {
        msg("couldn't load file "+name);
      };
      return "";
    }

    // XXX: rename, we have a private getText method below!
    String getText(final String name) {
        if(name==null) return "";
        this.prefs.basename = (new File(name)).toString();
        return loadtextfile(this.prefs.basename);
    }

    /* do the magic */
    public WadCCLI(final String infile, boolean writesrc) {
        String wadfile;
        read_in_prefs();
        WadParse wp = new WadParse(getText(infile), this);
        try {
            wp.run();
            wadfile = prefs.basename.substring(0,prefs.basename.lastIndexOf('.'))+".wad";
            // XXX: we haven't initialised the prefs properly, so this will fail if
            // if it needs doom2.wad.
            Wad wad = new Wad(wp,this,wadfile,writesrc);
            wad.run();

        } catch(Error e) {
            System.err.println("eval: "+e.getMessage());

            Vector stacktrace = wp.wr.stacktrace;
            if(stacktrace.size()>0) {
              System.err.println("stacktrace: ");
              int st = stacktrace.size()-10;
              if(st<0) st = 0;
              for(int i = stacktrace.size()-1; i>=st; i--) {
                System.err.println((String)stacktrace.elementAt(i));
              }
            }

            System.exit(1);
        }
    }

    // XXX: consider appending the output of this to the WADCSRC lump too.
    // why? to capture the initial random seed, for when one wasn't specified.
    public void msg(String m) {
        System.out.println(m);
    }
    // XXX: this means that when using WadCCLI the WadC source is not written intp
    // the PWAD. Having said that, neither is "--" so I'm not sure what's going on
    // here.
    public String getText() {
        return "--";
    }
    public void insert(String s, int pos) {
        // not implemented
    }
}

