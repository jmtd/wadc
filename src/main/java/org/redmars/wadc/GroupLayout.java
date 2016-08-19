/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;
import java.awt.*;
import java.util.*;

/**
 * New LayoutManager for Java AWT, layouts all components in a resizable way,
 * similar to EasyGUI, MUI, BGUI etc.
 * see LayoutTest.java for an example of usage
 *
 * The constructor takes a boolean to say wether the group needs to be layouted
 * horizontally or not. If this is the outermost pane in a frame, additionally
 * you can specify a scale factor for the window size.
 *
 * simply use the add() methods to add components to a pane as usual. The second
 * parameter to add() specifies the resize behaviour of this component:
 * - no argument means doesnt resize at all
 * - "h", "v", "b" mean resizes horizontally, vertically, or both
 * - you can optionally add a number to the string to denote
 *   the weight of this component, with "4" being the default. So for example
 *   if you have two components in a group, one being "b", and the other "b8",
 *   the second will be twice as big.
 *
 * @author Wouter van Oortmerssen, wvo96r@ecs.soton.ac.uk
 */

public class GroupLayout implements LayoutManager2 {
  boolean horiz;
  Vector resizing = new Vector();
  Vector weights = new Vector();
  Dimension dim = null;
  float factorx, factory;
  public int minresize = 10;
  public int cspace = 3;
  final int defaultweight = 4;
  int totalweight = 0;
  int realminx = 0, realminy = 0;
  GroupLayout(boolean h) {
    horiz = h; factorx = 1.0f; factory = 1.0f;
  }
  GroupLayout(boolean h, float fx, float fy) {
    horiz = h; factorx = fx; factory = fy;
  }
  public void addLayoutComponent(String name, Component c) {
    resizing.addElement(new Integer(0));
    weights.addElement(new Integer(defaultweight));
  }
  public void addLayoutComponent(Component c, Object res) {
    int v = 0;
    char r = 'n';
    int w = 4;
    if(res==null) {
      addLayoutComponent("",c);
    } else {
      String s = (String)res;
      if(s.length()>0) r = s.charAt(0);
      if(s.length()>1) w = Integer.parseInt(s.substring(1));
      if(r=='h') v = 1;
      if(r=='v') v = 2;
      if(r=='b') v = 3;
      resizing.addElement(new Integer(v));
      weights.addElement(new Integer(w));
    };
  }
  public void removeLayoutComponent(Component comp) {}
  public Dimension preferredLayoutSize(Container p) {
    Dimension d = minimumLayoutSize(p);
    return new Dimension((int)(d.width*factorx),(int)(d.height*factory));
  }
  public Dimension maximumLayoutSize(Container c) {
    return new Dimension(10000,10000);     // um?
  }
  public float getLayoutAlignmentX(Container target) { return 0.5f; }
  public float getLayoutAlignmentY(Container target) { return 0.5f; }
  public void invalidateLayout(Container target) { dim = null; }
  public Dimension minimumLayoutSize(Container p) {
    if(dim!=null) return dim;
    Insets is = p.getInsets();
    int xs = is.left+is.right;
    int ys = is.top+is.bottom;
    int maxx = 0, maxy = 0;
    int n = p.getComponentCount();
    realminx = 0;
    realminy = 0;
    totalweight = 0;
    for(int a = 0;a<n;a++) {
      Component c = p.getComponent(a);
      if(c.isVisible()) {
        int res = (Integer) resizing.elementAt(a);
        int w = (Integer) weights.elementAt(a);
        Dimension d = c.getPreferredSize();
        if(horiz) {
          xs += d.width;
          if(a!=n-1) xs+=cspace;
          maxy = Math.max(maxy,d.height);
          if((res&1)!=0) { totalweight += w; realminx -= d.width; };
        } else {
          ys += d.height;
          if(a!=n-1) ys+=cspace;
          maxx = Math.max(maxx,d.width);
          if((res&2)!=0) { totalweight += w; realminy -= d.height; };
        }
      }
    }
    realminx += xs;
    realminy += ys;
    dim = horiz?new Dimension(xs,ys+maxy):new Dimension(xs+maxx,ys);
    return dim;
  }
  public void layoutContainer(Container p) {
    Insets is = p.getInsets();
    int xs = p.getSize().width;
    int ys = p.getSize().height;
    int sx = is.left;
    int sy = is.top;
    int addx = xs-realminx;
    int addy = ys-realminy;
    int usedx = addx, usedy = addy, usedw = totalweight;
    for(int a = 0;a<p.getComponentCount();a++) {
      Component c = p.getComponent(a);
      if(c.isVisible()) {
        int res = (Integer) resizing.elementAt(a);
        int rw = (Integer) weights.elementAt(a);
        Dimension d = c.getPreferredSize();
        if(horiz) {
          int w = d.width;
          if((res&1)!=0) {
            w = addx*rw/totalweight;
            usedx -= w;
            if((usedw -=rw)==0) w += usedx;
            w = Math.max(minresize,w);
          }
          c.setBounds(sx,sy,w,ys-is.top-is.bottom);
          sx += w+cspace;
        } else {
          int h = d.height;
          if((res&2)!=0) {
            h = addy*rw/totalweight;
            usedy -= h;
            if((usedw -=rw)==0) h += usedy;
            h = Math.max(minresize,h);
          }
          c.setBounds(sx,sy,xs-is.left-is.right,h);
          sy += h+cspace;
        }
      }
    }
  }
}
