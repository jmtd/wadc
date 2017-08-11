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
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JRadioButtonMenuItem;
import javax.swing.ButtonGroup;
import javax.swing.KeyStroke;

import java.nio.file.Files;
import java.nio.file.Paths;

public class WadC extends JFrame implements WadCMainFrame {
  JTextArea textArea1 = new JTextArea("",15,30);
  JScrollPane sp = new JScrollPane(textArea1);
  GroupLayout borderLayout1 = new GroupLayout(true, 2.0f, 2.0f);
  Panel panel1 = new Panel();
  TextArea textArea2 = new TextArea("",5,20);
  JMenuBar menuBar1 = new JMenuBar();
  JMenu menu1 = new JMenu(); // file
  JMenuItem menuItem1 = new JMenuItem(); // new
  JMenuItem menuItem2 = new JMenuItem(); // open
  JMenuItem menuItem3 = new JMenuItem(); // save
  JMenuItem menuItem4 = new JMenuItem(); // save as
  JMenuItem preferencesMenu = new JMenuItem(); // preferences
  JMenuItem menuItem5 = new JMenuItem(); // quit

  EngineConfigDialog engineConfigDialog;

  JMenu editMenu = new JMenu();
  JMenuItem undoItem = new JMenuItem();
  JMenuItem redoItem = new JMenuItem();

  JMenu menu2 = new JMenu(); // program
  JMenuItem menuItem6 = new JMenuItem(); // run
  JMenuItem menuItem7 = new JMenuItem(); // run / save
  JMenuItem menuItem8 = new JMenuItem(); // ... / bsp / doom

  JMenu viewMenu = new JMenu();
  JCheckBoxMenuItem showThings = new JCheckBoxMenuItem();
  JCheckBoxMenuItem showVertices = new JCheckBoxMenuItem();

  JMenu fillMenu = new JMenu();
  ButtonGroup fillButtonGroup = new ButtonGroup();
  JRadioButtonMenuItem emptySectors;
  JRadioButtonMenuItem floorSectors;

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

  private void jbInit() throws Exception {
    setTitle("wadc");

    engineConfigDialog = new EngineConfigDialog(this, prefs);
    engineConfigDialog.pack();

    final int MENU_SHORTCUT_MASK = Toolkit.getDefaultToolkit().getMenuShortcutKeyMask();

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
    setJMenuBar(menuBar1);
    addWindowListener(new java.awt.event.WindowAdapter() {
      public void windowClosing(WindowEvent e) {
        quit(null);
      }
    });
    menu1.setText(__("File"));
    menuItem1.setText(__("New"));
    menuItem1.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_N, MENU_SHORTCUT_MASK));
    menuItem1.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        newfile(e);
      }
    });
    menuItem2.setText(__("Open"));
    menuItem2.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_O, MENU_SHORTCUT_MASK));
    menuItem2.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        open(e);
      }
    });
    menuItem3.setText(__("Save As"));
    menuItem3.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        saveas(e);
      }
    });
    menuItem4.setText(__("Save"));
    menuItem4.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_S, MENU_SHORTCUT_MASK));
    menuItem4.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        save(e);
      }
    });
    preferencesMenu.setText(__("Preferences"));
    preferencesMenu.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_COMMA, MENU_SHORTCUT_MASK));
    preferencesMenu.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        engineConfigDialog.setVisible(true);
      }
    });

    menuItem5.setText(__("Quit"));
    menuItem5.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_Q, MENU_SHORTCUT_MASK));
    menuItem5.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        quit(e);
      }
    });

    editMenu.setText(__("Edit"));
    undoItem.setText(__("Undo"));
    undoItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_Z, MENU_SHORTCUT_MASK)); // VK_UNDO?
    undoItem.addActionListener(new java.awt.event.ActionListener() {
        public void actionPerformed(ActionEvent e) {
            manager.undo();
        }
    });
    redoItem.setText(__("Redo")); // XXX: shortcuts
    redoItem.addActionListener(new java.awt.event.ActionListener() {
        public void actionPerformed(ActionEvent e) {
            manager.redo();
        }
    });

    menu2.setText(__("Program"));
    menuItem6.setText(__("Run"));
    menuItem6.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_R, MENU_SHORTCUT_MASK));
    menuItem6.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        run(e);
      }
    });
    menuItem7.setText(__("Run / Save / Save Wad"));
    menuItem7.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_W, MENU_SHORTCUT_MASK));
    menuItem7.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        savewad(e);
      }
    });
    menuItem8.setText(__("Run / Save / Save Wad / BSP / DOOM"));
    menuItem8.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        bspdoom(savewad(e));
      }
    });

    viewMenu.setText(__("View"));
    showThings.setText(__("Show things"));
    showThings.setState(prefs.getBoolean("renderthings"));
    showThings.addItemListener(new ItemListener() {
        public void itemStateChanged(ItemEvent e) {
            prefs.toggle("renderthings");
            cv.repaint();
        }
    });
    showVertices.setText(__("Show vertices"));
    showVertices.setState(prefs.getBoolean("renderverts"));
    showVertices.addItemListener(new ItemListener() {
        public void itemStateChanged(ItemEvent e) {
            prefs.toggle("renderverts");
            cv.repaint();
        }
    });

    fillMenu.setText(__("Sector Fill"));

    SectorFill fill = prefs.getEnum("fillsectors");
    emptySectors = new JRadioButtonMenuItem(__("None"), SectorFill.NONE == fill);
    floorSectors = new JRadioButtonMenuItem(__("Floor height"), SectorFill.FLOORHEIGHT == fill);
    fillButtonGroup.add(emptySectors);
    fillButtonGroup.add(floorSectors);

    emptySectors.addItemListener(new ItemListener() {
        public void itemStateChanged(ItemEvent e) {
            prefs.putEnum("fillsectors", SectorFill.NONE);
            cv.repaint();
        }
    });
    floorSectors.addItemListener(new ItemListener() {
        public void itemStateChanged(ItemEvent e) {
            prefs.putEnum("fillsectors", SectorFill.FLOORHEIGHT);
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
