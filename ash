#include <ESP8266WiFi.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include <Wire.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>


const char* ssid = "ABDS";  // Rede
const char* password = "Ashi125g";  // Senha


#define DADOS D1
OneWire oneWire(DADOS);
DallasTemperature sensors(&oneWire);


const int pinoSensorUmidade = A0;


ESP8266WebServer server(80);


int bomba = D0; // Pino da bomba
int umidade;
float temperatura;


void setup() {
  Serial.begin(115200);
  pinMode(bomba, OUTPUT);
  digitalWrite(bomba, LOW); // Bomba desligada inicialmente
 
  Serial.println("");
  Serial.print("Tentando conectar a ");
  WiFi.begin(ssid, password);


  // Tenta conectar à rede
  int tentativas = 0;
  while (WiFi.status() != WL_CONNECTED && tentativas < 20) {
    delay(500);
    Serial.print(".");
    tentativas++;
  }


  if (WiFi.status() == WL_CONNECTED) {
    Serial.println("");
    Serial.println("Conectado à rede.");
    Serial.print("IP do webserver: ");
    Serial.println(WiFi.localIP());  // Mostra o IP do ESP8266
  } else {
    Serial.println("Não foi possível conectar à rede.");
    return; // Não continua se não conectar
  }


  sensors.begin();
  server.on("/", handleRoot);
  server.on("/bomba/on", HTTP_GET, []() {
    digitalWrite(bomba, HIGH); // Liga a bomba
    server.send(200, "text/plain", "Bomba ligada");
  });
  server.on("/bomba/off", HTTP_GET, []() {
    digitalWrite(bomba, LOW); // Desliga a bomba
    server.send(200, "text/plain", "Bomba desligada");
  });
  server.on("/dados", HTTP_GET, handleDados);
  server.begin();
}


void loop() {
  umidade = analogRead(pinoSensorUmidade);
  sensors.requestTemperatures();
  temperatura = sensors.getTempCByIndex(0);
  server.handleClient();
}


void handleRoot() {
  String page = "<!DOCTYPE html><html><head><title>Monitoramento de Sensores</title>";
  page += "<meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">";
  page += "<style>";
  page += "body{font-family: Arial, sans-serif;background-color:#003f5c;margin:0;padding:0;display:flex;flex-direction:column;align-items:center;height:100vh;justify-content:space-between;overflow:hidden;}";
  page += "h1{color:#ffffff;text-align:center;margin-top:20px;margin-bottom:5px;background-color:#003366;padding:20px 40px;border-radius:15px;box-shadow:0 6px 12px rgba(0, 0, 0, 0.3);font-size:50px;text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.5);}";
  page += "h2{color:#ffffff;text-align:center;margin-top:5px;margin-bottom:30px;font-size:24px;background-color:#004080;padding:15px 40px;border-radius:10px;box-shadow:0 4px 8px rgba(0, 0, 0, 0.2);text-shadow: 2px 2px 8px rgba(0, 0, 0, 0.4);}";
  page += ".content{display:flex;width:100%;justify-content:center;align-items:center;flex-grow:1;max-width:1000px;}";
  page += ".box{width:45%;max-width:400px;background-color:#003366;border-radius:15px;box-shadow:0 6px 12px rgba(0, 0, 0, 0.1);padding:20px;display:flex;flex-direction:column;align-items:center;margin:0 20px;}";
  page += ".box-value{font-size:32px;font-weight:bold;color:#e0e0e0;margin-top:10px;background-color:#004080;padding:15px;border-radius:10px;box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);transition:transform 0.3s ease;}";
  page += "#umidade-box{margin-right:5%;}";
  page += "#temperatura-box{margin-left:5%;}";
  page += "#umidade,#temperatura{font-size:22px;color:#e0e0e0;text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.5);}";
  page += "#umidade-value:hover,#temperatura-value:hover{transform: scale(1.15);}";
  page += ".button-container{display:flex;justify-content:center;align-items:flex-end;width:100%;padding:20px;}";
  page += "button{width:100px;height:100px;border-radius:15px;background-color:#003366;color:#fff;border:none;cursor:pointer;box-shadow:0 6px 16px rgba(0, 0, 0, 0.3);transition:background-color 0.6s ease, transform 0.3s ease;margin: 10px;}";
  page += "button:hover{background-color:#00264d;}";
  page += "button:active{transform:scale(0.95);}";
  page += "footer{width:100%;background-color:#003366;padding:5px;text-align:center;font-size:14px;color:#ffffff;}";
  page += "</style>";
  page += "</head><body><h1>Devir</h1>";
  page += "<h2>arquitetura ambiental</h2>";
  page += "<div class='content'>";
  page += "<div id='umidade-box' class='box'><div id='umidade'>Umidade</div><div id='umidade-value' class='box-value'></div></div>";
  page += "<div id='temperatura-box' class='box'><div id='temperatura'>Temperatura</div><div id='temperatura-value' class='box-value'></div></div>";
  page += "</div>";
  page += "<div class='button-container'>";
  page += "<button onclick=\"location.href='/bomba/on'\">Ligar Bomba</button>";
  page += "<button onclick=\"location.href='/bomba/off'\">Desligar Bomba</button>";
  page += "</div>";
  page += "<footer>© 2024 Escola SESI de referência. Devir arquitetura ambiental 2º ano STEAM</footer>";
  page += "</body></html>";


  server.send(200, "text/html", page);
}


void handleDados() {
  int porcento = map(umidade, 1024, 0, 0, 128);
  String data = "{\"porcento\":" + String(porcento) + ", \"temperatura\":" + String(temperatura) + "}";
  server.send(200, "application/json", data);
}
