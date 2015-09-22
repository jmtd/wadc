/*
 * this is an attempt to capture the de-facto use of 
 * MainFrame in the rest of WadC, so we can slowly start
 * to de-couple it and add alternatives
 */
public interface WadCMainFrame {
    void msg(String m);
    // member variables that can't belong in an interface :(
        // add getters/setters?
        // wrap in a 'Config' class and get/set that?
        // could/should they be static?

    String getText();
    final WadCPrefs prefs = new WadCPrefs();

    // inserting text into the buffer
    //wp.mf.textArea1.insert(s,wp.editinsertpos);
    void insert(String s, int pos);
}
