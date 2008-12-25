import java.util.*;

public class Thing {
  int idx;
  int x,y;
  int angle;
  int type;
  int opt;
  int special = 0;
  int specialargs[] = new int[5];
  Thing() { for(int i = 0; i<5; i++) specialargs[i] = 0; }
}
