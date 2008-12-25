import java.util.*;

class Exp {
  int ival() { return 0; }
  String sval() { return ""; }
  Exp eval(WadRun wr) { return this; }
  Exp replace(Vector n, Vector r) { return this; }
  Vector replacevector(Vector v, Vector n, Vector r) {
    Vector newv = new Vector();
    for(int i = 0;i<v.size();i++) newv.addElement(((Exp)v.elementAt(i)).replace(n,r));
    return newv;
  }
  String show() { return "[exp]"; };
}

