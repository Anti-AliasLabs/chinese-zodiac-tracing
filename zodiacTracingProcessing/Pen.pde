class Pen {
  ArrayList penPath; 

  Pen () {
    penPath = new ArrayList();
  }

  // add indicator to break line drawing
  void penDown() {
  }

  // add indicator to start line drawing
  void up() {
    penPath.add(new PVector(-1, -1));
  }

  // store data about pen location
  void record(int penX, int penY) {
    penPath.add(new PVector(penX, penY));
  }

  // draw the line drawing
  void display() {
    if ( penPath.size() > 0 ) {
      //PVector p = (PVector)penPath.get(0);
      //println(p.x);
      for (int i=2; i<penPath.size(); i++) {
        PVector p1 = (PVector)penPath.get(i-2);
        PVector p2 = (PVector)penPath.get(i-1);
        PVector p3 = (PVector)penPath.get(i);
        
        // if there wasn't a break in the drawing
        if( p1.x != -1 && p2.x != -1 && p3.x !=-1) {
          // moving average filter to smooth the lines
          line( (p1.x+p2.x)/2, (p1.y+p2.y)/2, (p2.x+p3.x)/2, (p2.y+p3.y)/2);
        }
      }
    }
  }
}

