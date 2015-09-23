import java.util.*;

class Seq extends Exp {
  Exp x, y;
  Seq(Exp a, Exp b) { x = a; y = b; }
  Exp eval(WadRun wr) {
    x.eval(wr);
    return y.eval(wr);
  }
  Exp replace(Vector n, Vector r) {
    return new Seq(x.replace(n,r),y.replace(n,r));
  }
  String show() { return x.show()+" "+y.show(); };
}

