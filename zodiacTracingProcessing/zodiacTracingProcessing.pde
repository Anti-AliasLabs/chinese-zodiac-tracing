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

import SimpleOpenNI.*;

// SimpleOpenNI variables
SimpleOpenNI context;
boolean      handsTrackFlag = false;
PVector      handVec = new PVector();
ArrayList    handVecList = new ArrayList();
int          handVecListSize = 30;
String       lastGesture = "";


// Tracing and character variables
TracedCharacter characters[];
final int numChar = 3;

int traceLocations[];
int currTrace = 0;
final int traceLimit = 1000;

int currChar = 0;

int resetTime = 1; // 1 minute
int lastMovement = 0;

void setup() {
  size(500, 500); 

  // setup Kinect
  context = new SimpleOpenNI(this);

  // disable mirror
  context.setMirror(true);

  // enable depthMap generation 
  if (context.enableDepth() == false)
  {
    println("Can't open the depthMap, maybe the camera is not connected!"); 
    exit();
    return;
  }

  // enable hands + gesture generation
  context.enableGesture();
  context.enableHands();

  // add waving recognition
  context.addGesture("Wave");

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

  smooth();
}

void draw() {
  // update the Kinect
  context.update();


  background(200, 50, 150);
  if ( characters[currChar].isOver(mouseX, mouseY) && handsTrackFlag) {
    background(20, 150, 150);

    storeTrace(int(handVec.x), int(handVec.y));
    lastMovement = minute();
  }

  // check time and reset if necessary
  if ( lastMovement-minute() > resetTime ) {
    for ( int i=0; i<traceLimit; i++) {
      traceLocations[i] = -100; // initialize to a value outside window
    }
  } 

  // draw to the window
  characters[currChar].drawCharacter();

  drawTrace();
}

// -----------------------------------------------------------------
// character tracing

void keyPressed() {
  updateCharacter(key);
}

void storeTrace(int traceX, int traceY) {
  if ( currTrace < traceLimit-1 ) {
    traceLocations[currTrace] = traceX;
    traceLocations[currTrace+1] = traceY;
    currTrace +=2;
  }
}

void drawTrace() {
  // draw trace path
  fill(30, 30, 100);
  noStroke();

  for ( int i=0; i<currTrace-1; i+=2) {
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


// -----------------------------------------------------------------
// hand events

void onCreateHands(int handId, PVector pos, float time)
{
  println("onCreateHands - handId: " + handId + ", pos: " + pos + ", time:" + time);

  handsTrackFlag = true;
  handVec = pos;

  handVecList.clear();
  handVecList.add(pos);
}

void onUpdateHands(int handId, PVector pos, float time)
{
  //println("onUpdateHandsCb - handId: " + handId + ", pos: " + pos + ", time:" + time);
  handVec = pos;

  handVecList.add(0, pos);
  if (handVecList.size() >= handVecListSize)
  { // remove the last point 
    handVecList.remove(handVecList.size()-1);
  }
}

void onDestroyHands(int handId, float time)
{
  println("onDestroyHandsCb - handId: " + handId + ", time:" + time);

  handsTrackFlag = false;
  context.addGesture(lastGesture);
}

// -----------------------------------------------------------------
// gesture events

void onRecognizeGesture(String strGesture, PVector idPosition, PVector endPosition)
{
  println("onRecognizeGesture - strGesture: " + strGesture + ", idPosition: " + idPosition + ", endPosition:" + endPosition);

  lastGesture = strGesture;
  context.removeGesture(strGesture); 
  context.startTrackingHands(endPosition);
}

void onProgressGesture(String strGesture, PVector position, float progress)
{
  //println("onProgressGesture - strGesture: " + strGesture + ", position: " + position + ", progress:" + progress);
}

