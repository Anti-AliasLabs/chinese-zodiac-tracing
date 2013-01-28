class TracedCharacter {
  PImage charImage;

  int winWidth, winHeight;

  // constructor
  TracedCharacter(String filename) {
    charImage = loadImage(filename);
  } 

  // check if point is over drawing
  // currently quite broken
  boolean isOver(int pointX, int pointY) {
    return  true;
  }

  // draw the character
  void drawCharacter() {
    imageMode(CENTER);
    image(charImage, width/2, height/2, height-60, height-60);
  }
}

