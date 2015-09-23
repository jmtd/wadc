import java.util.*;

class Choice extends Exp {
  static Random rnd = new Random();
  Vector v = new Vector();
  void add(Exp e) { v.addElement(e); }
  Exp replace(Vector n, Vector r) {
    return ((Exp)v.elementAt(Math.abs(rnd.nextInt())%v.size())).replace(n,r);
  }
  String show() { return "[choice]"; };
}
