//Caio Gonçalves Feiertag - 1510590
#define LED1 13
#define KEY1 A1
#define KEY2 A2
void setup() {
  pinMode(LED1, OUTPUT); // Enable pin 13 for digital output
  pinMode(KEY1,INPUT_PULLUP);
  pinMode(KEY2,INPUT_PULLUP);
}
//variaveis globais
int but1=HIGH; //status botao1
int but2=HIGH; //status botao2
bool off1=false; //status do botao1 durante 500ms
bool off2=false; //status botao2 durante 500ms
int state = 1; 
int time=1000;
unsigned long old1;
unsigned long old2;
void loop () {
 unsigned long now = millis();
 if (now >= old1+time) { //pisca-pisca
  old1 = now;
  state = !state;
  digitalWrite(LED1, state);
 }
 if(digitalRead(KEY1)!=but1){ 
  //acelera um pouco cada vez que o botao1 é pressionado
   but1=!but1;
   if(but1==LOW){
    old2=now;
    time=time*0.9;
    off1=!off1;
  }
 }
 if(digitalRead(KEY2)!=but2){
  //desacelera um pouco cada vez que o botao2 é pressionado
   but2=!but2;
   if(but2==LOW){
    old2=now;
    time=time*1.1;
    off2=!off2;
  }
 }
 if(now>=old2+500){
  //reseta o status dos botoes
  off1=false;
  off2=false;
 }
 else{
   if(off1==true&&off2==true){
    //parar
      while(1);
   }
  }
}
