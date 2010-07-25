import java.util.*;
import java.io.*;

public class Wad {
  WadParse wp;
  WadRun wr;
  MainFrame mf;
  RandomAccessFile f;
  int curlumppos = 12;
  boolean linewarn = true;

  Wad(WadParse w, MainFrame m, String filename) {
    wp = w;
    wr = w.wr;
    mf = m;
    mf.msg("writing wad to "+filename);
    try {
      f = new RandomAccessFile(filename,"rw");
      f.writeBytes("PWAD");
      writeInt(wr.hexen ? 7 : 6);  // numentries
      writeInt(12); // dir offset
      int tsize = writethings();
      int lsize = writelines();
      int dsize = writesides();
      int vsize = writevertices();
      int ssize = writesectors();
      int bsize = writebehaviour();
      long dpos = f.getFilePointer();
      writedir("MAP01",0);
      writedir("THINGS",tsize);
      writedir("LINEDEFS",lsize);
      writedir("SIDEDEFS",dsize);
      writedir("VERTEXES",vsize);
      writedir("SECTORS",ssize);
      if(wr.hexen) writedir("BEHAVIOR", bsize);
      f.seek(8);
      writeInt((int)dpos);
      f.close();
      mf.msg("wrote wad succesfully");
    } catch(IOException i) {
      mf.msg("saving wad unsuccesful");
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
}

