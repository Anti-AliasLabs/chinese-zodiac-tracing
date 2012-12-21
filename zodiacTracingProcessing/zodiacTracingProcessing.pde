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
final int numChar = 12;

int traceLocations[];
int currTrace = 0;
final int traceLimit = 5000;

int currChar = 0;

int resetTime = 10; // 1 minute
int lastMovement = 0;


float penX, penY, penZ;

void setup() {
  size(1024, 768); 

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
  characters[0] = new TracedCharacter("ox.png");
  characters[1] = new TracedCharacter("dragon.png");
  characters[2] = new TracedCharacter("horse.png");
  characters[3] = new TracedCharacter("ram.png");
  characters[4] = new TracedCharacter("rabbit.png");
  characters[5] = new TracedCharacter("snake.png");
  characters[6] = new TracedCharacter("boar.png");
  characters[7] = new TracedCharacter("mouse.png");
  characters[8] = new TracedCharacter("dog.png");
  characters[9] = new TracedCharacter("tiger.png");
  characters[10] = new TracedCharacter("monkey.png");
  characters[11] = new TracedCharacter("rooster.png");

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

  // transform hand to window pixels
  mapHandToPen(handVec.x, handVec.y);
  // if hand is being tracked and close enough to camera
  if ( characters[currChar].isOver(mouseX, mouseY) && handsTrackFlag && handVec.z < 1100) {
    background(20, 150, 150);


    storeTrace(int(penX), int(penY));
    println(context.sceneWidth() - handVec.y);
    lastMovement = second();
  }

  // check time and reset if necessary
  if ( lastMovement-second() > resetTime ) {
    println("resetting tracing array");
    for ( int i=0; i<traceLimit; i++) {
      traceLocations[i] = -100; // initialize to a value outside window
    }
    lastMovement = second();
  } 

  // draw to the window
  characters[currChar].drawCharacter();

  drawTrace();
  fill(255);
  ellipse(penX, penY, 15, 15);
  //text(handVec.x + " " + handVec.y + " " + handVec.z, 100, 100);
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
  fill(200);
  noStroke();

  for ( int i=0; i<currTrace-1; i+=2) {
    ellipse(traceLocations[i], traceLocations[i+1], 20, 20);
  }
}

void updateCharacter(char inputChar) {
  // 1-9 for [0] to [8]
  // A for [9]
  // B for [10]
  // C for [11]

  switch (inputChar) {
  case 'A':
    currChar = 9;
    break;
  case 'B':
    currChar = 10;
    break;
  case 'C':
    currChar = 11; 
    break;
  default:
    int selectedChar = inputChar - 48;

    if ( selectedChar > 0 && selectedChar <= numChar) {
      println(selectedChar);
      currChar = selectedChar-1;
    }
  }
}


void mapHandToPen(float handX, float handY) {
  // x ranges from -500 to 500
  // y rangers from -30 to 410
  // z pen down < 1000, pen up > 1000

  penX = map(handX, -500, 500, 0, width);
  penY = map(handY, -30, 410, 0, height) * -1;
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

