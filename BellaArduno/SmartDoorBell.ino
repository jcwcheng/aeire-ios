/*
 * Twilio SMS and MMS on ESP8266 Example.
 */

#include <ESP8266WiFi.h>
#include <ESP8266WebServer.h>
#include "twilio.hpp"

// Use software serial for debugging?
#define USE_SOFTWARE_SERIAL 0

// Your network SSID and password
 const char* ssid = "ma234";
 const char* password = "jasonjennifer";

// Find the api.twilio.com SHA1 fingerprint, this one was valid as 
// of January 2017.
 const char* fingerprint = "47 18 D6 BE F5 D0 BF CE 01 B7 AD BD 96 3A AA 46 F1 8C F1 A5";

// Twilio account specific details, from https://twilio.com/console
 const char* account_sid = "ACXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
 const char* auth_token = "your_auth_token";

// Details for the SMS we'll send with Twilio.  Should be a number you own 
// (check the console, link above).
 String to_number    = "+14083986530";
 String from_number  = "+16507724292";
 String message_body = "Hello from Twilio and the ESP8266!";

// The 'authorized number' to text the ESP8266 for our example
 String master_number    = "+16507724292";

// Optional - a url to an image.  See 'MediaUrl' here: 
// https://www.twilio.com/docs/api/rest/sending-messages
 String media_url = "";

// Global twilio objects
 Twilio *twilio;
 ESP8266WebServer twilio_server(8000);

//  Optional software serial debugging
#if USE_SOFTWARE_SERIAL == 1
#include <SoftwareSerial.h>
// You'll need to set pin numbers to match your setup if you
// do use Software Serial
 extern SoftwareSerial swSer(14, 4, false, 256);
#endif

/*
 * Callback function when we hit the /message route with a webhook.
 * Use the global 'twilio_server' object to respond.
 */
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

/*
 * Setup function for ESP8266 Twilio Example.
 * 
 * Here we connect to a friendly wireless network, instantiate our twilio 
 * object, optionally set up software serial, then send a SMS or MMS message.
 */
void setup() {
        pinMode(2, OUTPUT);
        WiFi.begin(ssid, password);
        twilio = new Twilio(account_sid, auth_token, fingerprint);

        #if USE_SOFTWARE_SERIAL == 1
        swSer.begin(115200);
        while (WiFi.status() != WL_CONNECTED) {
                delay(1000);
                swSer.print(".");
        }
        swSer.println("");
        swSer.println("Connected to WiFi, IP address: ");
        swSer.println(WiFi.localIP());
        #else
        while (WiFi.status() != WL_CONNECTED) delay(1000);
        #endif

        // Response will be filled with connection info and Twilio API responses
        // from this initial SMS send.
        String response;
        bool success = twilio->send_message(
                to_number,
                from_number,
                message_body,
                response,
                media_url
                );

        // Set up a route to /message which will be the webhook url
        twilio_server.on("/message", handle_message);
        twilio_server.begin();

        // Use LED_BUILTIN to find the LED pin and set the GPIO to output
        pinMode(LED_BUILTIN, OUTPUT);

        #if USE_SOFTWARE_SERIAL == 1
        swSer.println(response);
        #endif
}


/* 
 *  In our main loop, we listen for connections from Twilio in handleClient().
 */
void loop() {
    twilio_server.handleClient();
    readingIn = analogRead(AnalogIn);
    if ( readingIn > 500 ) {
      digitalWrite(2, HIGH);
    } 
    else {
      digitalWrite(2, LOW);
    }
}

