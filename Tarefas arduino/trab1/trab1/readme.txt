Caio Gonçalves Feiertag 1510590
Projeto 1: Relógio Despertador com Arduíno e placa multifunção

Mecanismos Básicos do relógio:
-Adicionar hora/minuto do relógio ou despertador
-Ligar/Desligar Alarme
-Tocar alarme
-Trocar de modo

Como usar:
O relógio possui 3 modos, onde:

No primeiro modo(modo=0), você consegue ver o horário do relógio e ativar o alarme com o botão 1 ou desativar com o botão 2,
o botão 3 colocará o relógio no próximo modo
A led1 acende indicando que está no modo 0, e o led4 acende quando você armar o alarme;

No segundo modo(modo=1), você consegue ver o horário do relógio e modificá-lo, botão 1 acrescentará minutos e o botão 2 horas, 
o botão 3 colocará o relógio no próximo modo
A led2 acende indicando que está no modo 1;

No terceiro modo(modo=2), você consegue ver o horário do alarme e modificá-lo, botão 1 acrescentará minutos e o botão 2 horas, 
o botão 3 colocará o relógio no próximo modo(modo=0)
A led3 acende indicando que está no modo 2;

O horário atualiza a cada minuto, o alarme irá tocar quando o horário do relógio for o mesmo que o do alarme;

O horário do relógio e do alarme começarão 00:00 por padrão.

Mecanismos extras:
-Soneca
-Avanço rápido da hora/minuto

Como usá-los:

Quando o alarme estiver tocando, o relógio estará no modo 0, é possível apertar o botão 1 novamente e o horário do alarme atualizará para +5 minutos,
o botão 2 servirá somente para desativar o alarme, esteja ele tocando ou não;

Nos modos 1 e 2, onde você pode modificar o horário, há um mecanismo onde quando se mantém pressionado os botões 1 ou 2, o avanço dos minutos ou do horário contam, 
cada vez mais rápido, ou seja, há um mecanismo que acelera a atualização do horário. Foi colocado uma velocidade máxima, pois seria difícil acompanhar o horário.

	