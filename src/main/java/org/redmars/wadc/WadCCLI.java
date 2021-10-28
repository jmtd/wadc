/*
 * Copyright © 2015 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

// XXX: should probably use nio

package org.redmars.wadc;

import java.io.*;
import java.util.concurrent.Callable;
import java.util.List;

import picocli.CommandLine;
import picocli.CommandLine.Command;
import picocli.CommandLine.Option;
import picocli.CommandLine.Parameters;

/*
 * an initial, very hacky CLI for WadC
 */

@Command(name="wadccli", description="wadc cli")
public class WadCCLI implements WadCMainFrame, Callable<Integer>
{

    String src = "";

    @Option(names={"--seed"}, description="Set the initial RNG seed")
    // XXX: move initial value to a common parent of WadC, WadCCLI?
    private long initSeed = (int)System.currentTimeMillis();

    @Option(names={"-nosrc"}, description="Disable generating WADCSRC lump")
    private boolean nosrc = false;

    @Option(names={"-o","--outfile"}, description="File path to write the generated PWAD")
    private String wadfile = null;

    @Parameters(index="0", description="The Wad Language source file")
    private String srcFile = "";

    public static void main(String [] args)
    {
        WadCCLI cli = new WadCCLI();
        System.exit(new CommandLine(cli).execute(args));
    }

    // XXX: copied verbatim from MainFrame. should be a static interface method?
    private String loadTextFile(String name)
    {
      try
      {
        BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(name)));
        String c = "";
        String t;
        while((t = in.readLine())!=null) c+=t+"\n";
        in.close();
        msg("file "+name+" read");
        return c;
      }
      catch(IOException i)
      {
        msg("couldn't load file "+name);
      }
      return "";
    }

    private void readSource(final String name)
    {
        if(name==null) return;
        this.src = loadTextFile((new File(name)).toString());
    }

    /* do the magic */
    @Override
    public Integer call() throws Exception
    {
        readSource(srcFile);
        System.err.println("debug seed: " + initSeed);
        KnobJockey.setSeed(initSeed);
        WadParse wp = new WadParse(this.src, this);
        try
        {
            wp.run();
            if(wadfile ==null)
                wadfile = srcFile.substring(0,srcFile.lastIndexOf('.'))+".wad";
            Wad wad = new Wad(wp,this,wadfile,!nosrc);
            wad.run();

        }
        catch(Error e)
        {
            System.err.println("eval: "+e.getMessage());

            List<String> stacktrace = wp.wr.stacktrace;
            if(stacktrace.size()>0)
            {
              System.err.println("stacktrace: ");
              int st = stacktrace.size()-10;
              if(st<0) st = 0;
              for(int i = stacktrace.size()-1; i>=st; i--)
              {
                System.err.println(stacktrace.get(i));
              }
            }
            return 1;
        }
        return 0;
    }

    public void msg(String m)
    {
        System.out.println(m);
    }

    public String getText()
    {
        return this.src;
    }

    public void insert(String s, int pos)
    {
        // not implemented
    }
}

