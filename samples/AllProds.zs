class AllProds
  const int nPoints = 2;
  const char exclaim = '!';

  class Point {
    int x, y;
  }

  char[] msg;
  Point[] pArr;

{
  void WriteError ()
    int i;
  {
    /* print error message */
    i = 0;
    while(i<len(msg)){write(msg[i]);i++;}
    write(exclaim);
    while (i > 0) {
      i--;
      if (i < 3) break;
      write(msg[i], 2);
    }
  }

  int GetX (Point p) { return p.x; }

  void SetX (int x, Point p) {
    if (x > -10 && x <= 9 ||
        x == 4*3/4%4+12-11*(2147483647/(-2147483647-1)%2) )
      p.x = x;
    else WriteError();
  }


  void SetMsg () {
    msg = new char[5];
    msg[0] = 'E';
    msg[1] = 'r';
    msg[2] = 'r';
    msg[3] = 'o';
    msg[4] = 'r';
  }

  void SetPoints ()
    int i;
  {
    pArr = new Point[nPoints];
    i = 0;
    while (i < len(pArr)) {
      pArr[i] = new Point;
      pArr[i].x = i;
      pArr[i].y = i;
      i++;
    }
  }

  void Main ()
    int i;
  {
    SetMsg();
    SetPoints();
    read(i);
    if (i < nPoints) {
      write(GetX(pArr[i]));
      write(pArr[i].y);
    }
    else
      WriteError();
    write('\n');
  }
}
