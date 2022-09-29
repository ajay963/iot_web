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
#include <DHT.h> //library for DHT Sensor
#include <SoftwareSerial.h>
#include <TinyGPS++.h> // for gps 



#define dhttype DHT11 //defining DHT Type

// RGB pins ans settings
#define ledpin1 16 
#define ledpin2 17
#define ledpin3 5

const int freq = 5000;
const int resolution = 8;
// 2^pow(8) = 256 
// gives control over 0-255 
// can set resolution to upto 16
// i.e. 2^pow(16) = 65,536 values

class RGBled{
  public:
  int red;
  int blue;
  int green;
};

class GPS{
  public:
  double lat;
  double log;
};

class AtmosData{
  public:
  int temp;
  int hum;
};

class LedBlink{
  void onJsonError(){}
  void onWebsocketDisconnects(){}
  void onWebsocketConnected(){}
  void onDataIncoming(){}
};

 int red = 0; 
 int blue = 0; 
 int green = 0; 


const char *ssid =  "ESP-32 Flutter";   //Wifi SSID (Name)   
const char *pass =  "strMG&&TP"; //wifi password
bool isSet=false;
String json; //variable for json 

int temp=0;
int hum=0;

TinyGPSPlus gps; // gps object intilization
DHT dht(4, dhttype); //initialize DHT sensor, D5 is the pin where we connect data pin from sensor

WebSocketsServer webSocket = WebSocketsServer(81); //websocket init with port 81

void rgbLed(int r,int g,int b){

  Serial.printf("red:",r," || blue:",b,"  || green:",g,"\n");

  analogWrite(ledpin1, r);
  analogWrite(ledpin2, g);
  analogWrite(ledpin3, b);
}

void gpsInfo(){
if (gps.location.isValid()) {
double latitude = (gps.location.lat());
double longitude = (gps.location.lng());
}}

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

// multithreading 
// esp32 has dual cores - 0 , 1

void networking_Task( void * parameters ){
     while(true){
      webSocket.loop(); 

      StaticJsonDocument<200> data;
      data["temp"] = temp;
      data["humidity"] = hum;

     
        // Serial.println(data);
        //formulate JSON string format from characters (Converted to string using chr2str())
      String doc;
      serializeJson(data, doc);
      delay(100);
      webSocket.broadcastTXT(doc); //send JSON to mobile
    } 
}

void sensorData_Task( void * parameters ){
     while(true){
     if(!isSet){
     delay(2000); //delay by 2 second, DHT sesor senses data slowly with delay around 2 seconds
     isSet=true;
     }
    
     hum =(int) dht.readHumidity(); //Humidity float value from DHT sensor
     temp =(int) dht.readTemperature(); //Temperature float value from DHT sensor

     if (isnan(hum) || isnan(temp)) {
        //if data from DHT sensor is null
        Serial.println(F("Failed to read from DHT sensor!"));
        return;
     }
    } 
}


void setup() {
 
  Serial.begin(115200); //serial start
    
  // RGB led setup()
  Serial.println("led set up");
   analogWriteResolution(ledpin1, resolution);
   analogWriteResolution(ledpin2, resolution);
   analogWriteResolution(ledpin3, resolution);
   
  Serial.println("led set-up completed");

   Serial.println("Connecting to wifi");
   WiFi.mode(WIFI_AP);
   WiFi.softAP(ssid, pass);
   IPAddress apIP(192, 168, 0, 1);   //Static IP for wifi gateway
  //  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0)); //set Static IP gateway on NodeMCU
  //  WiFi.softAP(ssid, pass); //turn on WIFI

   webSocket.begin(); //websocket Begin
   webSocket.onEvent(webSocketEvent); //set Event for websocket
   Serial.println("Websocket is started");

   // multithreading
   xTaskCreatePinnedToCore(networking_Task, "networking task", 10000, NULL, 1, NULL,  1); 
   xTaskCreatePinnedToCore(sensorData_Task, "sensor data reading task", 10000, NULL, 1, NULL,  0); 
}

// by default void loop running on core 1
void loop() {}


