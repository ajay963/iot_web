#include "esp32-hal-gpio.h"
#include "esp32-hal-ledc.h"
#include <Arduino.h>

class MotorDriver{
   
   int motorSpeedA = 0;
   int motorSpeedB = 0;

   const int frequency = 500;
   const int pwm_channel1 = 0;
   const int pwm_channel2 = 1;
   const int resolution = 8;
   
   const int8_t m1 = 23;
   const int8_t m2 = 19;
   const int8_t enA = 18;  // pwm signal pins
   const int8_t m3 = 4;
   const int8_t m4 = 17;
   const int8_t enB = 5;  // pwm signal pins

   public:
    
    void setup(){
      
      // motor 1
      pinMode(m1, OUTPUT);
      pinMode(m2, OUTPUT);
      pinMode(enA, OUTPUT);
      
      // motor 2
      pinMode(m3, OUTPUT);
      pinMode(m4, OUTPUT);
      pinMode(enB, OUTPUT);

      ledcSetup(pwm_channel1, frequency, resolution);
      ledcSetup(pwm_channel2, frequency, resolution);
      ledcAttachPin(enA, pwm_channel1);
      ledcAttachPin(enB, pwm_channel2);

  }
    
// motor control
    void joystickControl(int xAxis,int yAxis){


        if (yAxis < 0) {
        digitalWrite(m1, HIGH);
        digitalWrite(m2, LOW);
        digitalWrite(m3, HIGH);
        digitalWrite(m4, LOW);
        motorSpeedA = map(yAxis, -100, 0, 0, 255);
        motorSpeedB = map(yAxis, -100, 0, 0, 255);
      }
      
      else if (yAxis > 0) {
        digitalWrite(m1, LOW);
        digitalWrite(m2, HIGH);
        digitalWrite(m3, LOW);
        digitalWrite(m4, HIGH);
        motorSpeedA = map(yAxis, 0, 100, 0, 255);
        motorSpeedB = map(yAxis, 0, 100, 0, 255);
      }
      
      else {
        motorSpeedA = 0;
        motorSpeedB = 0;
      }

      if (xAxis < 0) {
        digitalWrite(m1, HIGH);
        digitalWrite(m2, LOW);
        digitalWrite(m3, LOW);
        digitalWrite(m4, HIGH);
        
        int xMapped = map(xAxis, -100, 0, 0, 255);
        motorSpeedA = motorSpeedA - xMapped;
        motorSpeedB = motorSpeedB + xMapped;
        
        if (motorSpeedA < 0)   motorSpeedA = 0;
        if (motorSpeedB > 255) motorSpeedB = 255;
    }
        if (xAxis > 0) {

        digitalWrite(m1, LOW);
        digitalWrite(m2, HIGH);
        digitalWrite(m3, HIGH);
        digitalWrite(m4, LOW);
        
        int xMapped = map(xAxis, 0, 100, 0, 255);
        motorSpeedA = motorSpeedA + xMapped;
        motorSpeedB = motorSpeedB - xMapped;

        if (motorSpeedA > 255) motorSpeedA = 255;
        if (motorSpeedB < 0)   motorSpeedB = 0;
      }
    
      if (motorSpeedA < 70)  motorSpeedA = 0;
      if (motorSpeedB < 70)  motorSpeedB = 0;
      // ledcAttachPin(enA, motorSpeedA);
      // ledcAttachPin(enB, motorSpeedB);

      ledcWrite(pwm_channel1, motorSpeedA);
      ledcWrite(pwm_channel2, motorSpeedB);


}
    
};