//Caio Gonçalves Feiertag - 1510590
#define LED1 10
#define LED2 11
#define LED3 12
#define LED4 13
#define KEY1 A1
#define KEY2 A2
#define KEY3 A3
#define BUZZ 3
#define MINUTE 60000
#define LATCH_DIO 4
#define CLK_DIO 7
#define DATA_DIO 8
typedef struct tempo{
  int minute;
  int hour;
}Time;
/* Segment byte maps for numbers 0 to 9 */
const byte SEGMENT_MAP[] = {0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0X80,0X90};
/* Byte maps to select digit 1 to 4 */
const byte SEGMENT_SELECT[] = {0xF1,0xF2,0xF4,0xF8};
//func
void add_minute(Time * x);
void add_hour(Time *x);
void update_time(Time *x);
void active_alarm();
void deactive_alarm();
void soneca();
void WriteNumberToSegment(byte Segment, byte Value);
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
int vLED[]={LED1,LED2,LED3,LED4};
void setup() {
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
  Serial.begin(9600);
  clock_time.hour=0;
  clock_time.minute=0;
  alarm_time.hour=0;
  alarm_time.minute=0;
  display_time=&clock_time;
  digitalWrite(BUZZ,1);
}
void loop () {
  digitalWrite(BUZZ,1);
  unsigned long now = millis();
  update_time(display_time);
  if (now >= old+MINUTE) {
    old = now;
    add_minute(&clock_time);
  }
  if (clock_time.hour==alarm_time.hour&&clock_time.minute==alarm_time.minute&&alarm==true) {
    digitalWrite(vLED[mode],HIGH);
    mode=0;
    digitalWrite(vLED[mode],LOW);
    display_time=&clock_time;
    bool aux=true;
    tone(BUZZ,2000);
    if(digitalRead(KEY1)!=but1){
      but1=!but1;
      if(but1==LOW){
        soneca();
        
      }
    }
  }
  if(digitalRead(KEY1)!=but1){
    but1=!but1;
    old1=now;
    time1=500;
    if(but1==LOW){
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
      if(now>=old1+time1){
        if(time1>120)
          time1*=0.85;
        old1=now;
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
    but2=!but2;
    old2=now;
    time2=500;
    if(but2==LOW){
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
      if(time2+old2<=now){
        if(time2>200)
          time2*=0.8;
        old2=now;
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
  //adiciona um minuto
    but3=!but3;
    if(but3==LOW){
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
  noTone(BUZZ);
  digitalWrite(LED4,HIGH);
}
void soneca(){
  noTone(BUZZ);
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
