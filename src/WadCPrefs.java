/*
 * an attempt to group together WadC preferences
 */
public class WadCPrefs {
  String basename;
  String bspcmd = "c:\\doom2\\bsp";
  String doomexe = "c:\\doom\\zdoom.exe";
  String doomargs = "-warp 1 -file";
  String iwad = "c:\\doom2\\doom2.wad";
  String twad1 = "";
  String twad2 = "";
  String twad3 = "";

  public WadCPrefs() {
  }

  public String toString() {
      return
      "-- wadc config file\n\n" +
      "main {\n" +
      "  lastfile(\"" + basename + "\")\n" +
      "  doomexe(\"" + doomexe + "\")\n" +
      "  doomargs(\"" + doomargs + "\")\n" +
      "  bspcmd(\"" + bspcmd + "\")\n" +
      "  iwad(\"" + iwad + "\")\n" +
      "  twad1(\"" + twad1 + "\")\n" +
      "  twad2(\"" + twad2 + "\")\n" +
      "  twad3(\"" + twad3 + "\")\n" +
      "}\n";
  }


}
