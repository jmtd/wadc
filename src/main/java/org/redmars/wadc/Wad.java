/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;
import java.util.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

public class Wad {
  WadParse wp;
  WadRun wr;
  WadCMainFrame mf;
  RandomAccessFile f;
  int curlumppos = 12;
  boolean linewarn = true;
  Hashtable<String, Integer> pnames= new Hashtable<String, Integer>();
  boolean write_pnames = false;

  Wad(WadParse w, WadCMainFrame m, String filename) {
    wp = w;
    wr = w.wr;
    mf = m;
    mf.msg("writing wad to "+filename);
    try {

      if(!wp.textures.isEmpty()) {
        readPnames();
        findNewPatches();
      }

      int numentries = wr.hexen ? 8 : 7;
      if(!w.textures.isEmpty()) numentries++;
      if(write_pnames) numentries++;

      f = new RandomAccessFile(filename,"rw");
      f.writeBytes("PWAD");
      writeInt(numentries);
      writeInt(12); // dir offset
      int tsize = writethings();
      int lsize = writelines();
      int dsize = writesides();
      int vsize = writevertices();
      int ssize = writesectors();
      int bsize = writebehaviour();
      int texsize = writetextures();
      int psize = writepnames();
      int wlsize = writewadcsource();

      long dpos = f.getFilePointer();
      writedir("MAP01",0);
      writedir("THINGS",tsize);
      writedir("LINEDEFS",lsize);
      writedir("SIDEDEFS",dsize);
      writedir("VERTEXES",vsize);
      writedir("SECTORS",ssize);
      if(wr.hexen) writedir("BEHAVIOR", bsize);
      if(!w.textures.isEmpty()) writedir("TEXTURE2", texsize);
      if(write_pnames) writedir("PNAMES", psize);
      writedir("WADCSRC", wlsize);

      f.seek(8);
      writeInt((int)dpos);
      f.close();
      mf.msg("wrote wad successfully");

    } catch(IOException i) {
      mf.msg("saving wad unsuccessful");
    };
  }

  void writedir(String name, int size) throws IOException {
    writeInt(curlumppos);
    writeInt(size);
    curlumppos += size;
    string(name);
  };

  void writeByte(int i) throws IOException {
    f.writeByte(i);
  }
  void writeShort(int i) throws IOException {
    f.writeByte(i&0xFF);
    f.writeByte((i&0xFF00)>>8);
  }

  void writeInt(int i) throws IOException {
    writeShort(i&0xFFFF);
    writeShort((i&0xFFFF0000)>>16);
  }

  void string(String s) throws IOException {
    f.writeBytes(s);
    for(int i = 0;i<(8-s.length());i++) f.writeByte(0);
  }

  int writevertices() throws IOException {
    Vector v = wr.vertices;
    for(int i = 0;i<v.size();i++) {
      Vertex a = (Vertex)v.elementAt(i);
      writeShort(-a.x);
      writeShort(a.y);
    };
    return v.size()*4;
  };

  int writelines() throws IOException {
    //swapped roles of left and right to account for mirroring bug (see -a.x in vertices/things)
    Vector v = wr.lines;
    int numlines = 0;
    for(int i = 0;i<v.size();i++) {
      Line a = (Line)v.elementAt(i);
      if(a.left==null) {
        a.left = a.right;
        a.right = null;
        Vertex x = a.from;
        a.from = a.to;
        a.to = x;
        if(a.left==null) {
          if(wr.prunelines) {
          } else {
            if(linewarn) mf.msg("warning: found line not part of any sector, assigned sector 0, & line 0 properties");
            linewarn = false;
            a.left = new Side((Line)wr.lines.elementAt(0),wr.sides);
            a.left.s = (Sector)wr.sectors.elementAt(0);
          };
        };
      };
      if(!(wr.prunelines && ((a.right!=null && a.left.s==a.right.s && a.type==0)
                          || (a.right==null && a.left==null)))) {
        numlines++;
        if(a.undefx) {
          Vertex from = a.from;
          Vertex to = a.to;
          a.xoff = from.x==to.x
               ? (from.y<to.y ? from.y : -from.y)
               : (from.y==to.y
                    ? (from.x<to.x ? from.x : -from.x)
                    : a.xoff);
        };
        writeShort(a.from.idx);
        writeShort(a.to.idx);
        if(a.right!=null) {
          a.flags |= 4;
          if(!a.midtex) a.m = "-";
        };
        writeShort(a.flags); // flags
        if(!wr.hexen) {
          writeShort(a.type); // type
          writeShort(a.tag); // trigger
        } else {
          writeByte(a.type);
          writeByte(a.tag);
          for(int j = 1; j<5; j++) writeByte(a.specialargs[j]);
        };
        writeShort(a.left.idx);
        writeShort(a.right==null?-1:a.right.idx);
      };
    };
    return numlines*(wr.hexen ? 16 : 14);
  };

  int writesides() throws IOException {
    Vector v = wr.sides;
    int numsides = 0;
    for(int i = 0;i<v.size();i++) {
      Side a = (Side)v.elementAt(i);
        numsides++;
        writeShort(a.l.xoff);
        writeShort(a.l.yoff);
        int w = a.l.width();
        Side os = a.l.left==a ? a.l.right : a.l.left;
        if(os==null) os = a;
        string(lookup("U", a.l.t, a.s.ceil-os.s.ceil, w, a.s.floor+1000));
        string(lookup("L", a.l.b, os.s.floor-a.s.floor, w, a.s.floor+1000));
        string(lookup("N", a.l.m, a.s.ceil-a.s.floor, w, a.s.floor+1000));
        writeShort(a.s.idx);
    };
    return numsides*30;
  };

  String lookup(String t, String tex, int h, int w, int f) {
    return (tex.equals("?") ? wr.texrules.retexture(t, h, w, f) : tex).toUpperCase();
  };

  int writesectors() throws IOException {
    Vector v = wr.sectors;
    for(int i = 0;i<v.size();i++) {
      Sector a = (Sector)v.elementAt(i);
      writeShort(a.floor);
      writeShort(a.ceil);
      string(lookup("F", a.ftex, a.ceil-a.floor, a.floor+1000, a.boundlen));
      string(lookup("C", a.ctex, a.ceil-a.floor, a.ceil+1000, a.boundlen));
      writeShort(a.light);
      writeShort(a.type);
      writeShort(a.tag);
    };
    return v.size()*26;
  };

  int writethings() throws IOException {
    Vector v = wr.things;
    for(int i = 0;i<v.size();i++) {
      Thing a = (Thing)v.elementAt(i);
      if(wr.hexen) writeShort(0);   // thingid?
      writeShort(-a.x);
      writeShort(a.y);
      if(wr.hexen) writeShort(0);   // z pos?
      writeShort(a.angle);
      writeShort(a.type);
      writeShort(a.opt);
      if(wr.hexen) {
        writeByte(a.special);
        for(int j = 0; j<5; j++) writeByte(a.specialargs[j]);
      };
    };
    return v.size()*(wr.hexen ? 20 : 10);
  };

  int writebehaviour() throws IOException {
    byte data[] = { 65, 67, 0x53, 0, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };
    if(wr.hexen) f.write(data);
    return 16;
  };

  int writetextures() throws IOException {
    int size, offset = 0;
    if(wp.textures.isEmpty()) return 0;

    writeInt(wp.textures.size());
    size = 4;

    // array of offsets to the textures (4*numtex)
    // offsets are relative to the start of THIS lump
    offset = 4 + wp.textures.size() * 4;
    for( Texture tex : wp.textures.values() ) {
      writeInt(offset);
      size += 4;
      offset += (22 + 10 * tex.patches.size());
    }

    for( Texture tex : wp.textures.values() ) {
      size += 8; string(tex.name);
      size += 4; writeInt(0); // garbage
      size += 2; writeShort(tex.width);
      size += 2; writeShort(tex.height);
      size += 4; writeInt(0); // garbage
      size += 2; writeShort(tex.patches.size());

      for( Patch p : tex.patches ) {
        int pnum = pnames.get(p.name);
        writeShort(p.xoff); // 2 originx
        writeShort(p.yoff); // 2 originy
        writeShort(pnum);   // patch number
        writeInt(0);        // 4 garbage
        size += 10;
      }
    }
    return size;
  }

  void readPnames() throws IOException {
        byte[] pnamestr = "PNAMES\0\0".getBytes();
        int doffs, dsize;
        int poffs = 0, numps;

        RandomAccessFile iwad = new RandomAccessFile(mf.prefs.iwad, "r");
        iwad.seek(4);
        dsize = Integer.reverseBytes(iwad.readInt());
        doffs = Integer.reverseBytes(iwad.readInt());

        // find the PNAMES lump
        iwad.seek(doffs);
        for(int i = 0; i < dsize; ++i) {
            byte[] name = new byte[8];
            int pos  = Integer.reverseBytes(iwad.readInt());
            int size = Integer.reverseBytes(iwad.readInt());
            iwad.read(name);

            if(Arrays.equals(pnamestr, name)) {
                poffs = pos;
                break;
            }
        }
        if(0 == poffs) { // XXX: handle ERROR
        }

        // read in the PNAMES
        iwad.seek(poffs);
        numps = Integer.reverseBytes(iwad.readInt());
        for(int i = 0; i < numps; ++i) {
            byte[] name = new byte[8];
            iwad.read(name);
            pnames.put((new String(name, StandardCharsets.US_ASCII)).replaceAll("\0",""), i);
        }
        iwad.close();
    }

  // check for any patches used not in the IWAD
  void findNewPatches() {
    for( Texture tex : wp.textures.values() ) {
      for( Patch p : tex.patches ) {
        if(null == pnames.get(p.name)) {
          write_pnames = true;
          pnames.put(p.name, pnames.size());
        }
      }
    }
  }

  int writepnames() throws IOException {
    if(0==pnames.size() || !write_pnames) return 0;

    String sPnames [] = new String[pnames.size()];
    for(String key : pnames.keySet()) {
      sPnames[pnames.get(key)] = key;
    }
    writeInt(pnames.size());
    for(String p : sPnames) {
      string(p);
    }
    return 4 + 8 * pnames.size();
  }

  // figure out the version of WadC this is from a property
  String getVersion() throws java.io.IOException {
    Properties properties = new Properties();
    properties.load(getClass().getClassLoader().getResourceAsStream("git.properties"));
    return properties.get("git.commit.id.describe").toString();
  }

  /*
   * bundle the WadC source into the WAD
   * XXX: Issues:
   *    * include directives are expanded, so need to be commented out
   *    * we might need to insert an extra newline between files
   */
  int writewadcsource() throws IOException {
      byte[] nl = "\n".getBytes("UTF-8");
      int l = 0;

      for(String s : Arrays.asList(
        "-- generated with WadC version ", getVersion(), "\n",
        mf.getText() )) {

        byte[] v = s.getBytes("UTF-8");
        f.write(v);
        l += v.length;
      }

      // append local included files (not from JAR)
      for(String s : wp.includes) {
          if(Files.isRegularFile(wp.resolveinclude(s))) {
              byte[] b = wp.loadinclude(s).getBytes("UTF-8");
              f.write(nl); l += nl.length;
              f.write(b);  l += b.length;
          }
      }

      return l;
  }

}
