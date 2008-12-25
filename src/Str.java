class Str extends Exp {
  String s;
  Str(String t) { s = t; }
  String sval() { return s; }
  String show() { return "\""+s+"\""; };
}

