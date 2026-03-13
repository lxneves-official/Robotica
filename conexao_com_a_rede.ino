#include <ESP8266WiFi.h> //INCLUSÃO DA BIBLIOTECA NECESSÁRIA PARA FUNCIONAMENTO DO CÓDIGO
 
const char* ssid = "nome_da_sua_rede_WIFI"; //VARIÁVEL QUE ARMAZENA O NOME DA REDE SEM FIO EM QUE VAI CONECTAR
const char* password = "senha_da_sua_rede_WIFI"; //VARIÁVEL QUE ARMAZENA A SENHA DA REDE SEM FIO EM QUE VAI CONECTAR
 
WiFiServer server(80); //CASO OCORRA PROBLEMAS COM A PORTA 80, UTILIZE OUTRA (EX:8082,8089) E A CHAMADA DA URL FICARÁ IP:PORTA(EX: 192.168.0.15:8082)
 
void setup() {
Serial.begin(115200); //INICIALIZA A SERIAL
delay(10); //INTERVALO DE 10 MILISEGUNDOS
 
Serial.println(""); //PULA UMA LINHA NA JANELA SERIAL
Serial.println(""); //PULA UMA LINHA NA JANELA SERIAL
Serial.print("Conectando a "); //ESCREVE O TEXTO NA SERIAL
Serial.print(ssid); //ESCREVE O NOME DA REDE NA SERIAL
 
WiFi.begin(ssid, password); //PASSA OS PARÂMETROS PARA A FUNÇÃO QUE VAI FAZER A CONEXÃO COM A REDE SEM FIO
 
while (WiFi.status() != WL_CONNECTED) { //ENQUANTO STATUS FOR DIFERENTE DE CONECTADO
delay(500); //INTERVALO DE 500 MILISEGUNDOS
Serial.print("."); //ESCREVE O CARACTER NA SERIAL
}
Serial.println(""); //PULA UMA LINHA NA JANELA SERIAL
Serial.print("Conectado a rede sem fio "); //ESCREVE O TEXTO NA SERIAL
Serial.println(ssid); //ESCREVE O NOME DA REDE NA SERIAL
server.begin(); //INICIA O SERVIDOR PARA RECEBER DADOS NA PORTA DEFINIDA EM "WiFiServer server(porta);"
Serial.println("Servidor iniciado"); //ESCREVE O TEXTO NA SERIAL
 
Serial.print("IP para se conectar ao NodeMCU: "); //ESCREVE O TEXTO NA SERIAL
Serial.print("http://"); //ESCREVE O TEXTO NA SERIAL
Serial.println(WiFi.localIP()); //ESCREVE NA SERIAL O IP RECEBIDO DENTRO DA REDE SEM FIO (O IP NESSA PRÁTICA É RECEBIDO DE FORMA AUTOMÁTICA)
}
void loop() {
WiFiClient client = server.available(); //VERIFICA SE ALGUM CLIENTE ESTÁ CONECTADO NO SERVIDOR
if (!client) { //SE NÃO EXISTIR CLIENTE CONECTADO, FAZ
return; //REEXECUTA O PROCESSO ATÉ QUE ALGUM CLIENTE SE CONECTE AO SERVIDOR
}
Serial.println("Novo cliente se conectou!"); //ESCREVE O TEXTO NA SERIAL
while(!client.available()){ //ENQUANTO CLIENTE ESTIVER CONECTADO
delay(1); //INTERVALO DE 1 MILISEGUNDO
}
String request = client.readStringUntil('\r'); //FAZ A LEITURA DA PRIMEIRA LINHA DA REQUISIÇÃO
Serial.println(request); //ESCREVE A REQUISIÇÃO NA SERIAL
client.flush(); //AGUARDA ATÉ QUE TODOS OS DADOS DE SAÍDA SEJAM ENVIADOS AO CLIENTE
 
client.println("HTTP/1.1 200 OK"); //ESCREVE PARA O CLIENTE A VERSÃO DO HTTP
client.println("Content-Type: text/html"); //ESCREVE PARA O CLIENTE O TIPO DE CONTEÚDO(texto/html)
client.println("");
client.println("<!DOCTYPE HTML>"); //INFORMA AO NAVEGADOR A ESPECIFICAÇÃO DO HTML
client.println("<html>"); //ABRE A TAG "html"
client.println("<h1><center>Olá Maker do SESI/SENAI!</center></h1>"); //ESCREVE "Ola Maker do SESI/SENAI!" NA PÁGINA
client.println("<center><font size='5'>Seja bem vindo!</center>"); //ESCREVE "Seja bem vindo!" NA PÁGINA
client.println("</html>"); //FECHA A TAG "html"
delay(1); //INTERVALO DE 1 MILISEGUNDO
Serial.println("Cliente desconectado"); //ESCREVE O TEXTO NA SERIAL
Serial.println(""); //PULA UMA LINHA NA JANELA SERIAL
}
