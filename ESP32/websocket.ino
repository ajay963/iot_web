/*
objective for this project is to connect as many platforms
using flutter 

flutter provides cross platform apps

this can be done with other platforms (windows, linux, macos, andriod, ios and etc)
with using wi-fi and websocket

ESP32 have both wi-fi and BLE (Bluetooth low energy)

websocket 
HTTP is not reliable for realtime data transfer
where as websockets needs single connection establishment after that
it uses UDP datagram packets which is much much faster for live stream of data

*/

#include <Arduino.h>
// esp32 dose not facilities of analogWrite() 
// including external lib
#include <analogWrite.h> 
#include <WiFi.h>
#include <ArduinoJson.h>
#include <WebSocketsServer.h> //import for websocket

#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BME280.h>
// #include <SoftwareSerial.h>
// #include <TinyGPS++.h> // for gps 

// multithreading task defination
TaskHandle_t Task1;
TaskHandle_t Task2;
// motors for LN298 motor driver 
// motor A
// #define in1  27 // ESP32 pin GIOP27 connected to the IN1 pin L298N
// #define in2  26 // ESP32 pin GIOP26 connected to the IN2 pin L298N
// #define enA  14 // ESP32 pin GIOP14 connected to the EN1 pin L298N
// // motor B
// #define in3  18 // ESP32 pin GIOP18 connected to the IN1 pin L298N
// #define in4  19 // ESP32 pin GIOP19 connected to the IN2 pin L298N
// #define enB  15 // ESP32 pin GIOP14 connected to the EN1 pin L298N

#define SEALEVELPRESSURE_HPA (1013.25)

Adafruit_BME280 bme; // I2C

#define dhttype DHT11 //defining DHT Type

// RGB pins ans settings
#define ledpin1 16 
#define ledpin2 17
#define ledpin3 5



const int freq = 5000;
const int resolution = 8;
int ctr=0;
// 2^pow(8) = 256 
// gives control over 0-255 
// can set resolution to upto 16
// i.e. 2^pow(16) = 65,536 values

class RGBled{
  public:
  int red;
  int blue;
  int green;

  RGBled(){
    red = 0;
    blue = 0;
    green = 0;
  }
};

class GPS{
  public:
  double latitude;
  double longitude;
  int satellites;

  GPS(){
    latitude = 0;
    longitude = 0;
    satellites = 0;
  }
};

class AtmosData{
  public:
  int temperature;
  int humidity;
  int pressure;
  int altitude;

  AtmosData(){
    temperature=0;
    humidity=0;
    pressure=0;
    altitude=0;
  }
};

class LedBlink{
  void onJsonError(){}
  void onWebsocketDisconnects(){}
  void onWebsocketConnected(){}
  void onDataIncoming(){}
};


 AtmosData atmosData;
 int red = 0; 
 int blue = 0; 
 int green = 0; 


const char *ssid =  "ESP-32 Flutter";   //Wifi SSID (Name)   
const char *pass =  "strMG&&TP"; //wifi password
bool isSet=false;
String json; //variable for json 

int temp=0;
int hum=0;

// TinyGPSPlus gps; // gps object intilization
// DHT dht(39, dhttype); //initialize DHT sensor, D5-no.4 is the pin where we connect data pin from sensor

WebSocketsServer webSocket = WebSocketsServer(81); //websocket init with port 81

void rgbLed(int r,int g,int b){

  Serial.printf("red:",r," || blue:",b,"  || green:",g,"\n");

  analogWrite(ledpin1, r);
  analogWrite(ledpin2, g);
  analogWrite(ledpin3, b);
}

// void gpsInfo(){
// if (gps.location.isValid()) {
// double latitude = (gps.location.lat());
// double longitude = (gps.location.lng());
// }}

void getAtmosdata(){
  atmosData.temperature = bme.readTemperature();
  atmosData.humidity = bme.readHumidity();
  atmosData.pressure = bme.readPressure();
  atmosData.altitude = bme.readAltitude(SEALEVELPRESSURE_HPA);
  
  Serial.print("Temperature = ");
  Serial.print(atmosData.temperature);
  Serial.println(" *C");

  Serial.print("Pressure = ");
  Serial.print(atmosData.pressure / 100.0F);
  Serial.println(" hPa");

  Serial.print("Approx. Altitude = ");
  Serial.print(atmosData.altitude);
  Serial.println(" m");

  Serial.print("Humidity = ");
  Serial.print(atmosData.humidity);
  Serial.println(" %");
}

void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {
//webscket event method
    String cmd = "";
    switch(type) {
        case WStype_DISCONNECTED:
            Serial.println("Websocket is disconnected");
            //case when Websocket is disconnected
            break;
        case WStype_CONNECTED:{
            //wcase when websocket is connected
            Serial.println("Websocket is connected");
            Serial.println(webSocket.remoteIP(num).toString());
            webSocket.sendTXT(num, "connected");}
            break;
        case WStype_TEXT: {
            cmd = "";
            for(int i = 0; i < length; i++) 
                cmd = cmd + (char) payload[i]; 
             //merging payload to single string
            Serial.println(cmd);

          StaticJsonDocument<96> doc;

          DeserializationError error = deserializeJson(doc, cmd);

          if (error) {
           Serial.print("deserializeJson() failed: ");
           Serial.println(error.c_str());
           return;
          }

          red = doc["red"]; 
          blue = doc["blue"]; 
          green = doc["green"]; 


          rgbLed(red,blue,green);
          webSocket.sendTXT(num,"success");
            //  send response to mobile, if command is "poweron" then response will be "poweron:success"
            //  this response can be used to track down the success of command in mobile app.
        }
            break;
        case WStype_FRAGMENT_TEXT_START:
            break;
        case WStype_FRAGMENT_BIN_START:
            break;
        case WStype_BIN:
            break;
        default:
            break;
    }
}

// motor control
// void joystickControl(int xAxis,int yAxis){
//   int motorSpeedA = 0;
//   int motorSpeedB = 0;

//     if (yAxis < 0) {
//     digitalWrite(in1, HIGH);
//     digitalWrite(in2, LOW);
//     digitalWrite(in3, HIGH);
//     digitalWrite(in4, LOW);
//     motorSpeedA = map(yAxis, -100, 0, 0, 255);
//     motorSpeedB = map(yAxis, -100, 0, 0, 255);
//   }
  
//   else if (yAxis > 0) {
//     digitalWrite(in1, LOW);
//     digitalWrite(in2, HIGH);
//     digitalWrite(in3, LOW);
//     digitalWrite(in4, HIGH);
//     motorSpeedA = map(yAxis, 0, 100, 0, 255);
//     motorSpeedB = map(yAxis, 0, 100, 0, 255);
//   }
  
//   else {
//     motorSpeedA = 0;
//     motorSpeedB = 0;
//   }

//   if (xAxis < 0) {
//     int xMapped = map(xAxis, -100, 0, 0, 255);
//     motorSpeedA = motorSpeedA - xMapped;
//     motorSpeedB = motorSpeedB + xMapped;
    
//     if (motorSpeedA < 0)   motorSpeedA = 0;
//     if (motorSpeedB > 255) motorSpeedB = 255;
//  }
//     if (xAxis > 0) {
//     int xMapped = map(xAxis, 0, 100, 0, 255);
//     motorSpeedA = motorSpeedA + xMapped;
//     motorSpeedB = motorSpeedB - xMapped;

//     if (motorSpeedA > 255) motorSpeedA = 255;
//     if (motorSpeedB < 0)   motorSpeedB = 0;
//   }
 
//   if (motorSpeedA < 70)  motorSpeedA = 0;
//   if (motorSpeedB < 70)  motorSpeedB = 0;
//   analogWrite(enA, motorSpeedA);
//   analogWrite(enB, motorSpeedB);
// }




void setup() {
 
  Serial.begin(115200); //serial start

  // motor driver setup
  // pinMode(enA, OUTPUT);
  // pinMode(enB, OUTPUT);
  // pinMode(in1, OUTPUT);
  // pinMode(in2, OUTPUT);
  // pinMode(in3, OUTPUT);
  // pinMode(in4, OUTPUT);
  
  // BME sensor setup
  bool status = bme.begin(0x76);                                                                                
  if (!status) {
    Serial.println("Could not detect a BME280 sensor, Fix wiring Connections!");
    while (1);  // putting infinte delay, if sensor dose'nt work no sense to move forward 
  }
  // RGB led setup()
  Serial.println("led set up");
   analogWriteResolution(ledpin1, resolution);
   analogWriteResolution(ledpin2, resolution);
   analogWriteResolution(ledpin3, resolution);
   
  Serial.println("led set-up completed");

   
   WiFi.mode(WIFI_AP);
   WiFi.softAP(ssid, pass);
   IPAddress apIP(192, 168, 0, 1); 
   Serial.println("created hotspot");  //Static IP for wifi gateway
  //  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0)); //set Static IP gateway on NodeMCU
  //  WiFi.softAP(ssid, pass); //turn on WIFI

   webSocket.begin(); //websocket Begin
   webSocket.onEvent(webSocketEvent); //set Event for websocket
   Serial.println("Websocket is started");

   // multithreading
   xTaskCreatePinnedToCore(networking_Task, "networking task", 10000, NULL, 1, &Task1,  0); 
   xTaskCreatePinnedToCore(sensorData_Task, "sensor data reading task", 10000, NULL, 1, &Task2,  1); 
}

// by default void loop running on core 1
void loop() {}


// multithreading 
// esp32 has dual cores - 0 , 1

void networking_Task( void * parameters ){
     while(true){
      webSocket.loop(); 
      

      // in testing phase with BME-280

      // StaticJsonDocument<64> doc;
      // doc["temp"] = atmosData.temperature;
      // doc["humidity"] = atmosData.humidity;
      // doc["pressure"] = atmosData.pressure;
      // doc["altitude"] = atmosData.altitude;
      // serializeJson(doc, output);

      StaticJsonDocument<200> data;
      data["temp"] = atmosData.temperature;
      data["humidity"] = atmosData.humidity;

     
        // Serial.println(data);
      String doc;
      serializeJson(data, doc);
      delay(100);
      webSocket.broadcastTXT(doc); //send JSON to mobile
      
      Serial.print("\nNetwork Task running on core :");
      Serial.println(xPortGetCoreID());
    } 
}

void sensorData_Task( void * parameters ){
     
     while(true){
      ctr=ctr+1;
      
      getAtmosdata();
       Serial.print("\nSensor Task running on core ");
       Serial.println(xPortGetCoreID());
    } 
}


