class Pen {
  ArrayList penPath; 

  Pen () {
    penPath = new ArrayList();
  }

  // add indicator to break line drawing
  void reset() {
    penPath.clear();
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
    
    // increase this filterSize to smooth lines
    // decrease to make drawing more sensitive
    // and decreae distortions
    // MUST BE AN EVEN NUMBER
    int filterSize = 6; 
    
    if ( penPath.size() > filterSize ) {
      fill(200);
      stroke(250, 12, 12);
      strokeWeight(16);


      PVector[] points = new PVector[filterSize];
      for (int i=filterSize; i<penPath.size(); i++) {
        
        // get a buffer of points
        int k=0;
        for ( int j=filterSize-1; j>=0; j--) {
          points[k] = (PVector)penPath.get(i+j-filterSize);
          k++;
        }


        // if there wasn't a break in the drawing
        boolean wasThereABreak = false;
        for ( int m=0; m<filterSize; m++) {
          if ( points[m].x <= 0)
            wasThereABreak = true;
        }
        if ( !wasThereABreak ) {
          // line is between the average of first half of points
          // and second half of pointw
          float firstX=0; 
          float firstY=0;
          float secondX=0;
          float secondY=0;

          for (int r=0; r<filterSize/2; r++) {
            firstX = firstX + points[r].x;
            firstY = firstY +  points[r].y;
          }
          for (int r=filterSize/2; r<filterSize; r++ ) {
            secondX = secondX + points[r].x;
            secondY = secondY + points[r].y;
          }
          
          //point( secondX/(filterSize/2), secondY/(filterSize/2) );
          line( firstX/(filterSize/2), firstY/(filterSize/2), 
                secondX/(filterSize/2), secondY/(filterSize/2) );
        }
        //if ( p1.x != -1 && p2.x != -1 && p3.x != -1 && p4.x != -1) {
        // moving average filter to smooth the lines
        //line( (p1.x+p2.x+p3.x)/3, (p1.y+p2.y+p3.y)/3, (p2.x+p3.x+p4.x)/3, (p2.y+p3.y+p4.y)/3);
      }
    }
  }
}

