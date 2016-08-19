/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;

import java.util.*;
import java.io.InputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.Path;

class WadParse {
  private int linenum = 1;
  int pos = 0;
  private char token = 0;
  private String buf;
  String err = null;
  private String sinfo = "";
  private int iinfo = 0;
  int curtag = 10;
  int editinsertpos = 0;
  int editchanged = 0;
  Hashtable<String, Fun> funs = new Hashtable<>();
  Hashtable globs = new Hashtable();
  private Hashtable<String, Int> tags = new Hashtable<>();
  WadCMainFrame mf;
  TreeSet<String> includes = new TreeSet<>();

  TreeMap<String,Texture> textures = new TreeMap<>();
  private Texture currentTexture = null;

  WadRun wr = new WadRun(this);

  void error(String s) {
    throw new Error(s);
  }

  WadParse(String s, WadCMainFrame m) {
    mf = m;
    buf = s+((char)0);
    wr.addBuiltins();
    try {
      lex();
      while(token!=0) {
        if(token=='#') {
          attachInclude();
        } else {
          Fun f = parseFun();
          if(funs.put(f.name,f)!=null) error("function "+f.name+" defined twice");
        }
      }
    } catch(Error e) {
      err = "parser ["+linenum+"]: "+e.getMessage();
      mf.msg(err);
    }
  }

  private void lex() {
    for(;;) switch(token = buf.charAt(pos++)) {
      case '\n':
        linenum++;
      case '\t': case ' ': case '\r': continue;
      case 0: pos--; return;
      case '\"': {
        String s = "";
        for(;;) {
          token = buf.charAt(pos++);
          if(token=='\"' || token==0) break;
          s+=token;
        }
        if(token==0) { pos--; return; }
        sinfo = s;
        return;
      }
      case '-':
        if(buf.charAt(pos)=='-') {
          do {
            token = buf.charAt(++pos);
          } while(token!='\n' && token!=0);

          continue;
        }
        parseint("-", 10); // XXX: no negative hex digits yet
        return;
      case '/':
        if(buf.charAt(pos)=='*') {
          pos++;
          while(buf.charAt(pos)!='*' || buf.charAt(pos+1)!='/') {
            pos++;
            if(pos+1==buf.length()) error("multiline comment not closed");
          }
          pos += 2;
          continue;
        }
      case '0': /* possibly hex digit */
        if(buf.charAt(pos)=='x') {
            pos++;
            parseint("", 16);
            return;
        }
        // deliberately fall-through
      default:
        if(Character.isLetter(token) || token=='_') {
          String s = "" + token;
          while(Character.isLetterOrDigit(token = buf.charAt(pos)) || token=='_') {
            pos++;
            s += token;
          }
          sinfo = s;
          token = 'a';
          return;
        }
        if(Character.isDigit(token)) {
          parseint(""+token, 10);
          return;
        }
        return;
    }
  }

  /*
   * resolve an include directive to a file inside the Jar.
   */
  private String loadIncludeFromJar(String name) {
    InputStream input = getClass().getResourceAsStream("/include/"+name);
    if(null != input) {
      java.util.Scanner s = new java.util.Scanner(input, "UTF-8").useDelimiter("\\A");
      if(s.hasNext())
        return s.next();
    }
    mf.msg("couldn't load " + name);
    return "";
  }

  // given a relative file e.g. "foo.h", construct an absolute path
  Path resolveinclude(String name) {
    Path p = Paths.get(mf.prefs.get("basename")).getParent();
    String base = p == null ? "" : p.toString();
    p = Paths.get(base, name);
    return p;
  }

  String loadinclude(String name) {
      ArrayList<String> l = new ArrayList<>();
      Path p = resolveinclude(name);

      if(! Files.isRegularFile(p)) {
          return loadIncludeFromJar(name);
      }
      try {
        Files.lines(p).forEach(l::add);

      } catch(IOException i) {
        mf.msg("couldn't load file "+name);
      }

    return String.join("\n", l);
  }

  private void attachInclude() {
    lex();

    if (token!='\"') error("filename expected");

    if (!includes.contains(sinfo)) {
      includes.add(sinfo);
      buf = buf.substring(0,buf.length()-1) + loadinclude(sinfo) +'\0';
    }

    lex();
  }

  private void parseint(String s, int base) {
    while(Character.digit(token = buf.charAt(pos), base) >= 0) {
        pos++; s+=token;
    }
    iinfo = Integer.parseInt(s, base);
    token = '1';
  }

  private void expect(char c) {
    if(token!=c) error(c+" expected");
    lex();
  }

  private String expectId() {
    if(token!='a') {
      error("identifier expected");
    }
    String s = sinfo;
    lex();
    return s;
  }

  private Fun parseFun() {
    Fun f = new Fun(expectId());
    if(token=='(') {
      lex();
      while(token!=')') {
        f.args.addElement(expectId());
        if(token!=')') expect(',');
      }
      lex();
    }
    expect('{');
    f.body = parseExp();
    if(f.name.compareTo("main")==0 && token=='}') editinsertpos = pos-1;
    expect('}');
    return f;
  }

  private Exp parseExp() {
    Exp e = parseChoice();
    if(token=='?') {
      lex();
      If i = new If(e);
      i.then = parseChoice();
      expect(':');
      i.els = parseChoice();
      return i;
    }
    return e;
  }

  private Exp parseChoice() {
    Exp e = parseSeq();
    if(token=='|') {
      Choice c = new Choice();
      c.add(e);
      while(token=='|') {
        lex();
        c.add(parseSeq());
      }
      return c;
    }
    return e;
  }

  private Exp parseSeq() {
    Exp e = parseFact();
    if(token!='?' && token!=':' && token!='}' && token !=')' && token!=',' && token!='|') {
      return new Seq(e, parseSeq());
    }
    return e;
  }

  private Exp parseFact() {
    switch(token) {
      case '!':
      case '^': {
        boolean set = token=='!';
        lex();
        SetGet sg = new SetGet();
        sg.name = expectId();
        sg.set = set;
        return sg;
      }
      case '$': {
        lex();
        String name = expectId();
        Int i = tags.get(name);
        if(i==null) {
          i = new Int(curtag++);
          tags.put(name,i);
        }
        return i;
      }
      case '{': {
        lex();
        Exp e = parseExp();
        expect('}');
        return e;
      }
      case '1': {
        Int i = new Int(iinfo);
        lex();
        return i;
      }
      case '\"': {
        Str s = new Str(sinfo);
        lex();
        return s;
      }
      case 'a': {
        Id i = new Id(sinfo);
        lex();
        if(token=='(') {
          lex();
          while(token!=')') {
            if(i.v==null) i.v = new Vector<>();
            i.v.addElement(parseExp());
            if(token!=')') expect(',');
          }
          lex();
        }
        return i;
      }

      default: error("expression expected");
    }
    return null;
  }

  void run() throws Error {
      wr.run();
  }

  void setTexture(String s, int w, int h) {
      Texture t = textures.get(s);
      if(null == t) {
          t = new Texture(s,w,h);
          textures.put(s,t);
      }
      currentTexture = t;
  }

  void addPatch(String n, int x, int y) {
      if(null != currentTexture) {
          currentTexture.patches.add(new Patch(n, x, y));
      }
  }
}
