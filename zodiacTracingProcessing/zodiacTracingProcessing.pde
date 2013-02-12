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
import processing.serial.*;
import proxml.*;

Serial myPort; // The serial port:

// SimpleOpenNI variables
SimpleOpenNI context;
boolean      handsTrackFlag = false;
PVector      handVec = new PVector();
ArrayList    handVecList = new ArrayList();
int          handVecListSize = 30;
String       lastGesture = "";


// Tracing and character variables
HashMap charImages;

//xml element to load the images
XMLElement characters;
XMLInOut xmlInOut;

PImage wave;
PImage countdown1;
PImage countdown2;
PImage countdown3;
PImage drawImage;
boolean showInstructions = true;
boolean showCountdown = false;

Pen pen;
boolean prevPenState = false;

String currChar = "";

int resetTime = 30000;
int lastMovement = 0;
int countdownTimer = 0;


float penX, penY, penZ;

// background images
PImage penBG;
PImage noPenBG;
PImage penCursor;

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
  context.addGesture("RaiseHand");

  // set up port for Arduino
  // You may need to change the number in [ ] to match 
  // the correct port for your system
  myPort = new Serial(this, Serial.list()[0], 9600);
  myPort.bufferUntil('\r');

  // set up array list of character PImages
  charImages = new HashMap();

  //load file if it exists
  xmlInOut = new XMLInOut(this);
  try {
    xmlInOut.loadElement("characters.xml");
  }
  catch(Exception e) {
    // error, couldn't find file
    println("Error: couldn't find characters.xml");
  }

  imageMode(CENTER);
  penBG = loadImage("pen.jpg");
  noPenBG = loadImage("no_pen.jpg");

  penCursor = loadImage("pen_cursor.png");
  pen = new Pen();

  wave = loadImage("wave.png");
  countdown1  = loadImage("position1.png");
  countdown2  = loadImage("position2.png");
  countdown3  = loadImage("position3.png");
  drawImage = loadImage("draw.png");

  noCursor();
  smooth();
}

void draw() {
  // update the Kinect
  context.update();

  if ( showInstructions || showCountdown ) {
    drawBackgroundAndCharacter( false );

    if (showInstructions)
      image(wave, width/2, height/2, width, height);

    if ( showCountdown ) {
      startInteraction();

      // transform hand to window pixels
      mapHandToPen(handVec.x, handVec.y);
      // if hand is being tracked
      if ( handsTrackFlag ) {
        fill(255);
        noStroke();

        ellipse(penX, penY, 15, 15);
        lastMovement = millis();
      }
    }
  }
  else {

    // transform hand to window pixels
    mapHandToPen(handVec.x, handVec.y);
    // if hand is being tracked and close enough to camera
    if ( handsTrackFlag && handVec.z < 1100) {
      background(penBG);
      drawBackgroundAndCharacter( true );

      pen.display();

      image(penCursor, penX, penY);

      pen.record(int(penX), int(penY));
      lastMovement = millis();
      prevPenState = true;
    }
    else {
      background(noPenBG);
      drawBackgroundAndCharacter( false );

      pen.display();

      // show where hand is being tracked
      fill(255);
      noStroke();

      ellipse(penX, penY, 15, 15);
      if (prevPenState) {
        pen.up();
      }
      prevPenState = false;
    }
  }

  // check time and reset if necessary
  if ( (millis()-lastMovement) > resetTime ) {
    resetTracing();
    showInstructions = true;
  } 


  //text(handVec.x + " " + handVec.y + " " + handVec.z, 100, 100);
}

// -----------------------------------------------------------------
// character tracing

void resetTracing() {
  println("resetting tracing array");
  pen.reset();
  drawBackgroundAndCharacter( false );
  lastMovement = millis();
}

void startInteraction() {
  int elapsed = millis()-countdownTimer;
  resetTracing();

  if ( elapsed < 1000 )
    image(countdown3, width/2, height/2, width, height);
  if ( elapsed >= 1000 && elapsed < 2000 )
    image(countdown2, width/2, height/2, width, height);
  if ( elapsed >= 2000 && elapsed < 3000 )
    image(countdown1, width/2, height/2, width, height);
  if ( elapsed >= 3000 && elapsed < 4000)
    image(drawImage, width/2, height/2, width, height);
  if ( elapsed > 4000 ) 
    showCountdown = false;
}

void drawBackgroundAndCharacter(boolean penDown) {
  if ( penDown) {
    background(penBG);
    if ( currChar != "" ) {
      TracedCharacter tc = (TracedCharacter) charImages.get(currChar);
      tc.drawCharacter();
    }
  } 
  else {
    background(noPenBG);
    if ( currChar != "" ) {
      TracedCharacter tc = (TracedCharacter) charImages.get(currChar);
      tc.drawCharacter();
    }
  }
}

void keyPressed() {
  Character c = key;
  updateCharacter( c.toString() );
}

void updateCharacter(String inputChar) {
  if ( charImages.containsKey(inputChar) ) {
    resetTracing();
    currChar = inputChar;

    // show countdown again
    showCountdown = true;
    countdownTimer = millis();
  } 
  else {
    if ( inputChar.equals("D") ) {
      resetTracing();
      // show countdown again
      showCountdown = true;
      countdownTimer = millis();
    } 
    else {
      println("Not known key");
    }
  }
}

void updateCharacter(String inputChar, boolean countdown) {
  if ( charImages.containsKey(inputChar) ) {
    resetTracing();
    currChar = inputChar;
  } 
  else {
    if ( inputChar.equals("D") ) {
      resetTracing();
    } 
    else {
      println("Not known key");
    }
  }
}


void mapHandToPen(float handX, float handY) {
  // x ranges from -500 to 500
  // y ranges from -30 to 410
  // z pen down < 1000, pen up > 1000

  penX = map(handX, -500, 500, 0, width);
  penY = handY * -1.73 + 508;
  //println(handY + " " + penY);
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

  showInstructions = false;
  showCountdown = true;
  countdownTimer = millis();

  println("---- start countdown from onCreateHands");
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
  showInstructions = true;
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

// -----------------------------------------------------------------
// XML events
void xmlEvent(XMLElement element) {
  characters = element;
  loadNewImage();
}

//draw all ellipses saved in the xml file
void loadNewImage() {
  //characters.printElementTree(" ");
  XMLElement[] character;
  XMLElement[] elements;
  String filename = "";
  String card = "";
  TracedCharacter charImage;

  println(characters.countChildren());
  for (int i = 0; i < characters.countChildren();i++) {
    // retrieve character
    character = characters.getChild(i).getChildren();

    // get card number and filename
    for (int j=0; j<character.length; j++) {
      if ( character[j].getElement().equals( "card" )) {
        card = character[j].getChild(0).getElement();
      }
      if ( character[j].getElement().equals( "filename" )) {
        filename = character[j].getChild(0).getElement();
      }
    }
    charImage = new TracedCharacter(filename);
    charImages.put(card, charImage);
  }
  // set character to display
  updateCharacter("1", false);
}


// -----------------------------------------------------------------
// serial events
void serialEvent(Serial myPort) {
  // read a byte from the serial port:
  String inString = myPort.readStringUntil('\r');
  println(inString);

  String trimmedString = trim( inString );
  println( trimmedString);
  //updateCharacter( trimmedString.charAt(0) );
  updateCharacter( trimmedString );
}

