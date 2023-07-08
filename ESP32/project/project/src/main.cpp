#include "secrets.h"
#include <WiFiClientSecure.h>
#include <PubSubClient.h>
#include <ArduinoJson.h>
#include "WiFi.h"
#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>
#define DHTPIN 18     // Digital pin connected to the DHT sensor
#define DHTTYPE DHT11   // DHT 11
DHT dht(DHTPIN, DHTTYPE);

#include "HX711.h"

// HX711 circuit wiring
const int LOADCELL_DOUT_PIN = 32;
const int LOADCELL_SCK_PIN = 33;
HX711 scale;

//light
const int PIN_RED   = 13;
const int PIN_GREEN = 12;
const int PIN_BLUE  = 0;
const int Distance_sensor = 2;
const int Distance_light  = 15;

void setColor(int R, int G, int B) {
  analogWrite(PIN_RED,   R);
  analogWrite(PIN_GREEN, G);
  analogWrite(PIN_BLUE,  B);
}

float humidity ;
float temperature;
float weight;
float distance;
int flag = 1;

//motor
int freq = 50;      // 频率(20ms周期)
int channel = 8;    // 通道(高速通道（0 ~ 7）由80MHz时钟驱动，低速通道（8 ~ 15）由 1MHz 时钟驱动。)
int resolution_motor = 8; // 分辨率
const int led = 14;

int calculatePWM(int degree)
{ //0-180度
 //20ms周期，高电平0.5-2.5ms，对应0-180度角度
  const float deadZone = 6.4;//对应0.5ms（0.5ms/(20ms/256）)
  const float max = 32;//对应2.5ms
  if (degree < 0)
    degree = 0;
  if (degree > 180)
    degree = 180;
  return (int)(((max - deadZone) / 180) * degree + deadZone);
}

void openlid(int second){
      //muticolor led
      setColor(0, 201, 204);
      delay(1000); // keep the color 1 second
      // color code #F7788A (R = 247, G = 120, B = 138)
      setColor(247, 120, 138);
      delay(1000); // keep the color 1 second
      // color code #34A853 (R = 52,  G = 168, B = 83)
      setColor(52, 168, 83);
      delay(1000); // keep the color 1 second
      //closed
      int d = 170;
      ledcWrite(channel, calculatePWM(d)); // 输出PWM
      Serial.printf("openning value=%d,calcu=%d\n", d, calculatePWM(d));
      delay(1000);
      //open
      d = 100;
      ledcWrite(channel, calculatePWM(d)); // 输出PWM
      Serial.printf("opened value=%d,calcu=%d\n", d, calculatePWM(d));
      delay(second);
      Serial.printf("delay=%d\n", second);
      //close again
      d = 170;
      ledcWrite(channel, calculatePWM(d)); // 输出PWM
      Serial.printf("closing value=%d,calcu=%d\n", d, calculatePWM(d));
      setColor(0,0,0);
}


//data from esp32 to aws
//#define ESP32CAM_PUBLISH_TOPIC   "esp32/cam_0"
#define AWS_IOT_PUBLISH_TOPIC1   "esp32/humidity_temperature_weight"
#define AWS_IOT_PUBLISH_TOPIC2   "esp32/distance"
//data from aws to esp32
#define AWS_IOT_SUBSCRIBE_TOPIC "esp32/aws2esp"


WiFiClientSecure net = WiFiClientSecure();
PubSubClient client(net);


void messageHandler(char* topic, byte* payload, unsigned int length)
{
  Serial.print("incoming: ");
  Serial.println(topic);
 
  StaticJsonDocument<200> doc;
  deserializeJson(doc, payload);
  const char* message = doc["message"];
  if(strcmp(message,"999") == 0){
       openlid(3000);
  }else if(strcmp(message,"3") == 0){
     openlid(3000);
  }
  Serial.println(message);
}
 
void connectAWS()
{
  WiFi.mode(WIFI_STA);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
 
  Serial.println("Connecting to Wi-Fi");
 
  while (WiFi.status() != WL_CONNECTED)
  {
    delay(500);
    Serial.print(".");
  }
 
  // Configure WiFiClientSecure to use the AWS IoT device credentials
  net.setCACert(AWS_CERT_CA);
  net.setCertificate(AWS_CERT_CRT);
  net.setPrivateKey(AWS_CERT_PRIVATE);
 
  // Connect to the MQTT broker on the AWS endpoint we defined earlier
  client.setServer(AWS_IOT_ENDPOINT, 8883);
 
  // Create a message handler
  client.setCallback(messageHandler);
 
  Serial.println("Connecting to AWS IOT");
 
  while (!client.connect(THINGNAME))
  {
    Serial.print(".");
    delay(100);
  }

  if (!client.connected())
  {
    Serial.println("AWS IoT Timeout!");
    return;
  }
 
  // Subscribe to a topic
  client.subscribe(AWS_IOT_SUBSCRIBE_TOPIC);
 
  Serial.println("AWS IoT Connected!");
}
 
void publishMessage1()
{
  StaticJsonDocument<200> doc;
  doc["id"] = 11;
  doc["humidity"] = humidity;
  doc["temperature"] = temperature;
  doc["weight"] = weight;
  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer); // print to client
 
  client.publish(AWS_IOT_PUBLISH_TOPIC1, jsonBuffer);
}

void publishMessage2()
{
  StaticJsonDocument<200> doc;
  doc["id"] = 11;
  doc["distance"] = distance;
  
  char jsonBuffer[512];
  serializeJson(doc, jsonBuffer); // print to client
 
  client.publish(AWS_IOT_PUBLISH_TOPIC2, jsonBuffer);
}
 

void scaleinit(){
  scale.begin(LOADCELL_DOUT_PIN, LOADCELL_SCK_PIN);
  Serial.println("Before setting up the scale:");
  Serial.print("read: \t\t");
  Serial.println(scale.read());			// print a raw reading from the ADC

  Serial.print("read average: \t\t");
  Serial.println(scale.read_average(20));  	// print the average of 20 readings from the ADC

  Serial.print("get value: \t\t");
  Serial.println(scale.get_value(5));		// print the average of 5 readings from the ADC minus the tare weight (not set yet)

  Serial.print("get units: \t\t");
  Serial.println(scale.get_units(5), 1);	// print the average of 5 readings from the ADC minus tare weight (not set) divided
						// by the SCALE parameter (not set yet)

  scale.set_scale(2280.f);                      // this value is obtained by calibrating the scale with known weights; see the README for details
  scale.tare();				        // reset the scale to 0

  Serial.println("After setting up the scale:");

  Serial.print("read: \t\t");
  Serial.println(scale.read());                 // print a raw reading from the ADC

  Serial.print("read average: \t\t");
  Serial.println(scale.read_average(20));       // print the average of 20 readings from the ADC

  Serial.print("get value: \t\t");
  Serial.println(scale.get_value(5));		// print the average of 5 readings from the ADC minus the tare weight, set with tare()

  Serial.print("get units: \t\t");
  Serial.println(scale.get_units(5), 1);        // print the average of 5 readings from the ADC minus tare weight, divided
						// by the SCALE parameter set with set_scale
}
 
int get_distance(){
  Serial.printf("dsitant value=%d\n",digitalRead(Distance_sensor)); // print the data fromthe sensor
    if(digitalRead(Distance_sensor)==1){
      digitalWrite(Distance_light,HIGH);
      return 1;
    }
    else{
      digitalWrite(Distance_light,LOW);
      return 0;
    }
}
void setup()
{
  Serial.begin(9600);
  scaleinit();
  dht.begin();
  pinMode(Distance_light,OUTPUT);
  
  // pinMode(18,OUTPUT);
  ledcSetup(channel, freq, resolution_motor); // 设置通道
  ledcAttachPin(led, channel);          // 将通道与对应的引脚连接
  connectAWS();

}
 
void loop()
{
  humidity = dht.readHumidity();
  temperature = dht.readTemperature();
  weight = scale.get_units(10)*3;
  distance = get_distance(); 
  if (distance == 1){
    digitalWrite(Distance_light,HIGH);
  }else{
    digitalWrite(Distance_light,LOW);
  }

 
  if (isnan(humidity) || isnan(temperature) || isnan(weight) || isnan(distance))  // Check if any reads failed and exit early (to try again).
  {
    temperature = 24;
    humidity = 23;
    Serial.println("humidity:");
    Serial.println(humidity);
    Serial.println("temperature:");
    Serial.println(temperature);
    Serial.println("weight:");
    Serial.println(weight);
    Serial.println("distance:");
    Serial.println(distance);
    Serial.println(F("Failed to read from sensor!"));
  }

  if(flag){
    if(weight > 5){
      publishMessage1();
      flag = 0;
    }
    
  }
  //Serial.println("humidity:");
  //Serial.println(humidity);
  //Serial.println("temperature:");
  //Serial.println(temperature);
  //Serial.println("weight:");
  //Serial.println(weight);
  //Serial.println("distance:");
  //Serial.println(distance);
  
  publishMessage2();
  client.loop();
}