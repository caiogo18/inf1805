//Caio Gonçalves Feiertag - 1510590
#define LED1 10
#define LED2 11
#define LED3 12
#define KEY1 A1
#define KEY2 A2
#define KEY3 A3
#define BUZZ 3
#define MINUTE 60000

void setup() {
  pinMode(LED1, OUTPUT); 
  pinMode(LED2, OUTPUT); 
  pinMode(LED3, OUTPUT);
  pinMode(BUZZ, OUTPUT);
  pinMode(KEY1,INPUT_PULLUP);
  pinMode(KEY2,INPUT_PULLUP);
  pinMode(KEY3,INPUT_PULLUP);
  Serial.begin(9600);
}
//func
void add_minute(int *m,int *h);
void add_hour(int *h);
void print_time(int m, int h);
void active_alarm();
void deactive_alarm();
//variaveis globais
int minute=0;
int hour=0;
int alarm_minute=0;
int alarm_hour=0;
bool alarm=false;
unsigned long old=0;
int but1=HIGH; //status botao1
int but2=HIGH; //status botao2
int but3=HIGH; //status botao3
int mode=0;
void loop () {
  unsigned long now = millis();
  if (now >= old+MINUTE) {
    old = now;
    add_minute(&minute,&hour);
    if(mode!=2)
      print_time(minute,hour);
  }
  if (hour==alarm_hour&&minute==alarm_minute&&alarm==true) {
    switch(mode){
      case 1 :
        digitalWrite(LED1,LOW);
        break;
      case 2 : 
        digitalWrite(LED2,LOW);
    }
    mode=0;
    print_time(minute,hour);
    bool aux=true;/*
    for(int i=0;i<10;i++){
      if(aux==true)
        tone(BUZZ,0);
      else
        tone(BUZZ,2000);
      aux=!aux;
      delay(1000);
    }*/
    tone(BUZZ,2000);
  }
  if(digitalRead(KEY1)!=but1){
    but1=!but1;
    if(but1==LOW){
      switch(mode){
        case 0 : // ativa alarme
          active_alarm();
          break;
        case 1 : //adiciona 1 minuto no horario
          add_minute(&minute,&hour);
          print_time(minute,hour);
          break;
        case 2 : //adiciona 1 minuto no alarme
          add_minute(&alarm_minute,&alarm_hour);
          print_time(alarm_minute,alarm_hour);
      }
    }
  }
  if(digitalRead(KEY2)!=but2){
    but2=!but2; 
    if(but2==LOW){
      switch(mode){
        case 0 : //desativa alarme
          deactive_alarm();
          break;
        case 1 : //adiciona 1 hora no horario
          add_hour(&hour);
          print_time(minute,hour);
          break;
        case 2 : //adiciona 1 hora no alarme
          add_hour(&alarm_hour);
          print_time(alarm_minute,alarm_hour);
      }
    }
  }
  if(digitalRead(KEY3)!=but3){ 
  //adiciona um minuto
    but3=!but3;
    if(but3==LOW){
      mode++;
      if(mode>2)
        mode=0;
      switch(mode){
        case 0 :
          print_time(minute,hour);
          digitalWrite(LED2,LOW);
          break;
        case 1 :
          print_time(minute,hour);
          digitalWrite(LED1,HIGH);
          break;
        case 2 : 
          print_time(alarm_minute,alarm_hour);
          digitalWrite(LED1,LOW);
          digitalWrite(LED2,HIGH);
      }
      Serial.println(mode);
    }
  }
}
void add_minute(int *m,int *h){
  (*m)++;
  if(*m>=60){
    *m=0;
    add_hour(h);
  }
}
void add_hour(int *h){
  (*h)++;
  if(*h>=24){
    *h=0;
  }
}
void print_time(int m,int h){
  if(h<10)
    Serial.print('0');
  Serial.print(h);
  Serial.print(":");
  if(m<10)
    Serial.print('0');
  Serial.println(m);
}
void active_alarm(){
  alarm=true;
  digitalWrite(LED3,HIGH);
}
void deactive_alarm(){
  alarm=false;
  noTone(BUZZ);
  digitalWrite(LED3,LOW);
}
