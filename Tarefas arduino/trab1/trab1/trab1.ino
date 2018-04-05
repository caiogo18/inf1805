//Caio Gonçalves Feiertag - 1510590
#include "trab1.h"
//funçoes auxiliares 
void add_minute(Time * x); 
void add_hour(Time *x);
void update_time(Time *x);
void active_alarm();
void deactive_alarm();
void soneca();
void WriteNumberToSegment(byte Segment, byte Value);
/********************/
//variaveis globais
bool alarm=false;
unsigned long old=0;
int but1=HIGH; //status botao1
int but2=HIGH; //status botao2
int but3=HIGH; //status botao3
int mode=0;
Time clock_time;
Time alarm_time;
Time * display_time;
int time1,time2;
unsigned long old1,old2;
/********************/
int vLED[]={LED1,LED2,LED3,LED4};
/* Segment byte maps for numbers 0 to 9 */
const byte SEGMENT_MAP[] = {0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0X80,0X90};
/* Byte maps to select digit 1 to 4 */
const byte SEGMENT_SELECT[] = {0xF1,0xF2,0xF4,0xF8};
/********************/

void setup() {
  //inicializa portas
  pinMode(BUZZ, OUTPUT);
  pinMode(KEY1,INPUT_PULLUP);
  pinMode(KEY2,INPUT_PULLUP);
  pinMode(KEY3,INPUT_PULLUP);
  pinMode(LATCH_DIO,OUTPUT);
  pinMode(CLK_DIO,OUTPUT);
  pinMode(DATA_DIO,OUTPUT);
  for(int i=0;i<4;i++){
    pinMode(vLED[i], OUTPUT);
    if(i!=0)digitalWrite(vLED[i],HIGH);
  }
  //inicializa variaveis globais
  clock_time.hour=0;
  clock_time.minute=0;
  alarm_time.hour=0;
  alarm_time.minute=0;
  display_time=&clock_time;
}

void loop () {
  digitalWrite(BUZZ,1); //"desbuga" o buzzer
  unsigned long now = millis();
  update_time(display_time);
  if (now >= old+MINUTE) {
    //adiciona 1 minuto a cada 60000ms passados
    old = now;
    add_minute(&clock_time);
  }
  if (clock_time.hour==alarm_time.hour&&clock_time.minute==alarm_time.minute&&alarm==true) {
    //se o alarme estiver ligado aciona troca para o modo 0 e liga o buzzer
    digitalWrite(vLED[mode],HIGH);
    mode=0;
    digitalWrite(vLED[mode],LOW);
    display_time=&clock_time;
    tone(BUZZ,2000);
    if(digitalRead(KEY1)!=but1){
      //"So mais 5 minutinhos"
      but1=!but1;
      if(but1==LOW){
        soneca();
        
      }
    }
  }
  if(digitalRead(KEY1)!=but1){
    //seta as variaveis que controlam o pressionamento de botao1
    but1=!but1;
    old1=now;
    time1=500;
    if(but1==LOW){
      //realiza operaçoes relacionados ao botao1
      switch(mode){
        case 0 : // ativa alarme
          active_alarm();
          break;
        case 1 : //adiciona 1 minuto no horario
          add_minute(&clock_time);
          break;
        case 2 : //adiciona 1 minuto no alarme
          add_minute(&alarm_time);
      }
    }
  }
  else{
    if(but1==LOW){
      //se continuar pressionado, acelera a "leitura do botao"
      if(now>=old1+time1){
        if(time1>120)
          time1*=0.85;
        old1=now;
        //realiza operaçoes relacionados ao botao1
        switch(mode){
          case 0 : // ativa alarme
            active_alarm();
            break;
          case 1 : //adiciona 1 minuto no horario
            add_minute(&clock_time);
            break;
          case 2 : //adiciona 1 minuto no alarme
            add_minute(&alarm_time);
        }
      }
    }
  }
  if(digitalRead(KEY2)!=but2){
    //seta as variaveis que controlam o pressionamento de botao2
    but2=!but2;
    old2=now;
    time2=500;
    if(but2==LOW){
      //realiza operaçoes relacionados ao botao2
      switch(mode){
        case 0 : //desativa alarme
          deactive_alarm();
          break;
        case 1 : //adiciona 1 hora no horario
          add_hour(&clock_time);
          break;
        case 2 : //adiciona 1 hora no alarme
          add_hour(&alarm_time);
      }
    }
  }
  else{
    if(but2==LOW){
      //se continuar pressionado, acelera a "leitura do botao"
      if(time2+old2<=now){
        if(time2>200)
          time2*=0.8;
        old2=now;
        //realiza operaçoes relacionados ao botao2
        switch(mode){
          case 0 : //desativa alarme
            deactive_alarm();
            break;
          case 1 : //adiciona 1 hora no horario
            add_hour(&clock_time);
            break;
          case 2 : //adiciona 1 hora no alarme
            add_hour(&alarm_time);
        }
      }
    }
  }
  if(digitalRead(KEY3)!=but3){ 
  //seta as variaveis que controlam o pressionamento de botao3
    but3=!but3;
    if(but3==LOW){
      //troca o modo
      digitalWrite(vLED[mode],HIGH);
      mode++;
      if(mode>2)
        mode=0;
      digitalWrite(vLED[mode],LOW);
      if(mode==2)
        display_time=&alarm_time;
      else
        display_time=&clock_time;
    }
  }
}
void add_minute(Time *x){
  x->minute++;
  if(x->minute>=60){
    x->minute=0;
    add_hour(x);
  }
}
void add_hour(Time *x){
  x->hour++;
  if(x->hour>=24){
    x->hour=0;
  }
}
void update_time(Time *x){
  WriteNumberToSegment(0 , x->hour/10);
  WriteNumberToSegment(1 , x->hour%10);
  WriteNumberToSegment(2 , x->minute/10);
  WriteNumberToSegment(3 , x->minute%10);
}
void active_alarm(){
  alarm=true;
  digitalWrite(LED4,LOW);
}
void deactive_alarm(){
  alarm=false;
  digitalWrite(LED4,HIGH);
}
void soneca(){
  for(int i=0;i<5;i++)
    add_minute(&alarm_time);
}
/* Write a decimal number between 0 and 9 to one of the 4 digits of the display */
void WriteNumberToSegment(byte Segment, byte Value){
  digitalWrite(LATCH_DIO,LOW);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_MAP[Value]);
  shiftOut(DATA_DIO, CLK_DIO, MSBFIRST, SEGMENT_SELECT[Segment] );
  digitalWrite(LATCH_DIO,HIGH);
}
