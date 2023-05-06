#include <Arduino.h>


struct GasData{
    uint16_t mq135;
    uint16_t mq7;
    uint16_t mq4;

};

class GasSensor{

  const uint8_t mq135_Pin = 32;
  const uint8_t mq7_Pin = 34;
  const uint8_t mq4_Pin = 35;
  GasData data;

  public:
  
    void setup(){
        pinMode(mq135_Pin, INPUT);
        pinMode(mq7_Pin, INPUT);
        pinMode(mq4_Pin, INPUT);
    }

   GasData readGasDataFn(){

      data.mq135 = analogRead(mq135_Pin)/10;
      data.mq7 = analogRead(mq7_Pin);
      data.mq4 = analogRead(mq4_Pin);

      return data;
    }


   
};


