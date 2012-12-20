const int buttonPin = 7;

int buttonState = 0; 

char ox[13] = "5900294EBA84";
char dragon[13] = "59002955684D";
char horse[13] = "5900297A5A50";
char ram[13] = "590029379ED9";
char rabbit[13] = "590029803DCD";
char snake[13] = "5900292C2D71";
char boar[13] = "590029668096";
char mouse[13] = "590029867E88";
char dog[13] = "590029632033";
char tiger[13] = "59002949F3CA";
char monkey[13] = "0000000000"; //need card id
char rooster[13] = "0000000000"; //need card id

void setup(){
  Serial.begin(9600);
  pinMode(buttonPin, INPUT);
}

void loop(){

  buttonState = digitalRead(buttonPin);
  char tagString[13];
  int index = 0;
  boolean reading = false;

  while(Serial.available()){

    int readByte = Serial.read(); 
    
    if(readByte == 2) reading = true; 
    if(readByte == 3) reading = false;

    if(reading && readByte != 2 && readByte != 10 && readByte != 13){
      //store the tag
      tagString[index] = readByte;
      index ++;
    }
  }

  if (buttonState == HIGH) {  

    Serial.println('13');

  }

  checkTag(tagString);
  clearTag(tagString);

}

void checkTag(char tag[]){


  if(strlen(tag) == 0) return;

  if(compareTag(tag, ox)){
    Serial.println('1');
    delay(500);

  }
  else if(compareTag(tag, dragon)){
    Serial.println('2');
    delay(500);

  }
  else if(compareTag(tag, horse)){
    Serial.println('3');
    delay(500);

  }
  else if(compareTag(tag, ram)){
    Serial.println('4');
    delay(500);

  }
  else if(compareTag(tag, rabbit)){
    Serial.println('5');
    delay(500);

  }
  else if(compareTag(tag, snake)){
    Serial.println('6');
    delay(500);

  }
  else if(compareTag(tag, boar)){
    Serial.println('7');
    delay(500);

  }
  else if(compareTag(tag, mouse)){
    Serial.println('8');
    delay(500);

  }
  else if(compareTag(tag, dog)){
    Serial.println('9');
    delay(500);

  }
  else if(compareTag(tag, tiger)){
    Serial.println('10');
    delay(500);

  }
  else if(compareTag(tag, monkey)){
    Serial.println('11');
    delay(500);

  }
  else if(compareTag(tag, rooster)){
    Serial.println('12');
    delay(500);

  }
  else{
    Serial.println(tag);
  }

}

void clearTag(char one[]){
  for(int i = 0; i < strlen(one); i++){
    one[i] = 0;
  }
}

boolean compareTag(char one[], char two[]){
  if(strlen(one) == 0) return false;

  for(int i = 0; i < 12; i++){
    if(one[i] != two[i]) return false;
  }

  return true;
}
