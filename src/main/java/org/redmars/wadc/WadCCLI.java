/*
 * Copyright © 2015 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

// XXX: should probably use nio

package org.redmars.wadc;

import java.io.*;
import java.util.List;

/*
 * an initial, very hacky CLI for WadC
 */

public class WadCCLI implements WadCMainFrame {

    String src = "";

    private static void usage() {
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

        new WadCCLI(infile, writesrc);
    }

    // XXX: copied verbatim from MainFrame. should be a static interface method?
    private String loadTextFile(String name) {
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
      }
      return "";
    }

    private void readSource(final String name) {
        if(name==null) return;
        this.src = loadtextfile((new File(name)).toString());
    }

    /* do the magic */
    public WadCCLI(final String infile, boolean writesrc) {
        String wadfile;
        readSource(infile);
        WadParse wp = new WadParse(this.src, this);
        try {
            wp.run();
            wadfile = infile.substring(0,infile.lastIndexOf('.'))+".wad";
            Wad wad = new Wad(wp,this,wadfile,writesrc);
            wad.run();

        } catch(Error e) {
            System.err.println("eval: "+e.getMessage());

            List<String> stacktrace = wp.wr.stacktrace;
            if(stacktrace.size()>0) {
              System.err.println("stacktrace: ");
              int st = stacktrace.size()-10;
              if(st<0) st = 0;
              for(int i = stacktrace.size()-1; i>=st; i--) {
                System.err.println(stacktrace.get(i));
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

    public String getText() {
        return this.src;
    }

    public void insert(String s, int pos) {
        // not implemented
    }
}

