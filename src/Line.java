import java.util.*;

public class Line {
  int idx;
  Vertex from, to;
  Side right = null, left = null;
  String t,m,b;
  int xoff, yoff;
  boolean undefx, undefy;
  int flags = 0;
  int type = 0;
  int tag = 0;
  int specialargs[] = new int[5];
  boolean midtex = false;
  Line() { for(int i = 0; i<5; i++) specialargs[i] = 0; }
  Line(boolean mt) { this(); midtex = mt; }
  void copyattrs(Line l, Vector sidesv) {
    if(l.right!=null) right = l.right.cloneadd(this,sidesv);
    if(l.left!=null) left = l.left.cloneadd(this,sidesv);
    t = l.t;
    m = l.m;
    b = l.m;
    xoff = l.xoff;
    yoff = l.yoff;
    flags = l.flags;
    undefx = l.undefx;
    undefy = l.undefy;
    type = l.type;
    tag = l.tag;
    for(int i = 0; i<5; i++) specialargs[i] = l.specialargs[i];
  };
  int width() {
    int xs = Math.abs(from.x-to.x);
    int ys = Math.abs(from.y-to.y);
    return xs>ys ? xs : ys;
  };
}

