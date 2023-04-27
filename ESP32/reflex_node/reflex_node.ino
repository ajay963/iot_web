#include <RF24.h>
#include <RF24Network.h>

#include "sonar.h"
#include "gyro.h"
#include "motorDriver.h"
#include "ReflexNodeData.h"

const unsigned long interval = 200;

RF24 radio(4, 5);  // nRF24L01(+) radio attached using Getting Started board

GyroSensor gyro;
UltrasonicSensor sonarSensor;
ReflexNodeData reflexNodeData;

RF24Network network(radio);      // Network uses that radio
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


void setup() {
  // put your setup code here, to run once:

    Serial.println(F("RF24Network weather data test"));

    if (!radio.begin()) {
      Serial.println(F("Radio hardware not responding!"));
      while (1) {
        // hold in infinite loop
      }
    }
    radio.setChannel(90);
    network.begin(reflexNode);


    gyro.setup();
    sonarSensor.setup();

}



void loop() {
  network.update();  // Check the network regularly
  unsigned long last_sent; 
  const unsigned long interval = 50; 
  unsigned long now = millis();

  getSensorData();
  
  if (now-last_sent >interval) {
    last_sent = now;

    Serial.print(F("Sending... "));
    // payload_t payload = { millis(), packets_sent++ };
    RF24NetworkHeader header(masterNode);
    bool ok = network.write(header, &reflexNodeData, sizeof(reflexNode));
    Serial.println("failed to send");
  }
}





