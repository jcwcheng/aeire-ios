/*
 *  This sketch demonstrates how to set up a simple HTTP-like server.
 *  The server will set a GPIO pin depending on the request
 *    http://server_ip/gpio/0 will set the GPIO2 low,
 *    http://server_ip/gpio/1 will set the GPIO2 high
 *  server_ip is the IP address of the ESP8266 module, will be 
 *  printed to Serial when the module is connected.
 */

#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include "FastLED.h"
#include "twilio.hpp"

// const char* ssid = "BOTT";
// const char* password = "iotpassword";

const char* ssid = "ma234";
const char* password = "jasonjennifer";

const char* fingerprint = "47 18 D6 BE F5 D0 BF CE 01 B7 AD BD 96 3A AA 46 F1 8C F1 A5";
const char* account_sid = "AC14dc7c78caa034614c779ef540c3fe61";
const char* auth_token = "9457c3955d0c80d70bc1fc309bd43cf9";
String to_number    = "+14157489861";
String from_number  = "+16507724292";
String message_body = "Justin! Someone is ringing your doorbell!";
String master_number = "+16507724292";
String media_url = "";

const char* host = "jccheng.com";

const int AnalogIn  = A0;
int readingIn = 0;
int fadeAmount = 5;
int brightness = 0;

#define NUM_LEDS 17 
#define DATA_PIN 2

CRGB leds[NUM_LEDS];

// Create an instance of the server
// specify the port to listen on as an argument
Twilio *twilio;
WiFiServer server(80);
ESP8266WebServer twilio_server(8000);

#if USE_SOFTWARE_SERIAL == 1
#include <SoftwareSerial.h>
extern SoftwareSerial swSer(14, 4, false, 256);
#endif

void wifiConnect() {
  // Connect to WiFi network
  Serial.println();
  Serial.println();
  Serial.print("Connecting to ");
  Serial.println(ssid);
  
  WiFi.begin(ssid, password);

  while (WiFi.status() != WL_CONNECTED) {
    for( int i = 0; i < NUM_LEDS; i++ ) {
      leds[i] = CHSV( 96, 255, 255 );
      FastLED.show(); 
      delay(20);
    }
    delay(500);
    for( int i = 0; i < NUM_LEDS; i++ ) {
      leds[i] = CHSV( 96, 255, 80 );
      FastLED.show(); 
      delay(20);
    }
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");

  for( int i = 0; i < NUM_LEDS; i++ ) {
      leds[i] = CHSV( 160, 255, 120 );
      FastLED.show(); 
      delay(20);    
   }
  
  // Start the server
  server.begin();
  Serial.println("Server started");

  // Print the IP address
  Serial.println(WiFi.localIP());
}

void handle_message() {
        #if USE_SOFTWARE_SERIAL == 1
        swSer.println("Incoming connection!  Printing body:");
        #endif
        bool authorized = false;
        char command = '\0';

        // Parse Twilio's request to the ESP
        for (int i = 0; i < twilio_server.args(); ++i) {
                #if USE_SOFTWARE_SERIAL == 1
                swSer.print(twilio_server.argName(i));
                swSer.print(": ");
                swSer.println(twilio_server.arg(i));
                #endif

                if (twilio_server.argName(i) == "From" and 
                    twilio_server.arg(i) == master_number) {
                    authorized = true;
                } else if (twilio_server.argName(i) == "Body") {
                        if (twilio_server.arg(i) == "?" or
                            twilio_server.arg(i) == "0" or
                            twilio_server.arg(i) == "1") {
                                command = twilio_server.arg(i)[0];
                        }
                }
        } // end for loop parsing Twilio's request

        // Logic to handle the incoming SMS
        String response = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>";
        if (command != '\0') {
                if (authorized) {
                        switch (command) {
                        case '0':
                                digitalWrite(LED_BUILTIN, LOW);
                                response += "<Response><Message>"
                                "Turning light off!"
                                "</Message></Response>";
                                break;
                        case '1':
                                digitalWrite(LED_BUILTIN, HIGH);
                                response += "<Response><Message>"
                                "Turning light on!"
                                "</Message></Response>";
                                break;
                        case '?':
                        default:
                                response += "<Response><Message>"
                                "0 - Light off, 1 - Light On, "
                                "? - Help\n"
                                "The light is currently: ";
                                response += digitalRead(LED_BUILTIN);
                                response += "</Message></Response>";
                                break;               
                        }
                } else {
                        response += "<Response><Message>"
                        "Unauthorized!"
                        "</Message></Response>";
                }

        } else {
                response += "<Response><Message>"
                "Look: a SMS response from an ESP8266!"
                "</Message></Response>";
        }

        twilio_server.send(200, "application/xml", response);
}

void pushNotification() {
  // Use WiFiClient class to create TCP connections
  WiFiClient client;
  const int httpPort = 80;
  if ( !client.connect( host, httpPort ) ) {
    Serial.println( "connection failed" );
    // sendSMS();
    return;
  }
  
  // We now create a URI for the request
  String url = "/SendNotification.php";
  
  Serial.print("Requesting URL: ");
  Serial.println( url );
  
  // This will send the request to the server
  client.print( String("GET ") + url + " HTTP/1.1\r\n" +
               "Host: " + host + "\r\n" + 
               "Connection: close\r\n\r\n" );
  unsigned long timeout = millis();
  while ( client.available() == 0 ) {
    if ( millis() - timeout > 5000 ) {
      Serial.println(">>> Client Timeout !");
      client.stop();
      return;
    }
  }
  
  // Read all the lines of the reply from server and print them to Serial
  while( client.available() ){
    String line = client.readStringUntil('\r');
    Serial.print( line );
  }
  
  Serial.println();
  Serial.println( "closing connection" ); 
  for( int i = 0; i < NUM_LEDS; i++ ) {
      leds[i] = CHSV( 160, 255, 120 );
      FastLED.show(); 
      delay(20);
  } 
}

void sendSMS() {
  String response;
  bool success = twilio->send_message(
         to_number,
         from_number,
         message_body,
         response,
         media_url
  );
                
  twilio_server.on("/message", handle_message);
  twilio_server.begin();
        
  #if USE_SOFTWARE_SERIAL == 1
  Serial.println(response);
  #endif  
}

void ledAction() {
  static uint8_t value = 0;

  // First slide the led in one direction
  //if ( value <= 250 ) {
    for( int i = 0; i < NUM_LEDS; i++ ) {
      // Set the i'th led to green 
      leds[i] = CHSV( 0, 255, 255 );
      FastLED.show(); 
      delay(20);
      if ( i == NUM_LEDS - 1 ) {        
        for( int j = 0; j < NUM_LEDS; j++ ) {      
          leds[j] = CHSV( 0, 255, 0 );
          FastLED.show(); 
          delay(20);
          if ( j == NUM_LEDS - 1 ) {
            pushNotification();    
          }
        }        
      }
    //}
  }  
}

void setup() {
  Serial.begin(115200);
  delay(20);
  
  LEDS.addLeds<WS2812,DATA_PIN,RGB>( leds, NUM_LEDS );
  LEDS.setBrightness( 64 );
 
  twilio = new Twilio( account_sid, auth_token, fingerprint );
  wifiConnect();
}

void loop() {
  twilio_server.handleClient();
  readingIn = analogRead( AnalogIn );
  
  if ( readingIn > 500 ) {
    ledAction();
  }
  else {
    
  }
  
  // Check if a client has connected  
  WiFiClient client = server.available();  
  if (!client) {
    return;
  }
  
  // Wait until the client sends some data
  Serial.println("new client");
  while(!client.available()){
    delay(1);
  }
  
  // Read the first line of the request
  String req = client.readStringUntil('\r');
  Serial.println( "========" );
  Serial.println(req);
  Serial.println( "========" );
  client.flush();
  
  // Match the request
  int val;
  if (req.indexOf("/gpio/0") != -1)
    val = 0;
  else if (req.indexOf("/gpio/1") != -1)
    val = 1;
  else if (req.indexOf("/ssid/") != -1 ) {
    int commandIndex = req.indexOf( " " );
    int endIndex = req.indexOf( " ", commandIndex + 1 );
    String payload = req.substring( commandIndex + 1, endIndex ); 
    commandIndex = payload.indexOf( "/" );
    endIndex = payload.indexOf( "/", commandIndex + 1 );
    int lastIndex = payload.indexOf( "/", endIndex + 1 );
    String ids = payload.substring( endIndex + 1, lastIndex );
    String pwd = payload.substring( lastIndex + 1 );
    const char* id = ids.c_str();
    const char* pp = pwd.c_str();
    ssid = id;
    password = pp;
    // server.stop();
    wifiConnect();
    return;
  }
  else {
    Serial.println("invalid request");
    client.stop();
    return;
  }  
  
  // Set GPIO2 according to the request
  digitalWrite(2, val);
  
  client.flush();

  // Prepare the response
  String s = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<!DOCTYPE HTML>\r\n<html>\r\nGPIO is now ";
  s += (val)?"high":"low";
  s += "</html>\n";

  // Send the response to the client
  client.print(s);
  delay(1);
  Serial.println("Client disonnected");

  // The client will actually be disconnected 
  // when the function returns and 'client' object is detroyed
}

