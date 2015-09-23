import java.util.*;

public class Line {
  int idx;
  Vertex from, to;
  Side right = null, left = null;
  String t,m,b;
  int xoff, yoff;
  int flags = 1;
  int type = 0;
  int tag = 0;
  void copyattrs(Line l, Vector sidesv) {
    if(l.right!=null) right = l.right.cloneadd(this,sidesv);
    if(l.left!=null) left = l.left.cloneadd(this,sidesv);
    t = l.t;
    m = l.m;
    b = l.m;
    xoff = l.xoff;
    yoff = l.yoff;
    flags = l.flags;
  };
}

