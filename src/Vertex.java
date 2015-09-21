/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2015 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

import java.util.*;

public class Vertex {
  int idx;
  int x,y;
  Vector v = new Vector();
  public int hashCode() { return (x*y)>>8; }
  void insert(Line l) {
    int ang = angle(l);
    for(int i = 0;i<v.size();i++) {
      if(ang<angle((Line)v.elementAt(i))) {
        v.insertElementAt(l,i);
        return;
      };
    };
    v.addElement(l);
  };
  void remove(Line l) {
    v.removeElement(l);
    /*for(int i = 0;i<v.size();i++) {
     if(l==((Line)v.elementAt(i))) {
     v.removeElementAt(i);
     return;
     };
     };  */
  };
  int angle(Line l) {
    Vertex other = l.from==this?l.to:l.from;
    //return (int)(Math.atan2(other.x/(double)x,other.y/(double)y)/3.14159*180.0);
    //return (int)(Math.atan2(other.y/(double)other.x,y/(double)x)/3.14159*180.0);
    return (int)(Math.atan2((double)(other.x-x),(double)(other.y-y))/3.14159*180.0);
  };
}

