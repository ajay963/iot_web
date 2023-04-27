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


struct payload_t {  // Structure of our payload
  unsigned long ms;
  unsigned long counter;
};
