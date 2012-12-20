class TracedCharacter {
  PImage charImage;

  int winWidth, winHeight;

  // constructor
  TracedCharacter(String filename, int winW, int winH) {
    charImage = loadImage(filename);
    winWidth = winW;
    winHeight = winH;

    /*charImage.loadPixels();
     for(int i=0; i<(charImage.width*charImage.height); i++) {
     if(alpha(charImage.pixels[i]) == 0.0 ) {
     charImage.pixels[i] = color(255, 0, 0, 255);
     }
     }
     charImage.updatePixels();*/
  } 

  // check if point is over drawing
  // currently quite broken
  boolean isOver(int pointX, int pointY) {
    /*float pX = map(pointX, 0, winWidth, 0, charImage.width);
    float pY = map(pointY, 0, winHeight, 0, charImage.height);

    float tx = map(winWidth/2, 0, winWidth, 0, charImage.width);
    float ty = map(winHeight/2, 0, winHeight, 0, charImage.height);


    charImage.loadPixels();

    float c = alpha(charImage.pixels[int(pX+pY*charImage.width)]);

    for (int i=0; i<(charImage.width*charImage.height); i++) {
        charImage.pixels[i] = color(255, 255, 0, 255);  
      if( i%(charImage.width/4) == 0)
        charImage.pixels[i] = color(255, 0, 0, 255);
      
    }

    //println(charImage.pixels[int(pX+pY*width)]);
    println(int(pX+pY*charImage.width));
    println(charImage.width*charImage.height);
    println(charImage.pixels.length);

    //charImage.loadPixels();
    charImage.pixels[int(pX+pY*charImage.width)] = color(255, 0, 0);
    charImage.updatePixels();*/
    return  true;
  }

  // draw the character
  void drawCharacter() {
    image(charImage, 0, 0, width, height);
  }
}

