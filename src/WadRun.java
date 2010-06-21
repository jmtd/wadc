import java.util.*;
import java.awt.*;

class WadRun {
  WadParse wp;
  // state variables

  int xp = 0;
  int yp = 0;
  int orient = 0;

  boolean pendown = true;
  Vertex lastvertex = null;
  Vertex beforelastvertex = null;
  Line lastline = null;
  int lastsector = -1;
  int lastlastsector = -1;
  int curthingtype = 1;
  int skill = 7;
  boolean mute = false;
  boolean friendly = false;
  int curlinetype = 0;
  int curlinetag = 0;
  int cursectortype = 0;
  int cursectortag = 0;
  boolean mergesectors = false;
  boolean prunelines = false;
  boolean undefx = false;
  boolean undefy = false;
  int forcesec = -1;
  boolean hexen = false;
  boolean midtex = false;
  int curlinearg[] = new int[5];
  int curthingarg[] = new int[5];

  Hashtable gvars = new Hashtable();
  Vector objects = new Vector();
  Vector stacktrace = new Vector();

  int lightlevel = 160;
  int ceil = 128, floor = 0;

  String texceil = "RROCK10";
  String texfloor = "SLIME13";
  String textop = "BRICK7";
  String texbot = "BRICK7";
  String texmid = "BRICK7";

  int xoff = 0, yoff = 0;
  int lineflags = 0;


  // generated data

  Vector vertices = new Vector();
  Vector lines = new Vector();
  Vector sides = new Vector();
  Vector sectors = new Vector();
  Vector things = new Vector();

  Vector vcoord = new Vector();
  Vector vlists = new Vector();

  AutoRule texrules = null;

  // merging and splitting

  Vector xcoord = new Vector();
  Vector ycoord = new Vector();
  Vector xlists = new Vector();
  Vector ylists = new Vector();

  // rendering

  boolean renderverts = true;
  boolean renderthings = true;
  int maxx = 0, maxy = 0, minx = 0, miny = 0;
  int xmid, ymid;
  float scale, basescale = 1.0f;
  boolean zoomed = false;
  Rectangle r;
  int gridsnap = 16;
  Vector xtraverts = new Vector();
  Sector errsec = null;

  Vector collect;

  static Random rnd = new Random();

  WadRun(WadParse p) { wp = p; }

  void dep() { wp.mf.msg("north east west south are deprecated commands (you shouldn't need them).");}

  void addbuiltins() {

    builtin("north", 0, new Builtin() { Exp eval() {
      orient = 0;
      dep();
      return n;
    }});

    builtin("east", 0, new Builtin() { Exp eval() {
      orient = 1;
      dep();
      return n;
    }});

    builtin("south", 0, new Builtin() { Exp eval() {
      orient = 2;
      dep();
      return n;
    }});

    builtin("west", 0, new Builtin() { Exp eval() {
      orient = 3;
      dep();
      return n;
    }});

    builtin("rotright", 0, new Builtin() { Exp eval() {
      rotate(1);
      return n;
    }});

    builtin("rotleft", 0, new Builtin() { Exp eval() {
      rotate(-1);
      return n;
    }});

    builtin("up", 0, new Builtin() { Exp eval() {
      pendown = false;
      return n;
    }});

    builtin("down", 0, new Builtin() { Exp eval() {
      pendown = true;
      return n;
    }});

    builtin("step", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      step(a.ival(),b.ival());
      return n;
    }});

    builtin("curve", 4, new Builtin() { Exp eval(Exp a, Exp b, Exp c, Exp d) {
      int steps = c.ival();
      if(steps<1) steps = 1;
      if(steps>1000) steps = 1000;
      int fwd = a.ival();
      int side = b.ival();
      int cur = 0;
      int curside = 0;
      int xoffinc = -d.ival();
      boolean ux = undefx;
      undefx = false;
      for(int i = 1; i<=steps; i++) {
        double angle = ((3.14159/2)*i/(double)steps);
        double seg = (Math.sin(angle))*fwd;
        double segs = (1.0-Math.cos(angle))*side;
        if(i==steps) { seg = fwd; segs = side; }   // protect against float inacuracies
        int f = (int)seg-cur;
        int s = (int)segs-curside;
        step(f,s);
        xoff += ((int)Math.sqrt(f*f+s*s))*xoffinc;
        cur = (int)seg;
        curside = (int)segs;
      };
      undefx = ux;
      rotate((side>0)?1:-1);
      return n;
    }});

    builtin("arch", 6, new Builtin() { Exp eval(Exp a, Exp b, Exp c, Exp d, Exp e, Exp f) {
      int height = a.ival();
      int width = b.ival();
      int depth = c.ival();
      int steps = d.ival();
      int step = width/steps;
      floor = e.ival();
      lightlevel = f.ival();
      for(int i = 0; i<steps; i++) {
        int xtra = (int)(Math.sin(Math.acos(2*i/(double)steps-1.0))*width/2);
        step(step,0);
        step(0,depth);
        step(-step,0);
        step(0,-depth);
        step(step,0);
        makesector(true,-1,floor,floor+height+xtra,lightlevel);
        xoff += step;
      };
      return n;
    }});

    builtin("leftsector", 3, new Builtin() { Exp eval(Exp a, Exp b, Exp c) {
      makesector(false,-1,a.ival(),b.ival(),c.ival());
      return n;
    }});

    builtin("rightsector", 3, new Builtin() { Exp eval(Exp a, Exp b, Exp c) {
      makesector(true,-1,a.ival(),b.ival(),c.ival());
      return n;
    }});

    builtin("innerleftsector", 3, new Builtin() { Exp eval(Exp a, Exp b, Exp c) {
      makesector(false,lastsector,a.ival(),b.ival(),c.ival());
      return n;
    }});

    builtin("innerrightsector", 3, new Builtin() { Exp eval(Exp a, Exp b, Exp c) {
      makesector(true,lastsector,a.ival(),b.ival(),c.ival());
      return n;
    }});

    builtin("landscape", 3, new Builtin() { Exp eval(Exp a, Exp b, Exp c) {
      landscape(a.ival(),b.ival(),c.ival());
      return n;
    }});

    builtin("marchingcubes", 3, new Builtin() { Exp eval(Exp a, Exp b, Exp c) {
      marchingcubes(a.ival(),b.ival(),c.ival());
      return n;
    }});

    builtin("mergesectors", 0, new Builtin() { Exp eval() {
      mergesectors = true;
      return n;
    }});

    builtin("prunelines", 0, new Builtin() { Exp eval() {
      prunelines = true;
      return n;
    }});

    builtin("mute", 0, new Builtin() { Exp eval() {
      mute = !mute;
      return n;
    }});

    builtin("easy", 0, new Builtin() { Exp eval() {
      skill = 7;
      return n;
    }});

    builtin("hurtmeplenty", 0, new Builtin() { Exp eval() {
      skill = 6;
      return n;
    }});

    builtin("ultraviolence", 0, new Builtin() { Exp eval() {
      skill = 4;
      return n;
    }});

    builtin("thing", 0, new Builtin() { Exp eval() {
      makething();
      return n;
    }});

    builtin("setthing", 1, new Builtin() { Exp eval(Exp a) {
      curthingtype = a.ival();
      return n;
    }});

    builtin("friendly", 0, new Builtin() { Exp eval() {
	  friendly = !friendly;
      return n;
    }});

    builtin("linetype", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      curlinetype = a.ival();
      curlinetag = b.ival();
      return n;
    }});

    builtin("linetypehexen", 6, new Builtin() { Exp eval(Exp a, Exp b, Exp c, Exp d, Exp e, Exp f) {
      curlinetype = a.ival();
      curlinetag = b.ival();
      curlinearg[1] = c.ival();
      curlinearg[2] = d.ival();
      curlinearg[3] = e.ival();
      curlinearg[4] = f.ival();
      hexen = true;
      return n;
    }});

    builtin("setthinghexen", 6, new Builtin() { Exp eval(Exp a, Exp b, Exp c, Exp d, Exp e, Exp f) {
      curthingtype = a.ival();
      curthingarg[0] = b.ival();
      curthingarg[1] = c.ival();
      curthingarg[2] = d.ival();
      curthingarg[3] = e.ival();
      curthingarg[4] = f.ival();
      hexen = true;
      return n;
    }});

    builtin("sectortype", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      cursectortype = a.ival();
      cursectortag = b.ival();
      return n;
    }});

    builtin("floor", 1, new Builtin() { Exp eval(Exp s) {
      texfloor = s.sval();
      return n;
    }});

    builtin("ceil", 1, new Builtin() { Exp eval(Exp s) {
      texceil = s.sval();
      return n;
    }});

    builtin("top", 1, new Builtin() { Exp eval(Exp s) {
      textop = s.sval();
      return n;
    }});

    builtin("mid", 1, new Builtin() { Exp eval(Exp s) {
      texmid = s.sval();
      return n;
    }});

    builtin("bot", 1, new Builtin() { Exp eval(Exp s) {
      texbot = s.sval();
      return n;
    }});

    builtin("xoff", 1, new Builtin() { Exp eval(Exp s) {
      xoff = s.ival();
      undefx = false;
      return n;
    }});

    builtin("yoff", 1, new Builtin() { Exp eval(Exp s) {
      yoff = s.ival();
      undefy = false;
      return n;
    }});

    builtin("midtex", 0, new Builtin() { Exp eval() {
	  midtex = !midtex;
      return n;
    }});

    builtin("unpegged", 0, new Builtin() { Exp eval() {
      if((lineflags&24)==0) { lineflags |= 24; } else { lineflags &= ~24; };
      return n;
    }});

    builtin("impassable", 0, new Builtin() { Exp eval() {
      if((lineflags&0x01)==0) { lineflags |= 0x01; } else { lineflags &= ~0x01; };
      return n;
    }});

    builtin("sin", 1, new Builtin() { Exp eval(Exp a) {
      double d = (a.ival()*3.14159)/1800.0;
      return new Int((int)(Math.sin(d)*1024.0));
    }});

    builtin("asin", 1, new Builtin() { Exp eval(Exp a) {
      double d = a.ival()/1024.0;
      return new Int((int)((Math.asin(d)*1800.0)/3.14159));
    }});

    builtin("add", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      return new Int(a.ival()+b.ival());
    }});

    builtin("sub", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      return new Int(a.ival()-b.ival());
    }});

    builtin("mul", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      return new Int(a.ival()*b.ival());
    }});

    builtin("div", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      if(b.ival()==0) wp.error("division by zero");
      return new Int(a.ival()/b.ival());
    }});

    builtin("eq", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      return new Int(a.ival()==b.ival()?1:0);
    }});

    builtin("lessthaneq", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      return new Int(a.ival()<=b.ival()?1:0);
    }});

    builtin("print", 1, new Builtin() { Exp eval(Exp s) {
      wp.mf.msg(s.show());
      return n;
    }});

    builtin("lastfile", 1, new Builtin() { Exp eval(Exp s) {
      wp.mf.basename = s.sval();
      return n;
    }});

    builtin("doomcmd", 1, new Builtin() { Exp eval(Exp s) {
      wp.mf.doomcmd = s.sval();
      return n;
    }});

    builtin("bspcmd", 1, new Builtin() { Exp eval(Exp s) {
      wp.mf.bspcmd = s.sval();
      return n;
    }});

    builtin("iwad", 1, new Builtin() { Exp eval(Exp s) {
      wp.mf.iwad = s.sval();
      return n;
    }});

    builtin("twad1", 1, new Builtin() { Exp eval(Exp s) {
      wp.mf.twad1 = s.sval();
      return n;
    }});

    builtin("twad2", 1, new Builtin() { Exp eval(Exp s) {
      wp.mf.twad2 = s.sval();
      return n;
    }});

    builtin("twad3", 1, new Builtin() { Exp eval(Exp s) {
      wp.mf.twad3 = s.sval();
      return n;
    }});

    builtin("togglevertices", 0, new Builtin() { Exp eval() {
      renderverts = !renderverts;
      return n;
    }});

    builtin("togglethings", 0, new Builtin() { Exp eval() {
      renderthings = !renderthings;
      return n;
    }});

    builtin("autotex", 5, new Builtin() { Exp eval(Exp a, Exp b, Exp c, Exp d, Exp e) {
      String t[] = { "L", "U", "N" };
      if(!a.sval().equals("W")) { t = new String[1]; t[0] = a.sval(); };
      for(int i = 0; i<t.length; i++) {
        AutoRule ar = new AutoRule();
        ar.next = texrules;
        texrules = ar;
        ar.type = t[i];
        ar.h = b.ival();
        ar.w = c.ival();
        ar.f = d.ival();
        ar.tex = e.sval();
      };
      return n;
    }});

    builtin("set", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      gvars.put(a.sval(), b);
      return b;
    }});

    builtin("get", 1, new Builtin() { Exp eval(Exp a) {
      Exp e = (Exp)gvars.get(a.sval());
      if(e==null) wp.error("get: uninitialised variable: "+a.sval());
      return e;
    }});

    builtin("onew", 0, new Builtin() { Exp eval() {
      int n = objects.size();
      objects.addElement(new Hashtable());
      return new Int(n);
    }});

    builtin("oset", 3, new Builtin() { Exp eval(Exp a, Exp b, Exp c) {
      int i = a.ival();
      if(i<0 || i>=objects.size()) wp.error("oset: illegal object pointer");
      ((Hashtable)objects.elementAt(i)).put(b.sval(), c);
      return c;
    }});

    builtin("oget", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      int i = a.ival();
      if(i<0 || i>=objects.size()) wp.error("oget: illegal object pointer");
      Exp e = (Exp)((Hashtable)objects.elementAt(i)).get(b.sval());
      if(e==null) wp.error("oget: uninitialised object field: "+b.sval());
      return e;
    }});

    builtin("undefx", 0, new Builtin() { Exp eval() {
      undefx = true;
      return n;
    }});

    builtin("undefy", 0, new Builtin() { Exp eval() {
      undefy = true;
      return n;
    }});

    builtin("popsector", 0, new Builtin() { Exp eval() {
      lastsector = lastlastsector;
      return n;
    }});

    builtin("lastsector", 0, new Builtin() { Exp eval() {
      return new Int(lastsector);
    }});

    builtin("forcesector", 1, new Builtin() { Exp eval(Exp a) {
      forcesec = a.ival();
      return n;
    }});


  }

  void builtin(String s, int nargs, Builtin b) {
    b.nargs = nargs;
    Fun f = new Fun(s);
    f.builtin = b;
    wp.funs.put(s,f);
  }

  void step(int f, int s) {
    switch(orient) {
      case 0: yp-=f; xp+=s; break;
      case 1: xp+=f; yp+=s; break;
      case 2: yp+=f; xp-=s; break;
      case 3: xp-=f; yp-=s; break;
    };
    makevertex();
    if(pendown) makeline();
  };

  void rotate(int sign) {
    orient = (orient+sign)&3;
  }

  void makevertex() {
    Vertex v = makevertex(xp,yp);
    beforelastvertex = lastvertex;
    lastvertex = v;
  }

  Vertex makevertex(int xp, int yp) {
    Vertex v = null;
    Vector vlist = coordlookup(xp,vcoord,vlists);
    if(vlist!=null) {
      for(int i = 0;i<vlist.size();i++) {
        v = (Vertex)vlist.elementAt(i);
        if(v.x==xp && v.y==yp) break;
        v = null;
      };
    };
    if(v==null) {
      v = new Vertex();
      v.x = xp;
      v.y = yp;
      vertices.addElement(v);
      addcoordlists(v,xp,vcoord,vlists);
    };
    return v;
  }

  void add(Vertex v) {
    if(!collect.contains(v)) collect.addElement(v);
  };

  void makeline(Vertex a, Vertex b) {
    beforelastvertex = a;
    lastvertex = b;
    makeline();
  };

  void makeline() {
    Vector v = lastvertex.v;
    for(int i = 0;i<v.size();i++) {
      Line l = (Line)v.elementAt(i);
      if((l.from==lastvertex && l.to==beforelastvertex) ||
         (l.to==lastvertex && l.from==beforelastvertex)) {
        lastline = l;
        return;
      };
    };
    collect = new Vector();
    collect.addElement(beforelastvertex);
    if(beforelastvertex.x==lastvertex.x) {
      splitlines(beforelastvertex, lastvertex, true, lastvertex.x);
    } else if(beforelastvertex.y==lastvertex.y) {
      splitlines(beforelastvertex, lastvertex, false, lastvertex.y);
    } else {
      makeline_really(beforelastvertex, lastvertex);
    };
    for(int i = 0; i<lastvertex.v.size(); i++) {
      Line l = (Line)lastvertex.v.elementAt(i);
      Vertex other = lastvertex==l.from ? l.to : l.from;
      for(int j = 0; j<collect.size(); j++) {
        Vertex o = (Vertex)collect.elementAt(j);
        if(other==o) {
          lastline = l;
          beforelastvertex = o;
          return;
        };
      };
    };
    wp.error("could not locate last line?");
  }

  void makeline_really(Vertex from, Vertex to) {
    Line l = makeline_minimal(from,to);
    lastline = l;
    l.t = textop;
    l.m = texmid;
    l.b = texbot;
    l.xoff = xoff;
    l.yoff = yoff;
    l.undefx = undefx;
    l.undefy = undefy;
    l.type = curlinetype;
    l.tag = curlinetag;
    l.flags |= lineflags;
    for(int i = 0; i<5; i++) l.specialargs[i] = curlinearg[i];
  };

  Line makeline_minimal(Vertex from, Vertex to) {
    if(from==to) {
      wp.error("line endpoints are identical?");
    };
    Line l = new Line(midtex);
    l.from = from;
    l.to = to;
    l.idx = lines.size();
    lines.addElement(l);
    from.insert(l);
    to.insert(l);
    if(from.x==to.x) addcoordlists(l,from.x,xcoord,xlists);
    if(from.y==to.y) addcoordlists(l,from.y,ycoord,ylists);
    return l;
  };

  void addcoordlists(Object o, int coord, Vector coords, Vector lists) {
    int i = 0;
    for(;i<coords.size();i++) if(((Integer)coords.elementAt(i)).intValue()==coord) break;
    Vector v;
    if(i<coords.size()) {
      v = (Vector)lists.elementAt(i);
    } else {
      coords.addElement(new Integer(coord));
      lists.addElement(v = new Vector());
    };
    v.addElement(o);
  }

  Vector coordlookup(int coord, Vector coords, Vector lists) {
    for(int i = 0; i<coords.size(); i++) {
      if(((Integer)coords.elementAt(i)).intValue()==coord) {
        return (Vector)lists.elementAt(i);
      };
    };
    return null;
  }

  void splitlines(Vertex a, Vertex b, boolean eqx, int coord) {
    Vector v = coordlookup(coord, eqx ? xcoord : ycoord,
                                  eqx ? xlists : ylists);
    if(v!=null) for(int i = 0; i<v.size(); i++) {
      int c1 = eqx ? a.y : a.x;
      int c2 = eqx ? b.y : b.x;
      Line l = (Line)v.elementAt(i);
      int lc1 = eqx ? l.from.y : l.from.x;
      int lc2 = eqx ? l.to.y : l.to.x;
      Vertex ca = a;
      Vertex cb = b;
      Vertex lca = l.from;
      Vertex lcb = l.to;
      if(c1>c2) { int temp = c2; c2 = c1; c1 = temp; ca = b; cb = a; };
      if(lc1>lc2) { int temp = lc2; lc2 = lc1; lc1 = temp; lca = l.to; lcb = l.from; };
      if(c2<=lc1 || c1>=lc2) continue;       // no overlap
      add(lca);
      add(lcb);
      add(ca);
      add(cb);
      v.removeElementAt(i);
      if(c1<lc1) {    // overlap on the left
        splitlines((ca==a ? ca : lca), (ca==a ? lca : ca), eqx, coord);
      };
      if(c2>lc2) {    // overlap on the right
        splitlines((cb==b ? cb : lcb), (cb==b ? lcb : cb), eqx, coord);
      };
      v.addElement(l);
      if(c1>lc1) {   // overlap starts within
        l = splitatvertex(l, lca==l.from, eqx ? coord : c1, eqx ? c1 : coord);
      };
      if(c2<lc2) {   // overlap ends within
        splitatvertex(l, lcb==l.to, eqx ? coord : c2, eqx ? c2 : coord);
      };
      return;
    };
    makeline_really(a,b);
  }

  Line splitatvertex(Line l, boolean fromto, int x, int y) {
    Vertex mid = makevertex(x, y);
    l.to.remove(l);
    Line sec = makeline_minimal(mid,l.to);
    sec.copyattrs(l,sides);
    l.to = mid;
    mid.insert(l);
    return fromto ? sec : l;
  };

  void makething() {
    Thing t = new Thing();
    t.x = xp;
    t.y = yp;
    t.type = curthingtype;
    t.opt = skill+(mute?8:0)+(friendly?0x80:0);
    t.idx = things.size();
    t.angle = (-orient+3)*90;
    for(int i = 0; i<5; i++) t.specialargs[i] = curthingarg[i];
    things.addElement(t);
  }

  Sector newsector() {
    if(forcesec>=0 && forcesec<sectors.size()) return (Sector)sectors.elementAt(forcesec);
    if(mergesectors) {
      for(int i = 0;i<sectors.size();i++) {
        Sector s = (Sector)sectors.elementAt(i);
        if(s.ceil==ceil &&
           s.floor==floor &&
           s.light==lightlevel &&
           s.tag==cursectortag &&
           s.type==cursectortype &&
           s.ctex.compareTo(texceil)==0 &&
           s.ftex.compareTo(texfloor)==0) return s;
      };
    };
    return new Sector(texceil,texfloor,ceil,floor,lightlevel,sectors,cursectortype,cursectortag);
  }

  void makesector(boolean rightside, int lastsec, int flr, int cl, int ll) {
    //wp.mf.msg("START SECTOR");
    floor = flr;
    ceil = cl;
    lightlevel = ll;
    Sector sec = newsector();
    forcesec = -1;
    lastlastsector = lastsector;
    lastsector = sec.idx;
    Vertex v = beforelastvertex;
    Line l = lastline;
    main: for(;;) {
      boolean right = true;
      if(v==l.from) {
        if(!rightside) right = false;
      } else {
        if(rightside) right = false;
      };
      right = !right;
      if((right?l.right:l.left)!=null) {
         errsec = sec; wp.error("sidedef already assigned to a sector");
      };
      Side other = right?l.left:l.right;
      if(other!=null && other.s==sec && !prunelines) {
        errsec = sec; wp.error("both sides assigned to the same sector");
      };
      Side ns = new Side(l,sides);
      if(right) { l.right = ns; } else { l.left = ns; };
      ns.s = sec;
      sec.boundlen += l.width();
      if(lastsec>=0) {
        Sector inside = (Sector)sectors.elementAt(lastsec);
        if(other!=null) {
          errsec = inside; wp.error("cannot make inner sector: sidedef already assigned");
        };
        Side nis = new Side(l,sides);
        if(right) { l.left = nis; } else { l.right = nis; };
        nis.s = inside;
      };
      if(v==lastvertex) return;
      //for(int i = 0;i<v.v.size();i++) { Line m = (Line)v.v.elementAt(i); wp.mf.msg("line: "+v.angle(m)); };
      for(int i = 0;i<v.v.size();i++) {
        Line m = (Line)v.v.elementAt(i);
        if(m==l) {
          //wp.mf.msg("pick: "+i);
          if(rightside) { i--; } else { i++; };
          if(i<0) i = v.v.size()-1;
          if(i>=v.v.size()) i = 0;
          m = (Line)v.v.elementAt(i);
          if(m==l) { errsec = sec; wp.error("trying to make sector on unconnected line"); };
          l = m;
          v = l.from==v?l.to:l.from;
          continue main;
        };
      };
      errsec = sec;
      wp.error("make sector: no line found?");
    }
  }

  void pan(int fromx, int fromy, int tox, int toy) {
     xmid = (int)((fromx-tox)*scale)+xmid;
     ymid = (int)((fromy-toy)*scale)+ymid;
  }

  void zoom(int clickx, int clicky, float factor) {
     xmid = (int)((clickx-(r.width/2))*scale)+xmid;
     ymid = (int)((clicky-(r.height/2))*scale)+ymid;
     scale *= factor;
     basescale *= factor;
  }

  void addstep(int clickx, int clicky, int type) {
    if(wp.editchanged==2) {
      wp.mf.msg("Code changed, please re-run before drawing next vertex!");
      return;
    };
    int x = (int)((clickx-(r.width/2))*scale)+xmid;
    int y = (int)((clicky-(r.height/2))*scale)+ymid;
    int gs = gridsnap/2;
    x = x+(x<0 ? -gs : gs);
    y = y+(y<0 ? -gs : gs);
    Vertex v = new Vertex();
    v.x = x/gridsnap*gridsnap;
    v.y = y/gridsnap*gridsnap;
    Vertex last = xtraverts.size()>0 ? (Vertex)xtraverts.lastElement() : lastvertex;
    if(last.x==v.x && last.y==v.y) return;
    xtraverts.addElement(v);
    int dx = v.x-last.x;
    int dy = v.y-last.y;
    switch(orient) {
      case 0: x=-dy; y=dx;  break;
      case 1: x=dx;  y=dy;  break;
      case 2: x=dy;  y=-dx; break;
      case 3: x=-dx; y=-dy; break;
    };
    String s;
    if(type=='C') {
      s = "  curve("+x+","+y+",10,1)\n";
      rotate(y<0 ? -1 : 1);
    } else if(type=='J') {
      s = "  movestep("+x+","+y+")\n";
    } else if(y==0 && x>=0) {
      s = "  straight("+x+")\n";
    } else if(y==0 && x<0) {
      s = "  turnaround\n  straight("+(-x)+")\n";
      rotate(2);
    } else if(x==0 && y>0) {
      s = "  right("+y+")\n";
      rotate(1);
    } else if(x==0 && y<0) {
      s = "  left("+(-y)+")\n";
      rotate(-1);
    } else if(x==y) {
      s = "  eright("+x+")\n";
      rotate(1);
    } else if(x==-y) {
      s = "  eleft("+x+")\n";
      rotate(-1);
    } else {
      s = "  step("+x+","+y+")\n";
    }
    wp.editchanged = 1;
    wp.mf.textArea1.insert(s,wp.editinsertpos);
    wp.editinsertpos += s.length();
  }

  void crosshair(Graphics g, boolean show) {
  }

  void renderxtraverts(Graphics g) {
    int x = lastvertex.x;
    int y = lastvertex.y;
    int gxmid = r.width/2;
    int gymid = r.height/2;
    g.setColor(Color.yellow);
    for(int i = 0; i<xtraverts.size(); i++) {
      Vertex v = (Vertex)xtraverts.elementAt(i);
      g.drawLine((int)((x-xmid)/scale)+gxmid,
                 (int)((y-ymid)/scale)+gymid,
                 (int)((v.x-xmid)/scale)+gxmid,
                 (int)((v.y-ymid)/scale)+gymid);
      x = v.x;
      y = v.y;
    };
  }

  int thingsize(int n) {
    switch(n) {
      case    1: return  16;
      case    2: return  16;
      case    3: return  16;
      case    4: return  16;
      case   11: return  16;
      case 3004: return  20;
      case   84: return  20;
      case    9: return  20;
      case   65: return  20;
      case 3001: return  20;
      case 3002: return  30;
      case   58: return  30;
      case 3006: return  16;
      case 3005: return  31;
      case   69: return  24;
      case 3003: return  24;
      case   68: return  64;
      case   71: return  31;
      case   66: return  20;
      case   67: return  48;
      case   64: return  20;
      case    7: return 128;
      case   16: return  40;
      case   88: return  16;
      case   72: return  16;
      case 2035: return  10;
      case   54: return  32;
      default:   return  20;
    }
  }

  void render(Graphics g) {
    r = g.getClip().getBounds();
    for(int i = 0;i<vertices.size();i++) {
      Vertex v = (Vertex)vertices.elementAt(i);
      if(v.x>maxx) maxx = v.x;
      if(v.x<minx) minx = v.x;
      if(v.y>maxy) maxy = v.y;
      if(v.y<miny) miny = v.y;
    };
    if(!zoomed) {
      xmid = (maxx+minx)/2;
      ymid = (maxy+miny)/2;
      scale = (maxx-minx)/(float)r.width;
      float yscale = (maxy-miny)/(float)r.height;
      if(yscale>scale) scale = yscale;
      scale *= 1.05;
      zoomed = true;
    };
    int gxmid = r.width/2;
    int gymid = r.height/2;
    int grmaxx = (maxx+128)&0xFFFFFC0;
    int grminx = -((-minx+128)&0xFFFFFC0);
    int grmaxy = (maxy+128)&0xFFFFFC0;
    int grminy = -((-miny+128)&0xFFFFFC0);
    g.setColor(new Color(50,50,50));
    for(int x = grminx;x<=grmaxx;x+=64) {
      g.drawLine((int)((x-xmid)/scale)+gxmid,
                 (int)((grminy-ymid)/scale)+gymid,
                 (int)((x-xmid)/scale)+gxmid,
                 (int)((grmaxy-ymid)/scale)+gymid);
      for(int y = grminy;y<=grmaxy;y+=64)
        g.drawLine((int)((grminx-xmid)/scale)+gxmid,
                   (int)((y-ymid)/scale)+gymid,
                   (int)((grmaxx-xmid)/scale)+gxmid,
                   (int)((y-ymid)/scale)+gymid);
    };
    for(int i = 0;i<lines.size();i++) {
      Line l = (Line)lines.elementAt(i);
      if(l.right!=null) {
        g.setColor(l.left!=null?Color.gray:Color.white);
      } else {
        g.setColor(l.left!=null?Color.white:Color.green);
      };
      if(errsec!=null)
        if((l.right!=null && l.right.s==errsec) ||
           (l.left!=null && l.left.s==errsec)) g.setColor(Color.red);
      if(l.type!=0) g.setColor(Color.blue);
      if(l==lastline) { g.setColor(Color.magenta); };
      g.drawLine((int)((l.from.x-xmid)/scale)+gxmid,
                 (int)((l.from.y-ymid)/scale)+gymid,
                 (int)((l.to.x-xmid)/scale)+gxmid,
                 (int)((l.to.y-ymid)/scale)+gymid);
    };
    if(renderverts) for(int i = 0;i<vertices.size();i++) {
      Vertex v = (Vertex)vertices.elementAt(i);
      int d = 2;
      g.setColor(Color.green);
      if(v==lastvertex) { d=5; g.setColor(Color.magenta); };
      int x = (int)((v.x-xmid)/scale)+gxmid;
      int y = (int)((v.y-ymid)/scale)+gymid;
      g.drawLine(x-d,y-d,x+d,y+d);
      g.drawLine(x+d,y-d,x-d,y+d);
    };
    if(renderthings) for(int i = 0;i<things.size();i++) {
      Thing t = (Thing)things.elementAt(i);
      g.setColor(Color.blue);
      int rad = thingsize(t.type);
      int x1 = (int)((t.x-rad-xmid)/scale)+gxmid;
      int y1 = (int)((t.y-rad-ymid)/scale)+gymid;
      int x2 = (int)((t.x+rad-xmid)/scale)+gxmid;
      int y2 = (int)((t.y+rad-ymid)/scale)+gymid;
      g.drawOval(x1,y1,x2-x1,y2-y1);
    };
    renderxtraverts(g);
  }

  void run() {
    try {
      makevertex();
      call(new Id("main"));
      for(int i = 0; i<vertices.size(); i++) {
        Vertex v = (Vertex)vertices.elementAt(i);
        if(v.v.size()==0) {
          vertices.remove(v);
          i--;
        } else {
          v.idx = i;
        };
      };
      wp.mf.msg(vertices.size()+" vertices, "+lines.size()+" lines, "+sectors.size()+" sectors.");
    } catch(Error e) {
      wp.err = "eval: "+e.getMessage();
      wp.mf.msg(wp.err);
      if(stacktrace.size()>0) {
        String s = "stacktrace: ";
        int st = stacktrace.size()-10;
        if(st<0) st = 0;
        for(int i = stacktrace.size()-1; i>=st; i--) {
          s += ((String)stacktrace.elementAt(i))+" ";
        };
        wp.mf.msg(s);
      };
    };
  }

  void varerr(String s) { wp.error("variable "+s+" never set"); }

  Exp call(Id caller) {
    //System.out.println(caller.show());
    stacktrace.addElement(caller.show());
    Fun f = (Fun)wp.funs.get(caller.s);
    Vector v = caller.v;
    int nargs = 0;
    if(v!=null) nargs = v.size();
    //mf.msg("debug: "+caller.s+"/"+nargs+" "+f);
    if(f==null) wp.error("undefined identifier: "+caller.s);
    Builtin b = f.builtin;
    Exp r = null;
    if(b!=null) {
      if(nargs!=b.nargs) wp.error("wrong number of arguments for builtin: "+caller.s);
      switch(nargs) {
        case 0: r = b.eval(); break;
        case 1: r = b.eval(((Exp)v.elementAt(0)).eval(this)); break;
        case 2: r = b.eval(((Exp)v.elementAt(0)).eval(this),
                           ((Exp)v.elementAt(1)).eval(this)); break;
        case 3: r = b.eval(((Exp)v.elementAt(0)).eval(this),
                           ((Exp)v.elementAt(1)).eval(this),
                           ((Exp)v.elementAt(2)).eval(this)); break;
        case 4: r = b.eval(((Exp)v.elementAt(0)).eval(this),
                           ((Exp)v.elementAt(1)).eval(this),
                           ((Exp)v.elementAt(2)).eval(this),
                           ((Exp)v.elementAt(3)).eval(this)); break;
        case 5: r = b.eval(((Exp)v.elementAt(0)).eval(this),
                           ((Exp)v.elementAt(1)).eval(this),
                           ((Exp)v.elementAt(2)).eval(this),
                           ((Exp)v.elementAt(3)).eval(this),
                           ((Exp)v.elementAt(4)).eval(this)); break;
        case 6: r = b.eval(((Exp)v.elementAt(0)).eval(this),
                           ((Exp)v.elementAt(1)).eval(this),
                           ((Exp)v.elementAt(2)).eval(this),
                           ((Exp)v.elementAt(3)).eval(this),
                           ((Exp)v.elementAt(4)).eval(this),
                           ((Exp)v.elementAt(5)).eval(this)); break;
        default: wp.error("oops");
      };
    } else {
      if(nargs!=f.args.size()) wp.error("wrong number of arguments for macro: "+caller.s);
      if(v!=null) for(int i = 0; i<v.size(); i++) {
        if(((String)f.args.get(i)).charAt(0)=='_') v.set(i, ((Exp)v.elementAt(i)).eval(this));
      };
      Exp e = f.body;
      //if(nargs>0)
      e = e.replace(f.args,v);
      r = e.eval(this);
    };
    stacktrace.setSize(stacktrace.size()-1);
    return r;
  }

  int rnd(int n) { return Math.abs(rnd.nextInt())%n; }

  float dist(Vertex a, Vertex b) {
    int dx = Math.abs(a.x-b.x);
    int dy = Math.abs(a.y-b.y);
    return (float)Math.sqrt(dx*dx+dy*dy);
  }

  void landscape(int width, int height, int density) {
    int xstart = xp;
    int ystart = yp;
    for(int i = 0; i<density; i++) makevertex(xstart+rnd(width),ystart+rnd(height));
    for(int i = 0; i<vertices.size(); i++) {
      Vertex v = (Vertex)vertices.elementAt(i);
      if(v.v.size()>=3) continue;
      Vertex closest = null;
      Vertex nextclosest = null;
      Vertex thirdclosest = null;
      float distclose = 999999;
      float distnextclose = 999999;
      float distthirdclose = 999999;
      for(int j = 0; j<vertices.size(); j++) {
        Vertex t = (Vertex)vertices.elementAt(j);
        if(t==v) continue;
        float dist = dist(v,t);
        if(dist<distclose) {
          thirdclosest = nextclosest;
          distthirdclose = distnextclose;
          nextclosest = closest;
          distnextclose = distclose;
          closest = t;
          distclose = dist;
        } else if(dist<distnextclose) {
          thirdclosest = nextclosest;
          distthirdclose = distnextclose;
          nextclosest = t;
          distnextclose = dist;
        } else if(dist<distthirdclose) {
          thirdclosest = t;
          distthirdclose = dist;
        };
      };
      xp = v.x;
      yp = v.y;
      makeline(closest,v);
      if(v.v.size()==3) continue;
      makeline(v,nextclosest);
      if(v.v.size()==3) continue;
      makeline(v,thirdclosest);
    };
  }

  void marchingcubes(int scale, int pscale, int __density) {
    int gridx = scale;
    int gridy = scale;
    int numlevels = 3;
    int gridsize = 64;
    int step = gridsize/2;
    int grid[][] = new int[gridx][gridy];
    int seed = rnd(10000);
    for(int x = 0; x<gridx; x++) for(int y = 0; y<gridy; y++) {
      grid[x][y] = (x==0 || y==0 || x==gridx-1 || y==gridy-1) ? 0 : prnd(numlevels,x,y,seed,pscale)+1;
    };
    for(int x = 0; x<gridx-1; x++) for(int y = 0; y<gridy-1; y++) {
      // A-ab-B
      // |    |
      // ac   bd
      // |    |
      // C-cd-D
      int a = grid[x][y];
      int b = grid[x+1][y];
      int c = grid[x][y+1];
      int d = grid[x+1][y+1];
      int xp = x*gridsize;
      int yp = y*gridsize;
      Vertex ab = makevertex(xp+step,yp);
      Vertex ac = makevertex(xp,yp+step);
      Vertex bd = makevertex(xp+gridsize,yp+step);
      Vertex cd = makevertex(xp+step,yp+gridsize);
      Vertex mi = makevertex(xp+step,yp+step);
      if(a==b && c==d && a!=c) {      // two sides
        makeline(ac,bd);
      } else if(a==c && b==d && a!=b) {
        makeline(ab,cd);

      } else if(a==b && a==c && a==d) {     // empty

      } else if(a==b && a==c && a!=d) {    // 1 corner different
        makeline(cd,bd);
      } else if(a==b && a==d && b!=c) {
        makeline(ac,cd);
      } else if(d==c && d==b && d!=a) {
        makeline(ac,ab);
      } else if(a==c && d==c && c!=b) {
        makeline(ab,bd);

      } else if(a==d && b==c && a!=b) {    // diagonal
        if(rnd(2)==0) {
          makeline(ab,ac);
          makeline(bd,cd);
        } else {
          makeline(ab,bd);
          makeline(ac,cd);
        };

      } else if(a==b && a!=c && a!=d && c!=d) {    // 2 corners different
        makeline(ac,mi);
        makeline(mi,bd);
        makeline(mi,cd);
      } else if(a==c && a!=b && a!=d && b!=d) {
        makeline(ab,mi);
        makeline(mi,cd);
        makeline(mi,bd);
      } else if(b==d && b!=a && b!=c && a!=c) {
        makeline(ab,mi);
        makeline(mi,cd);
        makeline(mi,ac);
      } else if(c==d && c!=a && b!=c && a!=b) {
        makeline(ac,mi);
        makeline(mi,bd);
        makeline(mi,ab);

      } else /*if(a!=b && d!=c && a!=c && d!=b && a!=d && c!=b) */{
        makeline(ab,ac);
        makeline(ac,cd);
        makeline(cd,bd);
        makeline(bd,ab);

      };
    };
    int farx = gridx*gridsize-gridsize-step;
    int fary = gridy*gridsize-gridsize-step;
    for(int i = 2; i<gridx*2-4; i++) tryline(i*step,step,(i+1)*step,step);
    for(int i = 2; i<gridx*2-4; i++) tryline(farx,i*step,farx,(i+1)*step);
    for(int i = gridx*2-4; i>2; i--) tryline(i*step,fary,(i-1)*step,fary);
    for(int i = gridx*2-4; i>2; i--) tryline(step,i*step,step,(i-1)*step);

    for(int i = 0; i<gridx*gridy; i++) {
      Line l = (Line)lines.elementAt(rnd(lines.size()));
      int fbound = (gridx-2)*gridsize;
      int nbound = 1*gridsize;
      if(l.from.x<=nbound || l.from.x>=fbound) continue;
      if(l.from.y<=nbound || l.from.y>=fbound) continue;
      if(l.to.x<=nbound   || l.to.x>=fbound) continue;
      if(l.to.y<=nbound   || l.to.y>=fbound) continue;
      makeline(l.from,l.to);
      if(l.left!=null && l.right==null) {
        rndsector(false);
      } else if(l.left==null && l.right!=null) {
        rndsector(true);
      };
    };
    
  }

  void tryline(int x1, int y1, int x2, int y2) {
    //if(rnd(6)==0) return;
    makeline(makevertex(x1,y1),makevertex(x2,y2));
    if(lastline.left==null && lastline.right==null) {
      rndsector(true);
    };
  }

  void rndsector(boolean right) {
    int floor = rnd(4)*8;
    int ceilrnd = rnd(3);
    texceil = (ceilrnd==2) ? "F_SKY1" : "FLAT5_3";
    int ceil = ceilrnd*32+128;
    int light = ceil-floor; // 96 to 192
    makesector(right,-1,floor,ceil,light);
  }

  int prnd(int max, int x, int y, int seed, float scale) {
    return (int)(Perlin.perlinnoise_2D(x/scale+seed,y/scale+seed,1000,0.01f)*3.5f+100.0f);
  }
}


