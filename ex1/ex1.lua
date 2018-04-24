--caio gonçalves feiertag 1510590
STOP_TIMER=500
led1 = 3
led2 = 6
sw1 = 1
sw2 = 2
vel=1000
b1state=false
b2state=false
local mytimerpisca = tmr.create()
local mytimerbotao1 = tmr.create()
local mytimerbotao2 = tmr.create()
--pinos de leds são de saída
gpio.mode(led1, gpio.OUTPUT)
gpio.mode(led2, gpio.OUTPUT)
--apaga os leds
gpio.write(led1, gpio.LOW);
gpio.write(led2, gpio.LOW);
gpio.mode(sw1,gpio.INT,gpio.PULLUP)
gpio.mode(sw2,gpio.INT,gpio.PULLUP)
ledstate = false
--callback da interrupção botao1
local function pincb1(level, timestamp)
  vel=vel*0.9
  if b2state==true then
    mytimerpisca:stop()
    gpio.write(led1, gpio.HIGH);
  else
    b1state=true
    mytimerbotao1:register(STOP_TIMER,tmr.ALARM_SINGLE,function() b1state=false end)
    mytimerbotao1:start()
  end
end
--callback da interrupção botao2
local function pincb2(level, timestamp)
  vel=vel*1.1
  if b1state==true then
    mytimerpisca:stop()
    gpio.write(led1, gpio.HIGH);
  else
    b2state=true
    mytimerbotao2:register(STOP_TIMER,tmr.ALARM_SINGLE,function() b2state=false end)
    mytimerbotao2:start()
  end
end

local function pisca()
  ledstate =  not ledstate
  if ledstate then  
    gpio.write(led1, gpio.HIGH);
  else
    gpio.write(led1, gpio.LOW);
  end
  mytimerpisca:register(vel, tmr.ALARM_SINGLE, pisca)
  mytimerpisca:start()
end
--registrar tratamento para botoes

gpio.trig(sw1, "down", pincb1)
gpio.trig(sw2, "down", pincb2)

-- oo calling
mytimerpisca:register(vel, tmr.ALARM_SINGLE, pisca)
mytimerpisca:start()