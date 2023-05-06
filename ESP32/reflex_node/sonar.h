#include <Arduino.h>

//define sound speed in cm/uS
#define SOUND_SPEED 0.034
#define CM_TO_INCH 0.393701

struct UltrasonicData{
  int fd;
  int ld;
  int rd;
};

UltrasonicData sonar;

class UltrasonicSensor{
    

    // left side
    const int trigPin1 = 27;
    const int echoPin1 = 34;


    // right side
    const int trigPin2 = 32;
    const int echoPin2 = 35;

    unsigned long duration;

    int SonarSensor(int trigPin,int echoPin) {

      digitalWrite(trigPin, LOW);
      delayMicroseconds(2); 
      digitalWrite(trigPin, HIGH);
      delayMicroseconds(10);
      digitalWrite(trigPin, LOW);
      duration = pulseIn(echoPin, HIGH);
      int distance = (duration/2) / 29.1;
      return distance;
    }
  
  public:
   
   void setup(){
    pinMode(trigPin1, OUTPUT); 
    pinMode(echoPin1, INPUT); 

    pinMode(trigPin2, OUTPUT); 
    pinMode(echoPin2, INPUT); 
    

   }

   UltrasonicData getData(){
     sonar.rd = SonarSensor(trigPin1, echoPin1);
     sonar.ld = SonarSensor(trigPin2, echoPin2);
      
     return sonar;
   }

   void prinData(){
    
    Serial.print("\n");
    Serial.print("front sensor : ");
    Serial.print(sonar.fd);
    Serial.print("\n");

    Serial.print("right sensor : ");
    Serial.print(sonar.rd);
    Serial.print("\n");

    Serial.print("left sensor : ");
    Serial.print(sonar.ld);
    Serial.print("\n");
   }

};
