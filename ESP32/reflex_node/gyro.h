#include "HardwareSerial.h"
// #include <sys/_stdint.h>
#include "Wire.h"
#include <Arduino.h>
#include <MPU6050_light.h>

struct GyroData{
  
  int16_t yaw;
  int16_t roll;
  int16_t pitch;
};


GyroData gyroData;
MPU6050 mpu(Wire);


class GyroSensor{

  public:

   void setup(){

      Wire.begin();
      
      bool status = mpu.begin();
      Serial.print(F("MPU6050 status: "));


      (status!=0)? Serial.println("not working"):Serial.println("working");
      while(status!=0){ } // stop everything if could not connect to MPU6050
      
      Serial.println(F("Calculating offsets, do not move MPU6050"));
      delay(1000);
      // mpu.upsideDownMounting = true; // uncomment this line if the MPU6050 is mounted upside-down
      mpu.calcOffsets(); // gyro and accelero
      Serial.println("Done!\n");


   }


   GyroData getData(){
 
        mpu.update();

        gyroData.pitch = mpu.getAngleX();
        gyroData.roll = mpu.getAngleY();
        gyroData.yaw = mpu.getAngleZ();
  
    return gyroData;
 }


    void displayData(){
        
        Serial.print("X : ");
        Serial.print(gyroData.pitch);
        Serial.print("\tY : ");
        Serial.print(gyroData.roll);
        Serial.print("\tZ : ");
        Serial.println(gyroData.yaw);
    }
   

};