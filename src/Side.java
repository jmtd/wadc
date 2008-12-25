import java.util.*;

public class Side {
  int idx;
  Sector s = null;
  Line l;
  Side(Line x, Vector addto) {
    l = x;
    idx = addto.size();
    addto.addElement(this);
  }
  Side cloneadd(Line l, Vector sides) {
    Side s = new Side(l,sides);
    s.s = this.s;
    return s;
  }
}

