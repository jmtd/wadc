import java.util.*;

class If extends Exp {
  Exp bool,then,els;
  If(Exp b) { bool = b; }
  Exp eval(WadRun wr) {
    return bool.eval(wr).ival()!=0?then.eval(wr):els.eval(wr);
  }
  Exp replace(Vector n, Vector r) {
    If i = new If(bool.replace(n,r));
    i.then = then.replace(n,r);
    i.els = els.replace(n,r);
    return i;
  }
  String show() { return bool.show()+" ? "+then.show()+" : "+els.show(); };
}

