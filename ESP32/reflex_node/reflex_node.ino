/**
 * Copyright (C) 2023 Ajay Manjhi, <ajay963@outlook.com>
 */

/**
 *
 * REFLEX NODE
 * Listens for messages from the transmitter and websockets
 */

// #include <RF24.h>
// #include <RF24Network.h>

#include <WiFi.h>
#include <WebSocketsServer.h> 
#include <ArduinoJson.h>

#include "sonar.h"
#include "gyro.h"
#include "motorDriver.h"
#include "ReflexNodeData.h"
#include "controlData.h"

// 16 -- RX2 for led light

// RF24 radio(4, 5);  // nRF24L01(+) radio attached using Getting Started board

GyroSensor gyro;
ControlData controlData;
UltrasonicSensor sonarSensor;
ReflexNodeData reflexNodeData;
MotorDriver motorDriver;


void jsonDeserialization();
void jsonSerialization();

const char *ssid =  "ESP-32 reflex";   //Wifi SSID (Name)   
const char *pass =  "reflexESP32"; //wifi password
WebSocketsServer webSocket = WebSocketsServer(81);

// RF24Network network(radio);      // Network uses that radio
const uint16_t masterNode = 00;
const uint16_t reflexNode = 01;  
const uint16_t visualSensorNode = 02;  

void getSensorData(){
  
  reflexNodeData.fd = sonarSensor.getData().fd;
  reflexNodeData.rd = sonarSensor.getData().rd;
  reflexNodeData.ld = sonarSensor.getData().ld;

  reflexNodeData.pitch = gyro.getData().pitch;
  reflexNodeData.roll = gyro.getData().roll;
  reflexNodeData.yaw = gyro.getData().yaw;
  
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
           jsonDeserialization(cmd);
        }
            break;

        default:   
            break;
    }
}

void setup() {

    Serial.begin(115200);

    gyro.setup();
    sonarSensor.setup();
    motorDriver.setup();
    
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



}


unsigned long previousMillis = 0;  
const long interval = 400;  

void loop() {

  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) {
      previousMillis = currentMillis;
      getSensorData();
      // sonarSensor.prinData();
      // gyro.displayData();
      jsonSerialization();
   }
  webSocket.loop();
}



void jsonDeserialization(String cmd){
   StaticJsonDocument<128> doc;
   Serial.print("\ndeserializeJson process");
   
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

        Serial.println("\n\n");
        Serial.println("--------------- control data ---------------");
        Serial.println("\nx-data : ");
        Serial.println(controlData.x);
        Serial.println("\ny-data : ");
        Serial.println(controlData.y);
        Serial.println("\n\n");

        motorDriver.joystickControl(controlData.x, controlData.y);

}


void jsonSerialization(){

        String output;
        StaticJsonDocument<384> doc;

        Serial.print("serializeJson process");


        JsonObject atmos = doc.createNestedObject("atmos");
        // atmos["temp"] = ;
        atmos["temp"] = 0;
        atmos["humidity"] = 0;
        atmos["pressure"] = 0;

        JsonObject gps = doc.createNestedObject("gps");
        gps["lat"] = 0;
        gps["lon"] = 0;

        JsonObject gas = doc.createNestedObject("gas");
        gas["mq4"] = 0;
        gas["mq7"] = 0;
        gas["mq135"] = 0;

        JsonObject reflex = doc.createNestedObject("reflex");
        reflex["yaw"] = gyroData.yaw;
        reflex["pitch"] = gyroData.pitch;
        reflex["roll"] = gyroData.roll;
        reflex["fClr"] = sonarSensor.getData().fd;
        reflex["lClr"] = sonarSensor.getData().ld;
        reflex["rClr"] = sonarSensor.getData().rd;

        serializeJson(doc, output);
        webSocket.broadcastTXT(output);

}