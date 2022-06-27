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
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.FileSystems;
import java.nio.file.StandardCopyOption;
import java.util.Arrays;
import java.util.List;
import java.util.ArrayList;
import java.util.stream.Collectors;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.stream.Stream;

import javax.swing.JFrame;
import javax.swing.JTextArea;
import javax.swing.JScrollPane;
import javax.swing.event.DocumentEvent;
import javax.swing.event.DocumentListener;
import javax.swing.undo.UndoManager;
import javax.swing.JMenu;
import javax.swing.JMenuBar;
import javax.swing.JMenuItem;
import javax.swing.JCheckBoxMenuItem;
import javax.swing.JRadioButtonMenuItem;
import javax.swing.ButtonGroup;
import javax.swing.KeyStroke;
import javax.swing.JTabbedPane;

public class WadC extends JFrame implements WadCMainFrame, RandomListener {
  private JTextArea programTextArea = new JTextArea("",15,30);
  private JScrollPane sp = new JScrollPane(programTextArea);
  private GroupLayout borderLayout1 = new GroupLayout(true, 2.0f, 2.0f);
  private Panel panel1 = new Panel();
  private TextArea messagesTextArea = new TextArea("",5,20);
  private TuneablePanel tunablesArea = new TuneablePanel();
  private JMenuBar mainMenuBar = new JMenuBar();
  private JMenu fileMenu = new JMenu();
  private JMenuItem newMenuItem = new JMenuItem();
  private JMenuItem openMenuItem = new JMenuItem();
  private JMenuItem saveMenuItem = new JMenuItem();
  private JMenuItem saveAsMenuItem = new JMenuItem();
  private JMenuItem preferencesMenu = new JMenuItem();
  private JMenuItem quitMenuItem = new JMenuItem();

  private EngineConfigDialog engineConfigDialog;

  private JMenu editMenu = new JMenu();
  private JMenuItem undoItem = new JMenuItem();
  private JMenuItem redoItem = new JMenuItem();

  private JMenu programMenu = new JMenu();
  private JMenuItem runMenuItem = new JMenuItem();
  private JMenuItem runSaveSaveWadMenuItem = new JMenuItem();
  private JMenuItem runSaveSaveWadBspDoomMenuItem = new JMenuItem();

  private JMenu viewMenu = new JMenu();
  private JCheckBoxMenuItem showThings = new JCheckBoxMenuItem();
  private JCheckBoxMenuItem showVertices = new JCheckBoxMenuItem();
  private JCheckBoxMenuItem showTurtle = new JCheckBoxMenuItem();

  private JMenu fillMenu = new JMenu();
  private ButtonGroup fillButtonGroup = new ButtonGroup();
  private JRadioButtonMenuItem emptySectors;//= new JRadioButtonMenuItem();
  private JRadioButtonMenuItem floorSectors;//= new JRadioButtonMenuItem();
  private JRadioButtonMenuItem ceilingSectors;//= new JRadioButtonMenuItem();
  private JRadioButtonMenuItem lightSectors;//= new JRadioButtonMenuItem();

  private JMenuItem fontSizeDownItem = new JMenuItem();
  private JMenuItem fontSizeUpItem = new JMenuItem();

  private JTabbedPane tabbedPane = new JTabbedPane();

  private Canvas cv;
  UndoManager manager = new UndoManager();

  WadParse lastwp = null;
  private boolean changed = false;

  // i18n
  private Locale locale;
  private ResourceBundle messages;

  private void initI18n() {
    locale = Locale.getDefault();
    messages = ResourceBundle.getBundle("MessagesBundle", locale);
  }

  private String __(String s) {
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

  private void jbInit() throws Exception {
    setTitle("wadc");

    engineConfigDialog = new EngineConfigDialog(this, prefs);
    engineConfigDialog.pack();

    final int MENU_SHORTCUT_MASK = Toolkit.getDefaultToolkit().getMenuShortcutKeyMask();

    programTextArea.setFont(new Font("Monospaced",0, prefs.getInt("fontSize", 18)));
    programTextArea.getDocument().addDocumentListener(new DocumentListener() {
        public void removeUpdate(DocumentEvent e) {
            textArea1_textValueChanged();
        }
        public void insertUpdate(DocumentEvent e) {
            textArea1_textValueChanged(); // this:: ?
        }
        public void changedUpdate(DocumentEvent e) {}
    });
    programTextArea.getDocument().addUndoableEditListener(manager);

    panel1.setLayout(new GroupLayout(false));
    programTextArea.setBackground(Color.white);
    this.setLayout(borderLayout1);
    setBackground(Color.lightGray);
    setEnabled(true);
    setJMenuBar(mainMenuBar);
    addWindowListener(new java.awt.event.WindowAdapter() {
      public void windowClosing(WindowEvent e) {
        quit(null);
      }
    });


    fileMenu.setText(__("File"));
    
    newMenuItem.setText(__("New"));
    newMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_N, MENU_SHORTCUT_MASK));
    newMenuItem.addActionListener(this::newfile);
    openMenuItem.setText(__("Open"));
    openMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_O, MENU_SHORTCUT_MASK));
    openMenuItem.addActionListener(this::open);
    saveAsMenuItem.setText(__("Save As"));
    saveAsMenuItem.addActionListener(this::saveAs);
    saveMenuItem.setText(__("Save"));
    saveMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_S, MENU_SHORTCUT_MASK));
    saveMenuItem.addActionListener(this::save);
    preferencesMenu.setText(__("Preferences"));
    preferencesMenu.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_COMMA, MENU_SHORTCUT_MASK));
    preferencesMenu.addActionListener(new java.awt.event.ActionListener() {
      public void actionPerformed(ActionEvent e) {
        engineConfigDialog.setVisible(true);
      }
    });
    quitMenuItem.setText(__("Quit"));
    quitMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_Q, MENU_SHORTCUT_MASK));
    quitMenuItem.addActionListener(this::quit);

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
    showTurtle.setText(__("Show the cursor"));
    showTurtle.setState(prefs.getBoolean("renderturtle"));
    showTurtle.addItemListener(new ItemListener() {
        public void itemStateChanged(ItemEvent e) {
            prefs.toggle("renderturtle");
            cv.repaint();
        }
    });

    fillMenu.setText(__("Sector Fill"));

    SectorFill fill = prefs.getEnum("fillsectors");
    emptySectors = new JRadioButtonMenuItem(__("None"), SectorFill.NONE == fill);
    floorSectors = new JRadioButtonMenuItem(__("Floor height"), SectorFill.FLOORHEIGHT == fill);
    ceilingSectors = new JRadioButtonMenuItem(__("Ceiling height"), SectorFill.CEILINGHEIGHT == fill);
    lightSectors = new JRadioButtonMenuItem(__("Light level"), SectorFill.LIGHTLEVEL == fill);
    fillButtonGroup.add(emptySectors);
    fillButtonGroup.add(floorSectors);
    fillButtonGroup.add(ceilingSectors);
    fillButtonGroup.add(lightSectors);

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
    ceilingSectors.addItemListener(new ItemListener() {
        public void itemStateChanged(ItemEvent e) {
            prefs.putEnum("fillsectors", SectorFill.CEILINGHEIGHT);
            cv.repaint();
        }
    });
    lightSectors.addItemListener(new ItemListener() {
        public void itemStateChanged(ItemEvent e) {
            prefs.putEnum("fillsectors", SectorFill.LIGHTLEVEL);
            cv.repaint();
        }
    });

    fontSizeDownItem.setText(__("Decrease font size"));
    fontSizeDownItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_MINUS, MENU_SHORTCUT_MASK));
    fontSizeDownItem.addActionListener(new java.awt.event.ActionListener() {
        public void actionPerformed(ActionEvent e) {
            Font f = programTextArea.getFont();
            Float ff = f.getSize2D() - 1.0f;
            programTextArea.setFont(f.deriveFont(ff));
            prefs.putInt("fontSize", ff.intValue());
        }
    });
    fontSizeUpItem.setText(__("Increase font size"));
    fontSizeUpItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_EQUALS, MENU_SHORTCUT_MASK));
    fontSizeUpItem.addActionListener(new java.awt.event.ActionListener() {
        public void actionPerformed(ActionEvent e) {
            Font f = programTextArea.getFont();
            Float ff = f.getSize2D() + 1.0f;
            programTextArea.setFont(f.deriveFont(ff));
            prefs.putInt("fontSize", ff.intValue());
        }
    });

    programMenu.setText(__("Program"));
    
    runMenuItem.setText(__("Run"));
    runMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_R, MENU_SHORTCUT_MASK));
    runMenuItem.addActionListener(this::run);
    runSaveSaveWadMenuItem.setLabel(__("Run / Save / Save Wad"));
    runSaveSaveWadMenuItem.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_W, MENU_SHORTCUT_MASK));
    runSaveSaveWadMenuItem.addActionListener(this::savewad);
    runSaveSaveWadBspDoomMenuItem.setText(__("Run / Save / Save Wad / BSP / DOOM"));
    runSaveSaveWadBspDoomMenuItem.addActionListener(e -> bspdoom(savewad(e)));
    add(sp, "b");
    
    mainMenuBar.add(fileMenu);
    mainMenuBar.add(editMenu);
    mainMenuBar.add(programMenu);
    mainMenuBar.add(viewMenu);

    fileMenu.add(newMenuItem);
    fileMenu.add(openMenuItem);
    fileMenu.add(saveAsMenuItem);
    fileMenu.add(saveMenuItem);
    fileMenu.add(preferencesMenu);
    fileMenu.add(quitMenuItem);

    editMenu.add(undoItem);
    editMenu.add(redoItem);
    
    programMenu.add(runMenuItem);
    programMenu.add(runSaveSaveWadMenuItem);
    programMenu.add(runSaveSaveWadBspDoomMenuItem);

    viewMenu.add(showThings);
    viewMenu.add(showVertices);
    viewMenu.add(showTurtle);
    viewMenu.add(fillMenu);
    viewMenu.add(fontSizeDownItem);
    viewMenu.add(fontSizeUpItem);

    fillMenu.add(emptySectors);
    fillMenu.add(floorSectors);
    fillMenu.add(ceilingSectors);
    fillMenu.add(lightSectors);
    
    cv = new WadCanvas(this);

    messagesTextArea.setEditable(false);
    tabbedPane.addTab(__("Messages"), messagesTextArea);
    tabbedPane.addTab(__("Knobs"), tunablesArea);

    panel1.add(cv,"b3");
    panel1.add(tabbedPane, "b1");
    add(panel1, "b3");
    //setSize(600,400);
    this.setLocation(50,50);
    pack();
    setVisible(true);

    String lf = loadTextFile(prefs.get("basename"));
    if(lf.length()>0) { programTextArea.setText(lf); } else { newfile(null); };

    // initial random seed.
    int s = (int)System.currentTimeMillis();
    KnobJockey.addRandomListener(this);
    KnobJockey.setSeed(s);
  }

  public void seedChanged(long s) {
    msg(__("random seed set to ") + s);
  }

  public void msg(String s) {
    messagesTextArea.append(s+"\n");
  }

  private void saveTextFile(String name, String contents) {
    try {
      Files.write(Paths.get(name), contents.getBytes("UTF-8"));
      msg(__("wrote file ")+name);
    } catch(IOException i) {
      msg(__("saving file unsuccessful: ") + name);
    }
  }

  private String loadTextFile(String name) {
    try {
      String contents = Files
              .readAllLines(Paths.get(name))
              .stream()
              .collect(Collectors.joining("\n")) + "\n";
      msg(__("file read: ") + name);
      return contents;
    } catch(IOException i) {
      msg(__("couldn't load file ") + name);
    }
    return "";
  }

  void newfile(ActionEvent e) {
    programTextArea.setText("#\"standard.h\"\n\nmain {\n  straight(64)\n}\n");
    // XXX: nasty hack to ensure basename is always a FQ path
    prefs.put("basename", new File(System.getProperty("user.home"), "untitled.wl").toString());
    KnobJockey.getInstance().clear();
  }

  private void open(ActionEvent e) {
    FileDialog fd = new FileDialog(this, __("select a .wl file to load"), FileDialog.LOAD);
    fd.setDirectory((new File(prefs.get("basename"))).getParent());
    fd.setVisible(true);
    String name = fd.getFile();
    if(name==null) return;
    prefs.put("basename", (new File(fd.getDirectory(),name)).toString());
    programTextArea.setText(loadTextFile(prefs.get("basename")));
    KnobJockey.getInstance().clear();
  }

  private void saveAs(ActionEvent e) {
    FileDialog fd = new FileDialog(this, __("save program (.wl)"), FileDialog.SAVE);
    fd.setDirectory((new File(prefs.get("basename"))).getParent());
    fd.setFile((new File(prefs.get("basename"))).getName()); //File f = new File(); f.
    fd.setVisible(true);
    String name = fd.getFile();
    if( name == null) {
      return;
    }
    prefs.put("basename", (new File(fd.getDirectory(),name)).toString());
    save(e);
  }

  private void save(ActionEvent e) {
    saveTextFile(prefs.get("basename"), programTextArea.getText());
    changed = false;
  }

  private void quit(ActionEvent e) {
    if (changed) {
      saveAs(e);
    }
    System.exit(1);
  }

  private void run(ActionEvent e) {
    messagesTextArea.setText("");
    WadParse wp = new WadParse(programTextArea.getText(),this);
    if(wp.err!=null) {
      programTextArea.setCaretPosition(wp.pos);
    } else {
      msg(__("parsed successfully, evaluating..."));

      try {
          wp.run();
      } catch(Error err) {
          wp.mf.msg("eval: "+err.getMessage());

          List<String> stacktrace = wp.wr.stacktrace;
          if(stacktrace.size()>0) {
            String s = "stacktrace: ";
            int st = stacktrace.size()-10;
            if(st<0) st = 0;
            for(int i = stacktrace.size()-1; i>=st; i--) {
              s += (stacktrace.get(i))+"\n";
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
      }
      lastwp = wp;
      cv.repaint();
    }
  }

  private String savewad(ActionEvent e) {
    run(e);
    String wadfile = null;
    if (lastwp == null || lastwp.err != null) {
      //msg("wadsave: can only save wad after program has been run successfully");
    } else {
      String basename = prefs.get("basename");
      save(e);
      wadfile = basename.substring(0, basename.lastIndexOf('.')) + ".wad";
      Wad wad = new Wad(lastwp,this,wadfile,true);
      wad.run();
    }
    return wadfile;
  }

  private void textArea1_textValueChanged() {
    changed = true;
    if(lastwp!=null) {
      if(lastwp.editchanged==0) lastwp.editchanged = 2;
      if(lastwp.editchanged==1) lastwp.editchanged = 0;
    }
  }

  // helper routine for invoking bsp, doom, etc.
  private void subcmd(List<String> cmd) {
    ProcessBuilder pb = new ProcessBuilder(cmd);
    pb.inheritIO();
    msg(__("launching: ") + String.join(" ", cmd));

    try {
      if(pb.start().waitFor() != 0) msg(__("cmd failed? ") + cmd.get(0));
    } catch(Exception e) {
      msg(__("command interrupted! ") + cmd.get(0));
    }
  }

  private void bspdoom(String wadfile) {
    if(wadfile==null) return;

    File tmpfile;
    try {
      tmpfile = File.createTempFile(wadfile, ".tmp");
      subcmd(Arrays.asList(prefs.get("bspcmd"), wadfile, "-o", tmpfile.getCanonicalPath()));
      Files.copy(tmpfile.toPath(), FileSystems.getDefault().getPath(wadfile), StandardCopyOption.REPLACE_EXISTING);
      tmpfile.delete();
    } catch (IOException e) {
        msg(__("IO Error with BSP! "));
        msg(e.getMessage());
        return;
    }

    ArrayList<String> cmd = new ArrayList<>();
    cmd.add(prefs.get("doomexe"));
    cmd.addAll(Arrays.asList(prefs.get("doomargs").split("\\s+")));
    cmd.addAll(Stream.of(prefs.get("twad1"), prefs.get("twad2"), prefs.get("twad3"), wadfile)
        .filter(s -> !"".equals(s))
        .collect(Collectors.toList()));

    subcmd(cmd);
  }

  public String getText() {
      return programTextArea.getText();
  }

  public void insert(String s, int pos) {
      programTextArea.insert(s, pos);
  }
}
