// defines pins numbers

const int triggerPin = 4;   // the number of the trigger pin

const int stepPin = 5; 

const int dirPin = 2; 

const int enPin = 8;

int catch1 = 0;

int catch2 = 0;

int catch3 = 0;

int catch4 = 0;

int totalsignal = 0;

int triggerState = 0;     // variable for reading the TTL status

void setup() {

  

  // Sets the two pins as Outputs

  pinMode(stepPin,OUTPUT); 

  pinMode(dirPin,OUTPUT);

  pinMode(enPin,OUTPUT);

  digitalWrite(enPin,LOW);

  

}

void loop() {

  triggerState = digitalRead(triggerPin);

  if (triggerState == HIGH) { 

  delay(200);

  catch1 = digitalRead(triggerPin);

  delay(200);

  catch2 = digitalRead(triggerPin);

  delay(200);

  catch3 = digitalRead(triggerPin);

  delay(200);

  catch4 = digitalRead(triggerPin);

  totalsignal = catch1 + catch2 + catch3 + catch4;

  if (totalsignal > 0) {
  
  digitalWrite(dirPin,LOW); // Enables the motor to move in a particular direction

  // Makes 200 pulses for making one full cycle rotation

  for(int x = 0; x < 600; x++) {

    digitalWrite(stepPin,HIGH); 

    delayMicroseconds(500); 

    digitalWrite(stepPin,LOW); 

    delayMicroseconds(500); 

  }
delay(1000);

  while (1+1 == 2) {
    triggerState = digitalRead(triggerPin);
    if (triggerState == LOW) {
      break;
    }
  }
//  digitalWrite(dirPin,HIGH); // Enables the motor to move in a particular direction
//
//  // Makes 200 pulses for making one full cycle rotation
//
//  for(int x = 0; x < 600; x++) {
//
//    digitalWrite(stepPin,HIGH); 
//
//    delayMicroseconds(500); 
//
//    digitalWrite(stepPin,LOW); 
//
//    delayMicroseconds(500); 
//  }
//  // End of right loop
//  }

  digitalWrite(dirPin,HIGH); //Changes the rotations direction

  // Makes 400 pulses for making two full cycle rotation

  for(int x = 0; x < 6; x++) {
    for(int x = 0; x < 100; x++) {
      digitalWrite(stepPin,HIGH);

      delayMicroseconds(500);

      digitalWrite(stepPin,LOW);

      delayMicroseconds(500);

  }
    delay(600);
  }

  delay(3000);

  }


  else {
    digitalWrite(dirPin,HIGH); // Enables the motor to move in a particular direction

  // Makes 200 pulses for making one full cycle rotation

  for(int x = 0; x < 600; x++) {

    digitalWrite(stepPin,HIGH); 

    delayMicroseconds(500); 

    digitalWrite(stepPin,LOW); 

    delayMicroseconds(500);
  }
delay(1000);

  while (1+1 == 2) {
    triggerState = digitalRead(triggerPin);
    if (triggerState == LOW) {
      break;
    }
  }
//  digitalWrite(dirPin,LOW); // Enables the motor to move in a particular direction
  digitalWrite(dirPin,LOW); //Changes the rotations direction

  // Makes 400 pulses for making two full cycle rotation

  for(int x = 0; x < 6; x++) {
    for(int x = 0; x < 100; x++) {
      digitalWrite(stepPin,HIGH);

      delayMicroseconds(500);

      digitalWrite(stepPin,LOW);

      delayMicroseconds(500);

  }
    delay(600);
  }

  delay(3000);

  }

  

//  // Makes 200 pulses for making one full cycle rotation
//
//  for(int x = 0; x < 600; x++) {
//
//    digitalWrite(stepPin,HIGH); 
//
//    delayMicroseconds(500); 
//
//    digitalWrite(stepPin,LOW); 
//
//    delayMicroseconds(500); 
//  }
//  // End of left loop
//  }
}
}
