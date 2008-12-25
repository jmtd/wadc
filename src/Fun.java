import java.util.*;

class Fun {
  String name;
  Vector args = new Vector();
  Exp body;
  Builtin builtin = null;
  Fun(String s) { name = s; }
}

