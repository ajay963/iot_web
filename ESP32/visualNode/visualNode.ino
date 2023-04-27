/**
 * Copyright (C) 2023 Ajay Manjhi, <ajay963@outlook.com>
 *
 */

/**
 * TRANSMITTER NODE
 * Visual Data Node 
 */

#include <SPI.h>
#include <RF24.h>
#include <RF24Network.h>
#include "weather.h"
#include "VisualSensorData.h"





RF24 radio(4, 5);  // nRF24L01(+) radio attached using Getting Started board
RF24Network network(radio);  // Network uses that radio

const uint16_t masterNode = 00;
const uint16_t visualSensorNode = 02;  

const unsigned long interval = 200;  // How often (in ms) to send packets to the other unit

unsigned long last_sent;     // When did we last send?
unsigned long packets_sent;  // How many have we sent already




VisualSensorData visualdata;
Weather weatherSensor;

void readSensorData(){
   
   visualdata.temperature = weatherSensor.getData().temperature;
   visualdata.humidity = weatherSensor.getData().humidity;
   visualdata.pressure = weatherSensor.getData().pressure;

}

void setup(void) {
  Serial.begin(115200);
  while (!Serial) {
    // some boards need this because of native USB capability
  }

  weatherSensor.setup();

  Serial.println(F("RF24Network weather data test"));

  if (!radio.begin()) {
    Serial.println(F("Radio hardware not responding!"));
    while (1) {
      // hold in infinite loop
    }
  }
  radio.setChannel(90);
  network.begin(visualSensorNode);
}

void loop() {


  readSensorData();

  network.update();  // Check the network regularly

  unsigned long now = millis();
  
  if (now-last_sent >interval) {
    last_sent = now;

    Serial.print(F("Sending... "));
    // payload_t payload = { millis(), packets_sent++ };
    RF24NetworkHeader header(masterNode);
    bool ok = network.write(header, &visualdata, sizeof(visualdata));
    Serial.println("failed to send");
  }
}


