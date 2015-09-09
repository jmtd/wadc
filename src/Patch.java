/*
 * A doom texture patch, as represented in a Texture
 */
class Patch {
    String name;
    int xoff, yoff;
    public Patch(String n, int x, int y) {
        name = n;
        xoff = x;
        yoff = y;
    }
}
