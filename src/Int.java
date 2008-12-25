class Int extends Exp {
  int i;
  Int(int x) { i = x; }
  int ival() { return i; }
  String sval() { return ""+i; }
  String show() { return sval(); };
}

