/**
 * Copyright (C) 2023 Ajay Manjhi, <ajay963@outlook.com>
 *
 */

/**
 * TRANSMITTER NODE
 * Visual Data Node 
 */

// #include <SPI.h>
// #include <RF24.h>
// #include <RF24Network.h>

/**
-- for the further development of project 
-- one can use 'LORA' -- LOng RAnge module as transreciever
-- this project has the scope for long range communication


-- one the other hand can encrypt message and upload the data
-- to AWS cloud for making it logs online accesssible
-- can add gps module 
**/

#include "weather.h"
#include "gas.h"
#include "VisualSensorData.h"

#include <WiFi.h>
#include <WebSocketsServer.h> 
#include <ArduinoJson.h>

const char *ssid =  "weather_ESP-32";   //Wifi SSID (Name)   
const char *pass =  "weatherESP32"; //wifi password
WebSocketsServer webSocket = WebSocketsServer(81);


// RF24 radio(4, 5);  // nRF24L01(+) radio attached using Getting Started board
// RF24Network network(radio);  // Network uses that radio

const uint16_t masterNode = 00;
const uint16_t visualSensorNode = 02;  

VisualSensorData visualdata;
Weather weatherSensor;
GasSensor gasSensor;

void readSensorData(){
   
   visualdata.temperature = weatherSensor.getData().temperature;
   visualdata.humidity = weatherSensor.getData().humidity;
   visualdata.pressure = weatherSensor.getData().pressure;

   visualdata.mq135 = gasSensor.readGasDataFn().mq135;
   visualdata.mq7 = gasSensor.readGasDataFn().mq7; 
   visualdata.mq2 = gasSensor.readGasDataFn().mq4; 

   Serial.print("temp : ");
   Serial.print(visualdata.temperature);
   Serial.print("\n");
   

   Serial.print("gas : ");
   Serial.print(visualdata.mq135);
   Serial.print("\n");

}



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

          //  jsonDeserialization(cmd);
        
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

   WiFi.mode(WIFI_AP);
   WiFi.softAP(ssid, pass);
   IPAddress apIP(192, 168, 4, 1); 
   Serial.println("created hotspot"); 

   Serial.println("My IP address : ");
   Serial.println(WiFi.softAPIP()); 

  //Static IP for wifi gateway
  //  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0)); //set Static IP gateway on NodeMCU
  //  WiFi.softAP(ssid, pass); //turn on WIFI

   webSocket.begin(); //websocket Begin
   webSocket.onEvent(webSocketEvent); //set Event for websocket
  
   Serial.println("Websocket setup success");

  weatherSensor.setup();
  gasSensor.setup();

}

void loop() {

    readSensorData();
    jsonSerialization();
    webSocket.loop();
   
}


void jsonSerialization(){

        String output;
        StaticJsonDocument<384> doc;

        Serial.print("serializeJson process");


        JsonObject atmos = doc.createNestedObject("atmos");
        
        atmos["temp"] = weatherSensor.getData().temperature;
        atmos["humidity"] = weatherSensor.getData().humidity;
        atmos["pressure"] = weatherSensor.getData().pressure;

        JsonObject gps = doc.createNestedObject("gps");
        gps["lat"] = 0;
        gps["lon"] = 0;

        JsonObject gas = doc.createNestedObject("gas");
        gas["mq4"] = gasSensor.readGasDataFn().mq4;
        gas["mq7"] = gasSensor.readGasDataFn().mq7;
        gas["mq135"] = gasSensor.readGasDataFn().mq135;

        JsonObject reflex = doc.createNestedObject("reflex");
        reflex["yaw"] = 0;
        reflex["pitch"] = 0;
        reflex["roll"] = 0;
        reflex["fClr"] = 0;
        reflex["lClr"] = 0;
        reflex["rClr"] = 0;

        serializeJson(doc, output);
        webSocket.broadcastTXT(output);
}

