/*
 * Copyright © 2001-2008 Wouter van Oortmerssen
 * Copyright © 2008-2016 Jonathan Dowland <jon@dow.land>
 *
 * Distributed under the terms of the GNU GPL Version 2
 * See file LICENSE.txt
 */

package org.redmars.wadc;

import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.Vector;

import javax.swing.JFrame;
import javax.swing.JTextArea;
import javax.swing.JScrollPane;
import javax.swing.event.DocumentEvent;
import javax.swing.undo.UndoManager;

import java.nio.file.Files;
import java.nio.file.Paths;

public class WadC extends JFrame implements WadCMainFrame {
  JTextArea textArea1 = new JTextArea("",15,30);
  JScrollPane sp = new JScrollPane(textArea1);
  GroupLayout borderLayout1 = new GroupLayout(true, 2.0f, 2.0f);
  Panel panel1 = new Panel();
  TextArea textArea2 = new TextArea("",5,20);
  MenuBar menuBar1 = new MenuBar();
  Menu menu1 = new Menu(); // file
  MenuItem menuItem1 = new MenuItem(); // new
  MenuItem menuItem2 = new MenuItem(); // open
  MenuItem menuItem3 = new MenuItem(); // save
  MenuItem menuItem4 = new MenuItem(); // save as
  MenuItem preferencesMenu = new MenuItem(); // preferences
  MenuItem menuItem5 = new MenuItem(); // quit

  EngineConfigDialog engineConfigDialog;

  Menu editMenu = new Menu();
  MenuItem undoItem = new MenuItem();
  MenuItem redoItem = new MenuItem();

  Menu menu2 = new Menu(); // program
  MenuItem menuItem6 = new MenuItem(); // run
  MenuItem menuItem7 = new MenuItem(); // run / save
  MenuItem menuItem8 = new MenuItem(); // ... / bsp / doom

  Menu viewMenu = new Menu();
  CheckboxMenuItem showThings = new CheckboxMenuItem();
  CheckboxMenuItem showVertices = new CheckboxMenuItem();

  Menu fillMenu = new Menu();
  CheckboxMenuItem emptySectors = new CheckboxMenuItem();
  CheckboxMenuItem floorSectors = new CheckboxMenuItem();

  Canvas cv;
  UndoManager manager = new UndoManager();

  WadParse lastwp = null;
  boolean changed = false;

  // i18n
  Locale locale;
  ResourceBundle messages;

  void initI18n() {
    locale = Locale.getDefault();
    messages = ResourceBundle.getBundle("MessagesBundle", locale);
  }

  String __(String s) {
    if(messages.containsKey(s)) return messages.getString(s);
    return s;
  }

  public WadC() {
    try  {
      initI18n();
      jbInit();
    }
    catch(Exception e) {
      e.printStackTrace();
    }
  }

  public static void main(String[] args) {
    WadCMainFrame mainFrame1 = new WadC();
  }

  private void syncFillSectorItems() {
    if(prefs.getBoolean("fillsectors")) {
        emptySectors.setState(false);
        floorSectors.setState(true);
    } else {
        emptySectors.setState(true);
        floorSectors.setState(false);
    }
  }

  private void jbInit() throws Exception {
    setTitle("wadc");

    engineConfigDialog = new EngineConfigDialog(this, prefs);
    engineConfigDialog.pack();

    textArea1.setFont(new Font("Monospaced",0,12));
    textArea1.getDocument().addDocumentListener(new javax.swing.event.DocumentListener() {
      public void insertUpdate(DocumentEvent e) {
        textArea1_textValueChanged();
      }
      public void removeUpdate(DocumentEvent e) {
          textArea1_textValueChanged();
      }
      public void changedUpdate(DocumentEvent e) {
          textArea1_textValueChanged();
      }
    });
    textArea1.getDocument().addUndoableEditListener(manager);

    panel1.setLayout(new GroupLayout(false));
    textArea1.setBackground(Color.white);
    this.setLayout(borderLayout1);
    setBackground(Color.lightGray);
    setEnabled(true);
    setMenuBar(menuBar1);
    addWindowListener(new java.awt.event.WindowAdapter() {
      public void windowClosing(WindowEvent e) {
        quit(null);
      }
    });
    menu1.setLabel(__("File"));
    menuItem1.setLabel(__("New"));
    menuItem1.setShortcut(new MenuShortcut(KeyEvent.VK_N));
    menuItem1.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        newfile(e);
      }
    });
    menuItem2.setLabel(__("Open"));
    menuItem2.setShortcut(new MenuShortcut(KeyEvent.VK_O));
    menuItem2.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        open(e);
      }
    });
    menuItem3.setLabel(__("Save As"));
    menuItem3.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        saveas(e);
      }
    });
    menuItem4.setLabel(__("Save"));
    menuItem4.setShortcut(new MenuShortcut(KeyEvent.VK_S));
    menuItem4.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        save(e);
      }
    });
    preferencesMenu.setLabel(__("Preferences"));
    preferencesMenu.setShortcut(new MenuShortcut(KeyEvent.VK_COMMA));
    preferencesMenu.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        engineConfigDialog.setVisible(true);
      }
    });

    menuItem5.setLabel(__("Quit"));
    menuItem5.setShortcut(new MenuShortcut(KeyEvent.VK_Q));
    menuItem5.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        quit(e);
      }
    });

    editMenu.setLabel(__("Edit"));
    undoItem.setLabel(__("Undo"));
    undoItem.setShortcut(new MenuShortcut(KeyEvent.VK_Z)); // VK_UNDO?
    undoItem.addActionListener(new java.awt.event.ActionListener() {
        public void actionPerformed(ActionEvent e) {
            manager.undo();
        }
    });
    redoItem.setLabel(__("Redo")); // XXX: shortcuts
    redoItem.addActionListener(new java.awt.event.ActionListener() {
        public void actionPerformed(ActionEvent e) {
            manager.redo();
        }
    });

    menu2.setLabel(__("Program"));
    menuItem6.setLabel(__("Run"));
    menuItem6.setShortcut(new MenuShortcut(KeyEvent.VK_R));
    menuItem6.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        run(e);
      }
    });
    menuItem7.setLabel(__("Run / Save / Save Wad"));
    menuItem7.setShortcut(new MenuShortcut(KeyEvent.VK_W));
    menuItem7.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        savewad(e);
      }
    });
    menuItem8.setLabel(__("Run / Save / Save Wad / BSP / DOOM"));
    menuItem8.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        bspdoom(savewad(e));
      }
    });

    viewMenu.setLabel(__("View"));
    showThings.setLabel(__("Show things"));
    showThings.setState(prefs.getBoolean("renderthings"));
    showThings.addItemListener(new ItemListener() {
        public void itemStateChanged(ItemEvent e) {
            prefs.toggle("renderthings");
            cv.repaint();
        }
    });
    showVertices.setLabel(__("Show vertices"));
    showVertices.setState(prefs.getBoolean("renderverts"));
    showVertices.addItemListener(new ItemListener() {
        public void itemStateChanged(ItemEvent e) {
            prefs.toggle("renderverts");
            cv.repaint();
        }
    });

    fillMenu.setLabel(__("Sector Fill"));
    emptySectors.setLabel(__("None"));
    emptySectors.addItemListener(new ItemListener() {
        public void itemStateChanged(ItemEvent e) {
            prefs.putBoolean("fillsectors", false);
            syncFillSectorItems();
            cv.repaint();
        }
    });
    floorSectors.setLabel(__("Floor height"));
    floorSectors.addItemListener(new ItemListener() {
        public void itemStateChanged(ItemEvent e) {
            prefs.putBoolean("fillsectors", true);
            syncFillSectorItems();
            cv.repaint();
        }
    });

    add(sp, "b");
    menuBar1.add(menu1);
    menuBar1.add(editMenu);
    menuBar1.add(menu2);
    menuBar1.add(viewMenu);
    menu1.add(menuItem1);
    menu1.add(menuItem2);
    menu1.add(menuItem3);
    menu1.add(menuItem4);
    menu1.add(preferencesMenu);
    menu1.add(menuItem5);
    editMenu.add(undoItem);
    editMenu.add(redoItem);
    menu2.add(menuItem6);
    menu2.add(menuItem7);
    menu2.add(menuItem8);

    viewMenu.add(showThings);
    viewMenu.add(showVertices);
    viewMenu.add(fillMenu);

    fillMenu.add(emptySectors);
    fillMenu.add(floorSectors);
    syncFillSectorItems();

    cv = new MyCanvas(this);
    //textArea2.setBackground(Color.lightGray);
    textArea2.setEditable(false);
    panel1.add(cv,"b3");
    panel1.add(textArea2, "b1");
    add(panel1, "b3");
    //setSize(600,400);
    this.setLocation(50,50);
    pack();
    setVisible(true);

    String lf = loadtextfile(prefs.get("basename"));
    if(lf.length()>0) { textArea1.setText(lf); } else { newfile(null); };
  }

  public void msg(String s) {
    textArea2.append(s+"\n");
  }

  void savetextfile(String name, String contents) {
    try {
      Files.write(Paths.get(name), contents.getBytes("UTF-8"));
      msg(__("wrote file ")+name);
    } catch(IOException i) {
      msg(__("saving file unsuccessful: ") + name);
    };
  }

  String loadtextfile(String name) {
    try {
      BufferedReader in = new BufferedReader(new InputStreamReader(new FileInputStream(name)));
      String c = "";
      String t;
      while((t = in.readLine())!=null) c+=t+"\n";
      in.close();
      msg(__("file read: ") + name);
      return c;
    } catch(IOException i) {
      msg(__("couldn't load file ") + name);
    };
    return "";
  }

  void newfile(ActionEvent e) {
    textArea1.setText("#\"standard.h\"\n\nmain {\n  straight(64)\n}\n");
    // XXX: nasty hack to ensure basename is always a FQ path
    prefs.put("basename", new File(System.getProperty("user.home"), "untitled.wl").toString());
  }

  void open(ActionEvent e) {
    FileDialog fd = new FileDialog(this, __("select a .wl file to load"), FileDialog.LOAD);
    fd.setDirectory((new File(prefs.get("basename"))).getParent());
    fd.setVisible(true);
    String name = fd.getFile();
    if(name==null) return;
    prefs.put("basename", (new File(fd.getDirectory(),name)).toString());
    textArea1.setText(loadtextfile(prefs.get("basename")));
  }

  void saveas(ActionEvent e) {
    FileDialog fd = new FileDialog(this, __("save program (.wl)"), FileDialog.SAVE);
    fd.setDirectory((new File(prefs.get("basename"))).getParent());
    fd.setFile((new File(prefs.get("basename"))).getName()); //File f = new File(); f.
    fd.setVisible(true);
    String name = fd.getFile();
    if(name==null) return;
    prefs.put("basename", (new File(fd.getDirectory(),name)).toString());
    save(e);
  }

  void save(ActionEvent e) {
    savetextfile(prefs.get("basename"), textArea1.getText());
    changed = false;
  }

  void quit(ActionEvent e) {
    if(changed) saveas(e);
    System.exit(0);
  }

  void run(ActionEvent e) {
    textArea2.setText("");
    WadParse wp = new WadParse(textArea1.getText(),this);
    if(wp.err!=null) {
      textArea1.setCaretPosition(wp.pos);
    } else {
      msg(__("parsed successfully, evaluating..."));

      try {
          wp.run();
      } catch(Error err) {
          wp.mf.msg("eval: "+err.getMessage());

          Vector stacktrace = wp.wr.stacktrace;
          if(stacktrace.size()>0) {
            String s = "stacktrace: ";
            int st = stacktrace.size()-10;
            if(st<0) st = 0;
            for(int i = stacktrace.size()-1; i>=st; i--) {
              s += ((String)stacktrace.elementAt(i))+"\n";
            }
            wp.mf.msg(s);
          }
      }

      msg(__("done."));
      if(lastwp!=null && lastwp.wr.zoomed && (lastwp.wr.basescale<0.99f || lastwp.wr.basescale>1.01f)) {
        wp.wr.zoomed = true;
        wp.wr.basescale = lastwp.wr.basescale;
        wp.wr.scale = lastwp.wr.scale;
        wp.wr.xmid = lastwp.wr.xmid;
        wp.wr.ymid = lastwp.wr.ymid;
      };
      lastwp = wp;
      cv.repaint();
    };
  }

  String savewad(ActionEvent e) {
    run(e);
    String wadfile = null;
    if(lastwp==null || lastwp.err!=null) {
      //msg("wadsave: can only save wad after program has been run successfully");
    } else {
      String basename = prefs.get("basename");
      save(e);
      wadfile = basename.substring(0, basename.lastIndexOf('.')) + ".wad";
      Wad wad = new Wad(lastwp,this,wadfile,true);
      wad.run();
    };
    return wadfile;
  }

  void textArea1_textValueChanged() {
    changed = true;
    if(lastwp!=null) {
      if(lastwp.editchanged==0) lastwp.editchanged = 2;
      if(lastwp.editchanged==1) lastwp.editchanged = 0;
    };
  }

  // helper routine for invoking bsp, doom, etc.
  void subcmd(List<String> cmd) {
    ProcessBuilder pb = new ProcessBuilder(cmd);
    pb.inheritIO();
    msg(__("launching: ") + String.join(" ", cmd));

    try {
      if(pb.start().waitFor() != 0) msg(__("cmd failed? ") + cmd.get(0));
    } catch(Exception e) {
      msg(__("command interrupted! ") + cmd.get(0));
    };
  }

  void bspdoom(String wadfile) {
    if(wadfile==null) return;

    subcmd(Arrays.asList(prefs.get("bspcmd"), wadfile, "-o", wadfile));

    ArrayList<String> cmd = new ArrayList<String>();
    cmd.add(prefs.get("doomexe"));
    cmd.addAll(Arrays.asList(prefs.get("doomargs").split("\\s+")));
    cmd.addAll(Arrays.asList(prefs.get("twad1"), prefs.get("twad2"), prefs.get("twad3"), wadfile).stream()
        .filter(s -> !"".equals(s))
        .collect(Collectors.toList()));

    subcmd(cmd);
  }

  public String getText() {
      return textArea1.getText();
  }

  public void insert(String s, int pos) {
      textArea1.insert(s, pos);
  }
}

class MyCanvas extends Canvas {
  WadC mf;
  boolean dragged;
  int startx, starty;
  MyCanvas c = this;

  public void paint(Graphics g) {
    if(mf.lastwp!=null) mf.lastwp.wr.render(g);
  }

  MyCanvas(WadC m) {
    mf = m;
    setBackground(Color.black);
    enableEvents(AWTEvent.MOUSE_EVENT_MASK);
    addMouseListener(new MouseAdapter() {
      public void mousePressed(MouseEvent e) {
        dragged = false;
        startx = e.getX();
        starty = e.getY();
      }
      public void mouseReleased(MouseEvent e) {
        Graphics g = c.getGraphics();
        if(mf.lastwp!=null) {
          if(e.getButton() != MouseEvent.BUTTON1) {
            mf.lastwp.wr.zoom(e.getX(),e.getY(),2.0f);
          } else if((e.getModifiers()&MouseEvent.CTRL_MASK)!=0) {
             mf.lastwp.wr.addstep(e.getX(),e.getY(),'L');
          } else if((e.getModifiers()&MouseEvent.ALT_MASK)!=0) {
             mf.lastwp.wr.addstep(e.getX(),e.getY(),'C');
          } else if((e.getModifiers()&MouseEvent.SHIFT_MASK)!=0) {
             mf.lastwp.wr.addstep(e.getX(),e.getY(),'J');
          } else if(dragged && Math.abs(startx-e.getX())+Math.abs(starty-e.getY())>10) {
            mf.lastwp.wr.pan(startx,starty,e.getX(),e.getY());
          } else {
            mf.lastwp.wr.zoom(e.getX(),e.getY(),0.5f);
          };
          repaint();
        };
      }
      public void mouseClicked(MouseEvent e) {
      };
    });
    addMouseMotionListener(new MouseMotionAdapter() {
      public void mouseDragged(MouseEvent e) {
        dragged = true;
        if(mf.lastwp!=null) mf.lastwp.wr.crosshair(c.getGraphics(),(e.getModifiers()&MouseEvent.CTRL_MASK)!=0);
      };
    });
  }
}
