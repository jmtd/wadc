/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;
import java.util.*;

import java.util.stream.Collectors;

import java.awt.Color;
import java.awt.Graphics;
import java.awt.Rectangle;

class WadRun {
  WadParse wp;
  private WadCPrefs prefs;
  // state variables

  int xp = 0;
  int yp = 0;
  int orient = 0;

  private boolean pendown = true;
  private Vertex lastvertex = null;
  private Vertex beforelastvertex = null;
  private Line lastline = null;

  private ArrayDeque<Integer> sectorStack = new ArrayDeque<>();

  private Thing curthing = new Thing();
  private int thingflags = 7; // all skill levels

  private int curlinetype = 0;
  private int curlinetag = 0;
  private int cursectortype = 0;
  private int cursectortag = 0;
  private boolean mergesectors = false;
  boolean prunelines = false;
  private boolean undefx = false;
  private boolean undefy = false;
  private int forcesec = -1;
  boolean hexen = false;
  private boolean midtex = false;
  private int curlinearg[] = new int[5];

  private Map<String, Exp> gvars = new HashMap<>();
  private List<Map<String, Exp>> objects = new ArrayList<>();
  List<String> stacktrace = new ArrayList<>();

  private int lightlevel = 160;
  private int ceil = 128, floor = 0;

  String texceil = "RROCK10";
  String texfloor = "SLIME13";
  String textop = "BRICK7";
  String texbot = "BRICK7";
  String texmid = "BRICK7";
  String mapname = "MAP01";

  private int xoff = 0, yoff = 0;
  private int lineflags = 0;

  // generated data

  List<Vertex> vertices = new ArrayList<>();
  List<Line> lines = new ArrayList<>();
  List<Side> sides = new ArrayList<>();
  List<Sector> sectors = new ArrayList<>();
  List<Thing> things = new ArrayList<>();

  private List<Integer> vcoord = new ArrayList<>();
  private List<List<Vertex>> vlists = new ArrayList<>();

  AutoRule texrules = null;

  // merging and splitting

  private List<Integer> xcoord = new ArrayList<>();
  private List<Integer> ycoord = new ArrayList<>();
  private List<List<Line>> xlists = new ArrayList<>();
  private List<List<Line>> ylists = new ArrayList<>();

  // rendering

  private boolean renderverts = true;
  private boolean renderthings = true;
  private int maxx = 0, maxy = 0, minx = 0, miny = 0;
  int xmid, ymid;
  float scale, basescale = 1.0f;
  boolean zoomed = false;
  private Rectangle r;
  private int gridsnap = 16;
  private List<Vertex> xtraverts = new ArrayList<>();
  private Sector errsec = null;

  private LinkedHashSet<Vertex> collect = new LinkedHashSet<>();

  private long initSeed;

  WadRun(WadParse p) {
      wp = p;
      prefs = WadCMainFrame.prefs;
  }

  void deprecated(String fn) {
      wp.mf.msg("WARNING: " +fn + " is deprecated and will be removed in a future release");
  }

  void addBuiltins() {

    builtin("rotright", 0, new Builtin() { Exp eval() {
      rotate(1);
      return n;
    }});

    builtin("rotleft", 0, new Builtin() { Exp eval() {
      rotate(-1);
      return n;
    }});

    builtin("getorient", 0, new Builtin() { Exp eval() {
      return new Int(orient);
    }});

    builtin("getx", 0, new Builtin() { Exp eval() {
      return new Int(xp);
    }});

    builtin("gety", 0, new Builtin() { Exp eval() {
      return new Int(yp);
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
      }
      undefx = ux;
      rotate((side>0)?1:-1);
      return n;
    }});

    builtin("archclip", 7, new Builtin() { Exp eval(Exp a, Exp b, Exp c, Exp d, Exp e, Exp f, Exp g) {
      int height = a.ival();
      int width = b.ival();
      int depth = c.ival();
      int steps = d.ival();
      int step = width/steps;
      floor = e.ival();
      lightlevel = f.ival();

      int maxLength = g.ival(); // maximum length we will generate, to make shortened arches
      int curLength = 0;

      for(int i = 0; i<steps && curLength < maxLength; i++) {
        step = width/steps;
        if( (maxLength - curLength) < step) {
          step = maxLength - curLength;
        }
        curLength += step;

        int xtra = (int)(Math.sin(Math.acos(2*i/(double)steps-1.0))*width/2);
        step(step,0);
        step(0,depth);
        step(-step,0);
        step(0,-depth);
        step(step,0);
        makesector(true,-1,floor,floor+height+xtra,lightlevel);
        xoff += step;
      }
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
      }
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
      makesector(false,sectorStack.peek(),a.ival(),b.ival(),c.ival());
      return n;
    }});

    builtin("innerrightsector", 3, new Builtin() { Exp eval(Exp a, Exp b, Exp c) {
      makesector(true,sectorStack.peek(),a.ival(),b.ival(),c.ival());
      return n;
    }});

    builtin("simplex", 2, new Builtin() { Exp eval(Exp x, Exp y) {
      return new Int(simplex(x.ival(), y.ival()));
    }});

    builtin("mergesectors", 0, new Builtin() { Exp eval() {
      mergesectors = true;
      return n;
    }});

    builtin("prunelines", 0, new Builtin() { Exp eval() {
      prunelines = true;
      return n;
    }});

    builtin("thing", 0, new Builtin() { Exp eval() {
      makething((-orient+3)*90);
      return n;
    }});

    builtin("thingangle", 1, new Builtin() { Exp eval(Exp a) {
      makething(a.ival());
      return n;
    }});

    builtin("setthing", 1, new Builtin() { Exp eval(Exp a) {
      curthing.type = a.ival();
      return n;
    }});

    // thing flags
    builtin("setthingflags", 1, new Builtin() { Exp eval(Exp a) {
        thingflags = a.ival();
        return n;
    }});
    builtin("getthingflags", 0, new Builtin() { Exp eval() {
        return new Int(thingflags);
    }});

    builtin("linetype", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      curlinetype = a.ival();
      curlinetag = b.ival();
      for(int i = 0; i < curlinearg.length; ++i) {
          curlinearg[i] = 0;
      }
      return n;
    }});

    builtin("linetypehexen", 6, new Builtin() { Exp eval(Exp a, Exp b, Exp c, Exp d, Exp e, Exp f) {
      curlinetype = a.ival();
      curlinetag = b.ival();
      curlinearg[0] = c.ival();
      curlinearg[1] = d.ival();
      curlinearg[2] = e.ival();
      curlinearg[3] = f.ival();
      hexen = true;
      return n;
    }});

    // line flags
    builtin("setlineflags", 1, new Builtin() { Exp eval(Exp a) {
        lineflags = a.ival();
        return n;
    }});
    builtin("getlineflags", 0, new Builtin() { Exp eval() {
        return new Int(lineflags);
    }});

    builtin("setthingargs", 8, new Builtin() { Exp eval(Exp a, Exp b, Exp c, Exp d, Exp e, Exp f, Exp g, Exp h) {
      curthing.tid = a.ival();
      curthing.zpos = b.ival();
      curthing.special = c.ival();
      curthing.specialargs[0] = d.ival();
      curthing.specialargs[1] = e.ival();
      curthing.specialargs[2] = f.ival();
      curthing.specialargs[3] = g.ival();
      curthing.specialargs[4] = h.ival();
      hexen = true;
      return n;
    }});

    builtin("hexenformat", 0, new Builtin() { Exp eval() {
        hexen = true;
        return n;
    }});

    builtin("is_hexenformat", 0, new Builtin() { Exp eval() {
      return new Int(hexen?1:0);
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

    builtin("getfloor", 0, new Builtin() { Exp eval() {
        return new Str(texfloor);
    }});

    builtin("getceil", 0, new Builtin() { Exp eval() {
        return new Str(texceil);
    }});

    builtin("gettop", 0, new Builtin() { Exp eval() {
        return new Str(textop);
    }});

    builtin("getbot", 0, new Builtin() { Exp eval() {
        return new Str(texbot);
    }});

    builtin("getmid", 0, new Builtin() { Exp eval() {
        return new Str(texmid);
    }});

    builtin("xoff", 1, new Builtin() { Exp eval(Exp s) {
      xoff = s.ival();
      undefx = false;
      return n;
    }});

    builtin("yoff", 1, new Builtin() { Exp eval(Exp s) {
      yoff = s.ival();
      return n;
    }});

    builtin("midtex", 0, new Builtin() { Exp eval() {
      midtex = !midtex;
      return n;
    }});

    builtin("unpegged", 0, new Builtin() { Exp eval() {
      if((lineflags&24)==0) {
        lineflags |= 24;
      } else {
        lineflags &= ~24;
      }
      return n;
    }});

    builtin("impassable", 0, new Builtin() { Exp eval() {
      if((lineflags&0x01)==0) { lineflags |= 0x01; } else { lineflags &= ~0x01; }
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

    builtin("and", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      return new Int(a.ival() & b.ival());
    }});

    builtin("not", 1, new Builtin() { Exp eval(Exp a) {
      return new Int(~ a.ival());
    }});

    builtin("or", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      return new Int(a.ival() | b.ival());
    }});

    builtin("texture", 3, new Builtin() { Exp eval(Exp s, Exp w, Exp h) {
        wp.setTexture(s.sval(), w.ival(), h.ival());
        return n;
    }});

    builtin("addpatch", 3, new Builtin() { Exp eval(Exp s, Exp x, Exp y) {
        wp.addPatch(s.sval(), x.ival(), y.ival());
        return n;
    }});

    builtin("eq", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      return new Int(a.ival()==b.ival()?1:0);
    }});

    builtin("streq", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      return new Int(a.sval().equals(b.sval())?1:0);
    }});

    builtin("lessthaneq", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      return new Int(a.ival()<=b.ival()?1:0);
    }});

    builtin("print", 1, new Builtin() { Exp eval(Exp s) {
      wp.mf.msg(s.show());
      return n;
    }});

    builtin("cat", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      return new Str(a.sval() + b.sval());
    }});

    builtin("die", 1, new Builtin() { Exp eval(Exp s) {
      wp.mf.msg(s.show());
      wp.error("died");
      return n;
    }});

    builtin("autotex", 5, new Builtin() { Exp eval(Exp a, Exp b, Exp c, Exp d, Exp e) {
      String t[] = { "L", "U", "N" };

      if (!a.sval().equals("W")) {
        t = new String[1];
        t[0] = a.sval();
      }

      for (String aT : t) {
        AutoRule ar = new AutoRule();
        ar.next = texrules;
        texrules = ar;
        ar.type = aT;
        ar.h = b.ival();
        ar.w = c.ival();
        ar.f = d.ival();
        ar.tex = e.sval();
      }

      return n;
    }});

    builtin("set", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      gvars.put(a.sval(), b);
      return b;
    }});

    builtin("get", 1, new Builtin() { Exp eval(Exp a) {
      Exp e = gvars.get(a.sval());
      if (e == null) {
        wp.error("get: uninitialised variable: " + a.sval());
      }
      return e;
    }});

    builtin("onew", 0, new Builtin() { Exp eval() {
      int n = objects.size();
      objects.add(new HashMap<>());
      return new Int(n);
    }});

    builtin("oset", 3, new Builtin() { Exp eval(Exp a, Exp b, Exp c) {
      int i = a.ival();
      if(i<0 || i>=objects.size()) wp.error("oset: illegal object pointer");
      (objects.get(i)).put(b.sval(), c);
      return c;
    }});

    builtin("oget", 2, new Builtin() { Exp eval(Exp a, Exp b) {
      int i = a.ival();
      if(i<0 || i>=objects.size()) wp.error("oget: illegal object pointer");
      Exp e = (objects.get(i)).get(b.sval());
      if(e==null) wp.error("oget: uninitialised object field: "+b.sval());
      return e;
    }});

    builtin("undefx", 0, new Builtin() { Exp eval() {
      undefx = true;
      return n;
    }});

    builtin("popsector", 0, new Builtin() { Exp eval() {
      if(sectorStack.size() <= 1) {
          wp.error("error: can't pop the last sector");
      } else {
          sectorStack.pop();
      }
      return n;
    }});

    builtin("lastsector", 0, new Builtin() { Exp eval() {
      return new Int(sectorStack.peek());
    }});

    builtin("forcesector", 1, new Builtin() { Exp eval(Exp a) {
      forcesec = a.ival();
      return n;
    }});

    builtin("seed", 1, new Builtin() { Exp eval(Exp a) {
      setSeed(a.ival());
      return n;
    }});

    builtin("rand", 2, new Builtin() { Exp eval(Exp ea, Exp eb) {
      int floor = ea.ival();
      int ceil  = eb.ival();
      if(floor > ceil) { int c = floor; floor = ceil; ceil = c; }
      return new Int(floor + KnobJockey.nextInt(ceil - floor + 1));
      // +1 to make ceiling inclusive (nextInt is exclusive of ceiling)
    }});

    builtin("newtag", 0, new Builtin() { Exp eval() {
      return new Int(wp.curtag++);
    }});

    builtin("mapname", 1, new Builtin() { Exp eval(Exp a) {
      mapname = a.sval();
      return n;
    }});

    // integers only so far
    builtin("knob", 4, new Builtin() { Exp eval(Exp label, Exp min, Exp val, Exp max) {
        int i = KnobJockey.getInstance().getOrSet(label.sval(), min.ival(), val.ival(), max.ival());
        return new Int(i);
    }});
  }

  private void builtin(String s, int nargs, Builtin b) {
    b.nargs = nargs;
    Fun f = new Fun(s);
    f.builtin = b;
    wp.funs.put(s,f);
  }

  private void step(int f, int s) {
    switch(orient) {
      case 0: yp-=f; xp+=s; break;
      case 1: xp+=f; yp+=s; break;
      case 2: yp+=f; xp-=s; break;
      case 3: xp-=f; yp-=s; break;
    }
    makevertex();
    if(pendown) makeline();
  }

  private void rotate(int sign) {
    orient = (orient+sign)&3;
  }

  void makevertex() {
    Vertex v = makevertex(xp,yp);
    beforelastvertex = lastvertex;
    lastvertex = v;
  }

  private Vertex makevertex(int xp, int yp) {
    Vertex v = null;
    List<Vertex> vlist = coordlookup(xp,vcoord,vlists);
    if(vlist!=null) {
      for (Vertex aVlist : vlist) {
        v = aVlist;
        if (v.x == xp && v.y == yp) break;
        v = null;
      }
    }
    if(v==null) {
      v = new Vertex();
      v.x = xp;
      v.y = yp;
      vertices.add(v);
      addcoordlists(v,xp,vcoord,vlists);
    }
    return v;
  }

  private void add(Vertex v) { // ??? keep??? XXX
    if(!collect.contains(v)) collect.add(v);
  }

  private void makeline(Vertex a, Vertex b) {
    beforelastvertex = a;
    lastvertex = b;
    makeline();
  }

  private void makeline() {
    Vector<Line> v = lastvertex.v;
    for(int i = 0; i < v.size(); i++) {
      Line l = v.elementAt(i);
      if((l.from==lastvertex && l.to==beforelastvertex) ||
         (l.to==lastvertex && l.from==beforelastvertex)) {
        lastline = l;
        return;
      }
    }
    collect.clear();
    collect.add(beforelastvertex);

    if(beforelastvertex.x==lastvertex.x) {
      splitLines(beforelastvertex, lastvertex, true, lastvertex.x);
    } else if(beforelastvertex.y==lastvertex.y) {
      splitLines(beforelastvertex, lastvertex, false, lastvertex.y);
    } else {
      makelineReally(beforelastvertex, lastvertex);
    };

    // This fixes the case where a line is split by a second linedef
    // which has the opposite direction to the overdrawn one
    for(Line l : lastvertex.v) {
      Vertex other = lastvertex==l.from ? l.to : l.from;

      if(other == beforelastvertex) {
          lastline = l;
          return;
      }
    }
    // no exact line found above; use collect
    for(int i = 0; i < lastvertex.v.size(); i++) {
      Line l = lastvertex.v.elementAt(i);
      Vertex other = lastvertex==l.from ? l.to : l.from;
      for(Vertex o : collect) {
        if(other==o) {
          lastline = l;
          beforelastvertex = o;
          return;
        }
      }
    }
    wp.error("could not locate last line?");
  }

  private void makelineReally(Vertex from, Vertex to) {
    Line l = makelineMinimal(from,to);
    lastline = l;
    l.t = textop;
    l.m = texmid;
    l.b = texbot;
    l.xoff = xoff;
    l.yoff = yoff;
    l.undefx = undefx;
    l.type = curlinetype;
    l.tag = curlinetag;
    l.flags |= lineflags;
    System.arraycopy(curlinearg, 0, l.specialargs, 0, 4);
  }

  private Line makelineMinimal(Vertex from, Vertex to) {
    if(from==to) {
      wp.error("line endpoints are identical?");
    }
    Line l = new Line(midtex);
    l.from = from;
    l.to = to;
    l.idx = lines.size();
    lines.add(l);
    from.insert(l);
    to.insert(l);
    if(from.x==to.x) addcoordlists(l,from.x,xcoord,xlists);
    if(from.y==to.y) addcoordlists(l,from.y,ycoord,ylists);
    return l;
  }

  private <T> void addcoordlists(T o, int coord, List<Integer> coords, List<List<T>> lists) {
    int i = 0;
    for(;i<coords.size();i++) if(coords.get(i) == coord) break;
    List<T> v;
    if(i<coords.size()) {
      v = lists.get(i);
    } else {
      coords.add(coord);
      lists.add(v = new ArrayList<>());
    }
    v.add(o);
  }

  private <T> List<T> coordlookup(int coord, List<Integer> coords, List<List<T>> lists) {
    for(int i = 0; i<coords.size(); i++) {
      if(coords.get(i) ==coord) {
        return lists.get(i);
      }
    }
    return null;
  }

  private void splitLines(Vertex a, Vertex b, boolean eqx, int coord) {
    List<Line> v = coordlookup(coord, eqx ? xcoord : ycoord,
                                  eqx ? xlists : ylists);
    if(v!=null) for(int i = 0; i<v.size(); i++) {
      int c1 = eqx ? a.y : a.x;
      int c2 = eqx ? b.y : b.x;
      Line l = v.get(i);
      int lc1 = eqx ? l.from.y : l.from.x;
      int lc2 = eqx ? l.to.y : l.to.x;
      Vertex ca = a;
      Vertex cb = b;
      Vertex lca = l.from;
      Vertex lcb = l.to;
      if(c1>c2) { int temp = c2; c2 = c1; c1 = temp; ca = b; cb = a; }
      if(lc1>lc2) { int temp = lc2; lc2 = lc1; lc1 = temp; lca = l.to; lcb = l.from; }
      if(c2<=lc1 || c1>=lc2) continue;       // no overlap
      collect.add(lca);
      collect.add(lcb);
      collect.add(ca);
      collect.add(cb);
      v.remove(i);
      if(c1<lc1) {    // overlap on the left
        splitLines((ca==a ? ca : lca), (ca==a ? lca : ca), eqx, coord);
      }
      if(c2>lc2) {    // overlap on the right
        splitLines((cb==b ? cb : lcb), (cb==b ? lcb : cb), eqx, coord);
      }
      v.add(l);
      if(c1>lc1) {   // overlap starts within
        l = splitAtVertex(l, lca==l.from, eqx ? coord : c1, eqx ? c1 : coord);
      }
      if(c2<lc2) {   // overlap ends within
        splitAtVertex(l, lcb==l.to, eqx ? coord : c2, eqx ? c2 : coord);
      }
      return;
    }

    makelineReally(a,b);
  }

  private Line splitAtVertex(Line l, boolean fromto, int x, int y) {
    Vertex mid = makevertex(x, y);
    l.to.remove(l);
    Line sec = makelineMinimal(mid,l.to);
    sec.copyattrs(l, sides);
    l.to = mid;
    mid.insert(l);
    return fromto ? sec : l;
  }

  private void makething(int angle) {
    Thing t = new Thing();
    t.x = xp;
    t.y = yp;
    t.type = curthing.type;
    t.tid = curthing.tid;
    t.zpos = curthing.zpos;
    t.opt = thingflags;
    t.idx = things.size();
    t.angle = angle;
    t.special = curthing.special;
    System.arraycopy(curthing.specialargs, 0, t.specialargs, 0, 5);
    things.add(t);
  }

  private Sector newsector() {
    if(forcesec>=0 && forcesec<sectors.size()) return sectors.get(forcesec);
    if(mergesectors) {
      for (Sector s : sectors) {
        if (s.ceil == ceil &&
                s.floor == floor &&
                s.light == lightlevel &&
                s.tag == cursectortag &&
                s.type == cursectortype &&
                s.ctex.compareTo(texceil) == 0 &&
                s.ftex.compareTo(texfloor) == 0) return s;
      }
    }
    return new Sector(texceil,texfloor,ceil,floor,lightlevel,sectors,cursectortype,cursectortag);
  }

  private void makesector(boolean rightside, int lastsec, int flr, int cl, int ll) {
    //wp.mf.msg("START SECTOR");
    floor = flr;
    ceil = cl;
    lightlevel = ll;
    Sector sec = newsector();
    forcesec = -1;
    sectorStack.push(sec.idx);
    Vertex v = beforelastvertex;
    Line l = lastline;
    main: for(;;) {
      boolean right = true;
      if(v==l.from) {
        if(!rightside) right = false;
      } else {
        if(rightside) right = false;
      }
      right = !right;
      if((right?l.right:l.left)!=null) {
         errsec = sec; wp.error("sidedef already assigned to a sector");
      }
      Side other = right?l.left:l.right;
      if(other!=null && other.s==sec && !prunelines) {
        errsec = sec; wp.error("both sides assigned to the same sector");
      }
      Side ns = new Side(l,sides);
      if(right) { l.right = ns; } else { l.left = ns; }
      ns.s = sec;
      sec.boundlen += l.width();
      if(lastsec>=0) {
        Sector inside = sectors.get(lastsec);
        if(other!=null) {
          errsec = inside; wp.error("cannot make inner sector: sidedef already assigned");
        }
        Side nis = new Side(l,sides);
        if(right) { l.left = nis; } else { l.right = nis; }
        nis.s = inside;
      }
      if(v==lastvertex) return;
      //for(int i = 0;i<v.v.size();i++) { Line m = (Line)v.v.elementAt(i); wp.mf.msg("line: "+v.angle(m)); };
      for(int i = 0;i<v.v.size();i++) {
        Line m = v.v.elementAt(i);
        if(m==l) {
          //wp.mf.msg("pick: "+i);
          if(rightside) { i--; } else { i++; }
          if(i<0) i = v.v.size()-1;
          if(i>=v.v.size()) i = 0;
          m = v.v.elementAt(i);
          if(m==l) { errsec = sec; wp.error("trying to make sector on unconnected line"); };
          l = m;
          v = l.from==v?l.to:l.from;
          continue main;
        }
      }
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
    }
    int x = (int)((clickx-(r.width/2))*scale)+xmid;
    int y = (int)((clicky-(r.height/2))*scale)+ymid;
    int gs = gridsnap/2;
    x = x+(x<0 ? -gs : gs);
    y = y+(y<0 ? -gs : gs);
    Vertex v = new Vertex();
    v.x = x/gridsnap*gridsnap;
    v.y = y/gridsnap*gridsnap;
    Vertex last = xtraverts.size()>0 ? xtraverts.get(xtraverts.size() - 1) : lastvertex;
    if(last.x==v.x && last.y==v.y) return;
    xtraverts.add(v);
    int dx = v.x-last.x;
    int dy = v.y-last.y;
    switch(orient) {
      case 0: x=-dy; y=dx;  break;
      case 1: x=dx;  y=dy;  break;
      case 2: x=dy;  y=-dx; break;
      case 3: x=-dx; y=-dy; break;
    }
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
    wp.mf.insert(s,wp.editinsertpos);
    wp.editinsertpos += s.length();
  }

  void crosshair(Graphics g, boolean show) {
  }

  private void renderxtraverts(Graphics g) {
    int x = lastvertex.x;
    int y = lastvertex.y;
    int gxmid = r.width/2;
    int gymid = r.height/2;
    g.setColor(Color.yellow);
    for(int i = 0; i<xtraverts.size(); i++) {
      Vertex v = xtraverts.get(i);
      g.drawLine((int)((x-xmid)/scale)+gxmid,
                 (int)((y-ymid)/scale)+gymid,
                 (int)((v.x-xmid)/scale)+gxmid,
                 (int)((v.y-ymid)/scale)+gymid);
      x = v.x;
      y = v.y;
    }
  }
  private static int scale(short x, short min, short max)
  {
      int denominator = max - min;
      if(0 != denominator) {
        return ((255 * (x - min)) / denominator);
      }
      return 127; // default to mid-range
  }

  /*
   * orderByPath(vertices, lines): returns a re-ordered (possibly reduced) list
   * of vertices that follow a path based on lines, which are treated as
   * bi-directional
   * converted from the following Haskell
   *
   *  sortme vs ss = (head vs) : sortme' (head vs) (tail vs) (ss ++ (map swap ss))
   *  sortme' v [] _  = []
   *  sortme' v vs ss | vs == newvs = []
   *                  | otherwise = newv : (sortme' newv newvs ss) where
   *      newv  = snd $ head $ filter (\(x,y) -> x == v) ss
   *      newvs = filter ((/=) newv) vs
   */
  List<Vertex> orderByPath(Set<Vertex> set_v, List<Line> ls)
  {
    List<Vertex> vs = new ArrayList<>();
    vs.addAll(set_v);

    // Lines have direction, but we need bi-directional for this purpose.
    // Build a new list, appending reversed lines to the end.
    ArrayList<Line> ls2 = new ArrayList<>(ls);

    for(Line l : ls) {
        Line nl = new Line();
        nl.from = l.to;
        nl.to = l.from;
        ls2.add(nl);
    }

    Vertex head = vs.remove(0);
    List<Vertex> ret = nextNode(head, vs, ls2);
    ret.add(head);
    return ret;
  }

  // internal recursive function for the above
  List<Vertex> nextNode(Vertex v, List<Vertex> vs, List<Line> ls)
  {
    Optional<Vertex> o = ls.stream()
                        .filter(l -> l.from == v)
                        .map(l -> l.to)
                        .filter(v_ -> vs.contains(v_))
                        .findFirst();

    // this can happen if vs is empty (normal situation at the end of recursion)
    // or the input sector was disjoint (e.g. mergesectors)
    if(!o.isPresent())
    {
        return new ArrayList<Vertex>();
    }
    Vertex newv = o.get();

    vs.remove(newv);
    List<Vertex> ret = nextNode(newv, vs, ls);

    ret.add(newv);
    return ret;
  }

  void experimentalFillSector(Graphics g, int xmid, int ymid, int gxmid, int gymid)
  {
      // collect sector height/etc information
      short min_val = 0, max_val = 0, comp = 0;

      if(SectorFill.CEILINGHEIGHT == prefs.getEnum("fillsectors") || SectorFill.FLOORHEIGHT == prefs.getEnum("fillsectors"))
      {
          for(Sector sector : sectors)
          {
              if(SectorFill.FLOORHEIGHT == prefs.getEnum("fillsectors")) {
                  comp = (short)sector.floor;
              }
              else if(SectorFill.CEILINGHEIGHT == prefs.getEnum("fillsectors")) {
                  comp = (short)sector.ceil;
              }

              if(comp < min_val) {
                  min_val = comp;
              }
              if(comp > max_val) {
                  max_val = comp;
              }
          }
      }

      // we need to get a list of vertices that are related to each sector,
      // which we (sadly) can't get from the Sectors themselves

      for(Sector sector : sectors) {
          // We don't want duplicate vertexes in this set. LinkedHashSet doesn't
          // require the Vertex class to implement interface Comparable, but
          // still offers insertion-order preservation.
          //
          // XXX: we need to subdivide sectors into concave (and properly
          // connected) polygons or the draw will be corrupted.
          Set<Vertex> av = new LinkedHashSet<Vertex>();

          // sidedefs are the bridge between sectors and vertexes
          for(Side side : sides) {
              if(side.s == sector) {
                  av.add(side.l.from);
                  av.add(side.l.to);
              }
          }

          List<Line> ls = sides.stream()
                         .filter(side -> side.s == sector)
                         .map(side -> side.l)
                         .collect(Collectors.toList());

          int [] xPoints = new int[av.size()];
          int [] yPoints = new int[av.size()];
          int    nPoints = av.size();

          int i = 0;
          for(Vertex v : orderByPath(av, ls)) {
              xPoints[i] = (int)((v.x-xmid)/scale) + gxmid;
              yPoints[i] = (int)((v.y-ymid)/scale) + gymid;
              i++;
          }

          int c;
          short v;
          switch(prefs.getEnum("fillsectors"))
          {
              case CEILINGHEIGHT:
                  v = (short)sector.ceil;
                  c = scale(v, min_val, max_val);
                  break;

              case FLOORHEIGHT:
                  v = (short)sector.floor;
                  c = scale(v, min_val, max_val);
                  break;

              case LIGHTLEVEL:
                  v = (short)sector.light;
                  c = scale(v, (short)0, (short)255);
                  break;

              default: // should be unreachable
                  c = 127;
                  break;
          }
          g.setColor(new Color(c,c,c));

          g.fillPolygon(xPoints, yPoints, nPoints);
      }
  }

  private int thingsize(int n) {
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
    for (Vertex vertex : vertices) {
      if (vertex.x > maxx) maxx = vertex.x;
      if (vertex.x < minx) minx = vertex.x;
      if (vertex.y > maxy) maxy = vertex.y;
      if (vertex.y < miny) miny = vertex.y;
    }

    if (!zoomed) {
      xmid = (maxx+minx)/2;
      ymid = (maxy+miny)/2;
      scale = (maxx-minx)/(float)r.width;
      float yscale = (maxy-miny)/(float)r.height;
      if(yscale>scale) scale = yscale;
      scale *= 1.05;
      zoomed = true;
    }
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
    }

    if(prefs.getEnum("fillsectors") != SectorFill.NONE) {
        experimentalFillSector(g,xmid,ymid,gxmid,gymid);
    }

    for (Line line : lines) {
      if (line.right != null) {
        g.setColor(line.left != null ? Color.gray : Color.white);
      } else {
        g.setColor(line.left != null ? Color.white : Color.green);
      }

      if (errsec != null)
        if ((line.right != null && line.right.s == errsec) ||
                (line.left != null && line.left.s == errsec)) g.setColor(Color.red);
      if (line.type != 0) g.setColor(Color.blue);
      if (line == lastline) {
        g.setColor(Color.magenta);
      }

      g.drawLine((int) ((line.from.x - xmid) / scale) + gxmid,
              (int) ((line.from.y - ymid) / scale) + gymid,
              (int) ((line.to.x - xmid) / scale) + gxmid,
              (int) ((line.to.y - ymid) / scale) + gymid);
    }

    if(prefs.getBoolean("renderverts")) for(Vertex v : vertices) {
      int d = 2;
      g.setColor(Color.green);
      if (v == lastvertex) {
        d = 5;
        g.setColor(Color.magenta);
      }

      int x = (int) ((v.x - xmid) / scale) + gxmid;
      int y = (int) ((v.y - ymid) / scale) + gymid;
      g.drawLine(x - d, y - d, x + d, y + d);
      g.drawLine(x + d, y - d, x - d, y + d);
    }

    if(prefs.getBoolean("renderthings")) for(Thing t : things) {
      g.setColor(Color.blue);
      int rad = thingsize(t.type);
      int x1 = (int)((t.x-rad-xmid)/scale)+gxmid;
      int y1 = (int)((t.y-rad-ymid)/scale)+gymid;
      int x2 = (int)((t.x+rad-xmid)/scale)+gxmid;
      int y2 = (int)((t.y+rad-ymid)/scale)+gymid;
      g.drawOval(x1,y1,x2-x1,y2-y1);
    }
    // draw the turtle
    if(prefs.getBoolean("renderturtle"))
    {
        g.setColor(Color.orange);
        int rad = 16;
        int x1 = (int)((xp-rad-xmid)/scale)+gxmid;
        int y1 = (int)((yp-rad-ymid)/scale)+gymid;
        int x2 = (int)((xp+rad-xmid)/scale)+gxmid;
        int y2 = (int)((yp+rad-ymid)/scale)+gymid;
        g.drawOval(x1,y1,x2-x1,y2-y1);

        // orientation line
        x1 = (int)((xp-xmid)/scale)+gxmid;
        y1 = (int)((yp-ymid)/scale)+gymid;
        switch(orient)
        {
            case 0: // north
                y2 = (int)(((yp-32)-ymid)/scale)+gymid;
                x2 = x1;
                break;
            case 1: // east
                x2 = (int)(((xp+32)-xmid)/scale)+gxmid;
                y2 = y1;
                break;
            case 2: // south
                y2 = (int)(((yp+32)-ymid)/scale)+gymid;
                x2 = x1;
                break;
            case 3: // west
                x2 = (int)(((xp-32)-xmid)/scale)+gxmid;
                y2 = y1;
                break;
        }
        g.drawLine(x1, y1, x2, y2);
    }

    renderxtraverts(g);
  }

  void setSeed(int s)
  {
      KnobJockey.setSeed(s);
  }

  public long getInitSeed() {
    return initSeed;
  }

  void run() throws Error {
      initSeed = KnobJockey.getSeed();
      KnobJockey.setSeed(initSeed);
      makevertex();
      call(new Id("main"));
      for(int i = 0; i<vertices.size(); i++) {
        Vertex v = vertices.get(i);
        if(v.v.size()==0) {
          vertices.remove(v);
          i--;
        } else {
          v.idx = i;
        }
      }
      wp.mf.msg(vertices.size()+" vertices, "+lines.size()+" lines, "+sectors.size()+" sectors, "+
        things.size()+" things.");
  }

  void varerr(String s) { wp.error("variable "+s+" never set"); }

  Exp call(Id caller) {
    //System.out.println(caller.show());
    stacktrace.add(caller.show());
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
        case 7: r = b.eval(((Exp)v.elementAt(0)).eval(this),
                           ((Exp)v.elementAt(1)).eval(this),
                           ((Exp)v.elementAt(2)).eval(this),
                           ((Exp)v.elementAt(3)).eval(this),
                           ((Exp)v.elementAt(4)).eval(this),
                           ((Exp)v.elementAt(5)).eval(this),
                           ((Exp)v.elementAt(6)).eval(this)); break;
        case 8: r = b.eval(((Exp)v.elementAt(0)).eval(this),
                           ((Exp)v.elementAt(1)).eval(this),
                           ((Exp)v.elementAt(2)).eval(this),
                           ((Exp)v.elementAt(3)).eval(this),
                           ((Exp)v.elementAt(4)).eval(this),
                           ((Exp)v.elementAt(5)).eval(this),
                           ((Exp)v.elementAt(6)).eval(this),
                           ((Exp)v.elementAt(7)).eval(this)); break;
        default: wp.error("oops");
      };
    } else {
      if(nargs!=f.args.size()) wp.error("wrong number of arguments for macro: "+caller.s);
      if(v!=null) for(int i = 0; i<v.size(); i++) {
        if(((String)f.args.get(i)).charAt(0)=='_') v.set(i, ((Exp)v.elementAt(i)).eval(this));
      }
      Exp e = f.body;
      //if(nargs>0)
      e = e.replace(f.args,v);
      r = e.eval(this);
    }
    stacktrace.remove(stacktrace.size() - 1);
    return r;
  }

  int simplex(int x, int y) {
    double simple = SimplexNoise.noise(x,y); // -1 - 1
    return
      (int)(
      (simple + 1) // 0-2
      * 500_000  // 0-1,000,000
    );
  }
}


