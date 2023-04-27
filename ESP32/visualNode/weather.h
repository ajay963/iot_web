#include <Arduino.h>
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BME280.h>


struct WeatherData{
      int8_t temperature;
      uint8_t humidity;
      uint16_t pressure;
};



class Weather{

  Adafruit_BME280 bme; 
  WeatherData data;
  
  public:

   void setup(){
     
        bool status = bme.begin(0x76);  
        if (!status) {
        Serial.println("Could not find a valid BME280 sensor, check wiring!");
        while (1);
  }
} 

   WeatherData getData(){

        data.temperature = bme.readTemperature();
        data.humidity = bme.readHumidity();
        data.pressure = bme.readPressure() / 100.0F;

        return data;
   }

   void readData() {
  
        Serial.print("\n\n --------------");
        Serial.print("\n\ntemperature : ");
        Serial.print(data.temperature);

        Serial.print("\n\nhumidity : ");
        Serial.print(data.humidity);

        Serial.print("\n\npressure : ");
        Serial.print(data.pressure);
        Serial.print("--------------\n\n");

}
};