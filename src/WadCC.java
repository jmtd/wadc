// XXX: should probably use nio
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.FileInputStream;

/*
 * an initial, very hacky CLI for WadC
 */

public class WadCC implements WadCMainFrame {

    public static void main(String [] args) {

        if (args.length < 1) {
            System.err.println("usage: wadcc <infile>");
            System.exit(1);
        }
        WadCC w = new WadCC(args[0]);
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

    String getText(final String name) {
        if(name==null) return "";
        this.prefs.basename = (new File(name)).toString();
        return loadtextfile(this.prefs.basename);
    }

    /* do the magic */
    public WadCC(final String infile) {
        String wadfile;
        read_in_prefs();
        WadParse wp = new WadParse(getText(infile), this);
        wp.run();
        wadfile = prefs.basename.substring(0,prefs.basename.lastIndexOf('.'))+".wad";
        // XXX: we haven't initialised the prefs properly, so this will fail if
        // if it needs doom2.wad.
        new Wad(wp,this,wadfile);
    }

    public void msg(String m) {
        System.out.println(m);
    }
    public String getText() {
        return "--";
    }
    public void insert(String s, int pos) {
        // not implemented
    }
}

