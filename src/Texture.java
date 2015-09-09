/*
 * A doom texture definition
 */
import java.util.*;

class Texture {
    String name;
    int width, height;
    ArrayList<Patch> patches;
    public Texture(String n, int w, int h) {
        name = n;
        width = w;
        height = h;
        patches = new ArrayList<Patch>();
    }
}
