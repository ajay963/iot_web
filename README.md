# iot
internet of things

<h1>ESP-32</h1><br>
The predecessor of ESP32, the ESP8266 has a builtin processor. 
However due to multitasking involved in updating the WiFi stack, most of the applications use a separate micro-controller for data processing, interfacing sensors and digital Input Output. With the ESP32 you may not want to use an additional micro-controller. ESP32 has Xtensa® Dual-Core 32-bit LX6 microprocessors, which runs up to 600 DMIPS. The ESP32 will run on breakout boards and modules from 160Mhz upto 240MHz . That is very good speed for anything that requires a microcontroller with connectivity options.<br><br>

The two cores are named Protocol CPU (PRO_CPU) and Application CPU (APP_CPU). That basically means the PRO_CPU processor handles the WiFi, Bluetooth and other internal peripherals like SPI, I2C, ADC etc. The APP_CPU is left out for the application code. This differentiation is done in the Espressif Internet Development Framework (ESP-IDF). ESP-IDF is the official software development framework for the chip. Arduino and other implementations for the development will be based on ESP-IDF.<br><br>




