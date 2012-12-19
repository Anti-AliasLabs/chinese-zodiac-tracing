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

PImage characters[];
final int numChar = 3;

int currChar = 0;

void setup() {
  size(500, 500); 

  // load in images
  characters = new PImage[numChar];
  characters[0] = loadImage("ox.png");
  characters[1] = loadImage("dragon.png");
  characters[2] = loadImage("horse.png");
}

void draw() {
  background(20, 150, 150);
  image(characters[currChar], 0, 0, width, height);
}

void keyPressed() {
  switch( key ) {
  case '1':
    currChar = 0;
    break;

  case '2':
    currChar = 1;
    break;

  case '3':
    currChar = 2;
    break;
  }
}
