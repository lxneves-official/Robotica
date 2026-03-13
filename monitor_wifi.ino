//Placa: "NodeMCU 1.0 (ESP-12E Module)"
//Gerenciador de bibliotecas "ESP8266WIFI by Ivan Grokhotkov"
#include <ESP8266WiFi.h>
void setup(){
 Serial.begin(115200);// configura monitor serial 115200 Bps
 Serial.println(); // leva cursor para nova linha
 WiFi.mode(WIFI_STA); // configura rede no modo estacao 
 WiFi.disconnect(); // desconecta rede WIFI
 delay(100); // atraso de 100 milisegundos
}
void imprimeResultado(int NumeroRedes){
 Serial.printf("\n"); // cursor para nova linha 
 Serial.printf("%d redes encontradas\n", NumeroRedes); // imprime numero de redes encontradas
 for (int i = 0; i < NumeroRedes; i++){ // contagem das redes encontradas
 Serial.printf("%d: %s, (%ddBm) %s\n", i + 1, WiFi.SSID(i).c_str(), WiFi.RSSI(i), WiFi.encryptionType(i) == 
ENC_TYPE_NONE ? "aberta" : "fechada");
 }
}
void loop(){
 WiFi.scanNetworksAsync(imprimeResultado);// Faz busca pelas redes 
 delay(500); // atraso de 0,5 segundos
}
