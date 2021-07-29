#include <Wire.h>
#include "MAX30100_PulseOximeter.h"
 
#define REPORTING_PERIOD_MS     1000
 
PulseOximeter pox;
uint32_t tsLastReport = 0;
float HeartRate;
float SpO2;
const int sensor=A0;
float temp;
float vout;
char Plot;
int i = 0;
void setup()
{
    Serial.begin(9600);
    pox.begin();
    pinMode(sensor,INPUT); 
    pox.setIRLedCurrent(MAX30100_LED_CURR_7_6MA);

}
 
void loop()
{   
    
    while(1){
          pox.update(); 
          if (millis() - tsLastReport > REPORTING_PERIOD_MS) {
          HeartRate = pox.getHeartRate();
          tsLastReport = millis();
          Serial.println(HeartRate);
          delayMicroseconds(15);
          
          SpO2 = pox.getSpO2();
          Serial.println(SpO2);
          delayMicroseconds(15);
          
          vout=analogRead(sensor);     
          temp=(vout*500)/1023; 
          Serial.println(temp);     
          delayMicroseconds(15); 
          i++;
          }}}

         
