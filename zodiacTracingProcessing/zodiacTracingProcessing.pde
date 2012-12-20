/*******************************************************************************
 * zodiacTracingProcessing
 * Copyright Becky Stewart 
 * Anti-Alias Labs
 * December 2012 
 *
 * This file is part of chinese-zodiac-tracing.
 *
 * chinese-zodiac-tracing is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Lesser General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * chinese-zodiac-tracing is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License
 * along with chinese-zodiac-tracing.  If not, see <http://www.gnu.org/licenses/>.
 *********************************************************************************/

TracedCharacter characters[];
final int numChar = 3;

int traceLocations[];
int currTrace = 0;
final int traceLimit = 1000;

int currChar = 0;

void setup() {
  size(500, 500); 

  // load in images
  characters = new TracedCharacter[numChar];
  characters[0] = new TracedCharacter("ox.png", width, height);
  characters[1] = new TracedCharacter("dragon.png", width, height);
  characters[2] = new TracedCharacter("horse.png", width, height);
  
  // initialize trace locations
  traceLocations = new int[traceLimit];
  for ( int i=0; i<traceLimit; i++) {
   traceLocations[i] = -100; // initialize to a value outside window
  }
}

void draw() {
  background(200, 50, 150);
  if ( characters[currChar].isOver(mouseX, mouseY)) {
    background(20, 150, 150);
    
    storeTrace();
  }

  // draw to the window
  characters[currChar].drawCharacter();
  
  drawTrace();
}

void keyPressed() {
  updateCharacter(key);
}

void storeTrace() {
  if( currTrace < traceLimit-1 ) {
    traceLocations[currTrace] = mouseX;
    traceLocations[currTrace+1] = mouseY;
    currTrace +=2;
  }
  
}

void drawTrace() {
  // draw trace path
  fill(30, 30, 100);
  noStroke();
  
  for( int i=0; i<currTrace-1; i+=2) {
    ellipse(traceLocations[i], traceLocations[i+1], 30, 30);
  }
  
}

void updateCharacter(char inputChar) {
  int selectedChar = inputChar - 48;

  if ( selectedChar > 0 && selectedChar <= numChar) {
    println(selectedChar);
    currChar = selectedChar-1;
  }
}

