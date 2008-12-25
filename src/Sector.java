import java.util.*;

public class Sector {
  int idx;
  int ceil, floor;
  String ctex, ftex;
  int light;
  int type, tag;
  int boundlen;
  Sector(String c, String f, int h, int l, int ll, Vector addto, int type, int tag) {
    ctex = c; ftex = f;
    ceil = h; floor = l;
    this.type = type;
    this.tag = tag;
    light = ll;
    boundlen = 0;
    idx = addto.size();
    addto.addElement(this);
  }
}
