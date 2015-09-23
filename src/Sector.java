import java.util.*;

public class Sector {
  int idx;
  int ceil, floor;
  String ctex, ftex;
  int light;
  int type, tag;
  Sector(String c, String f, int h, int l, int ll, Vector addto, int type, int tag) {
    ctex = c; ftex = f;
    ceil = h; floor = l;
    this.type = type;
    this.tag = tag;
    light = ll;
    idx = addto.size();
    addto.addElement(this);
  }
}
