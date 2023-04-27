/**
 * Copyright (C) 2023 Ajay Manjhi, <ajay963@outlook.com>
 */

/**
 *
 * MASTER NODE
 * Listens for messages from the transmitter and websockets
 */

#include <WiFi.h>
#include <WebSocketsServer.h> 
#include <ArduinoJson.h>
#include <SPI.h>
#include <RF24.h>
#include <RF24Network.h>

const char *ssid =  "ESP-32 Flutter";   //Wifi SSID (Name)   
const char *pass =  "strMG&&TP"; //wifi password
WebSocketsServer webSocket = WebSocketsServer(81);


RF24 radio(4, 5);  // nRF24L01(+) radio attached using Getting Started board

RF24Network network(radio);      // Network uses that radio
const uint16_t masterNode = 00;
const uint16_t reflexNode = 01;  
const uint16_t visualSensorNode = 02;  



struct VisualSensorData{
  
  // gas sensors data
  uint16_t mq2;
  uint16_t mq7;
  uint16_t mq135;

  // co-ordinates
  double latitude;
  double longitude;

  // weather data
  uint8_t temperature;
  uint8_t humidity;
  uint16_t pressure;
};

struct ReflexNodeData{
   uint8_t fd;
   uint8_t rd;
   uint8_t ld;

   int16_t yaw;
   int16_t roll;
   int16_t pitch;
};



struct ControlData{
  
  // co-oridinates
  byte x;
  byte y;

  // color value
  uint8_t red;
  uint8_t blue;
  uint8_t green;

  // led state
  bool led;

};


struct payload_t {  // Structure of our payload
  unsigned long ms;
  unsigned long counter;
};



// global object instance 
VisualSensorData visualData;
ReflexData reflexData;
ControlData controlData;


// function instance
void radioNetwork();
void jsonSerialization();
void jsonDeserialization();



void webSocketEvent(uint8_t num, WStype_t type, uint8_t * payload, size_t length) {
//webscket event method
    String cmd = "";
    switch(type) {
        case WStype_DISCONNECTED:{
            Serial.println("Websocket is disconnected");
            //case when Websocket is disconnected
            }
            break;
        case WStype_CONNECTED:{
            //wcase when websocket is connected
            Serial.println("Websocket is connected");
            Serial.println(webSocket.remoteIP(num).toString());
            webSocket.sendTXT(num, "connected");}
            break;
        case WStype_TEXT: {
            cmd = "";
            for(int i = 0; i < length; i++) {
                cmd = cmd + (char) payload[i]; 
        
            } 

           jsonDeserialization(cmd);
        
        }
            break;

        default:   
            break;
    }
}

void setup(void) {
  Serial.begin(115200);
  while (!Serial) {
    // some boards need this because of native USB capability
  }
  
   Serial.println(F("websocket single core test"));
   WiFi.mode(WIFI_AP);
   WiFi.softAP(ssid, pass);
   IPAddress apIP(192, 168, 0, 1); 
   Serial.println("created hotspot");  
  //Static IP for wifi gateway
  //  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0)); //set Static IP gateway on NodeMCU
  //  WiFi.softAP(ssid, pass); //turn on WIFI

   webSocket.begin(); //websocket Begin
   webSocket.onEvent(webSocketEvent); //set Event for websocket
   Serial.println("Websocket setup success");
 
  Serial.println(F("RF24Network weather data test"));

  if (!radio.begin()) {
    Serial.println(F("Radio hardware not responding!"));
    while (1) {
      // hold in infinite loop
    }
  }
  radio.setChannel(90);
  network.begin(masterNode);
}

void loop(void) {
  radioNetwork();
  webSocket.loop(); 
}



void radioNetwork(){
    
  network.update();  // Check the network regularly

  while (network.available()) {  // Is there anything ready for us?

    RF24NetworkHeader header;  // If so, grab it and print it out
    network.peek(header);

    switch (header.from_node) {
      
      // data from quick reflex node (node address = 01)
      case 01: {
        
          network.read(header, &reflexData, sizeof(reflexData));
          Serial.print(F("Reflex data angle : "));
          Serial.print(reflexData.yaw_axis);
          Serial.print(F("\n\nfront distance"));
          Serial.println(reflexData.frontD);
          jsonSerialization();
      }
      break;
        
        // data from Visual sensor node (node address = 02)
        case 02: {
        
          network.read(header, &visualData, sizeof(visualData));
          Serial.print(F("temperature : "));
          Serial.print(visualData.temperature);
          Serial.print("\n\nhumidity : ");
          Serial.println(visualData.humidity);
          jsonSerialization();
      }
      break;
    default:
    Serial.print("invalid header data");
    break;
    }
   
  }
}


void jsonDeserialization(String cmd){
   StaticJsonDocument<128> doc;
 
   DeserializationError error = deserializeJson(doc, cmd);

   if (error) {
        Serial.print("deserializeJson() failed: ");
        Serial.println(error.c_str());
        return;
    }

        controlData.x = doc["x"]; 
        controlData.y = doc["y"]; 
        controlData.red = doc["r"]; 
        controlData.green = doc["g"]; 
        controlData.blue = doc["b"]; 
        controlData.led = doc["led"]; 

        Serial.print(F("x : "));
        Serial.print(controlData.x);
        Serial.print("\ny : ");
        Serial.println(controlData.y);
}


void jsonSerialization(){

        String output;
        StaticJsonDocument<384> doc;

        JsonObject atmos = doc.createNestedObject("atmos");
        atmos["temp"] = visualData.temperature;
        atmos["humidity"] = visualData.humidity;
        atmos["pressure"] = visualData.pressure;

        JsonObject gps = doc.createNestedObject("gps");
        gps["lat"] = visualData.latitude;
        gps["lon"] = visualData.longitude;

        JsonObject gas = doc.createNestedObject("gas");
        gas["mq4"] = visualData.mq2;
        gas["mq7"] = visualData.mq7;
        gas["mq135"] = visualData.mq135;

        JsonObject reflex = doc.createNestedObject("reflex");
        reflex["yaw"] = reflexData.yaw_axis;
        reflex["pitch"] = 0;
        reflex["roll"] = 0;
        reflex["fClr"] = reflexData.frontD;
        reflex["lClr"] = reflexData.leftD;
        reflex["rClr"] = reflexData.rightD;

        serializeJson(doc, output);
}
     