Player = {};
Player.__index = Player;

function Player:create(x, y, vX, vY, gunX, gunY, shots)
	local player = {};
   	setmetatable(player, Player);
	player.x = x;				-- origem x, y
	player.y = y;
	player.vX = vX;  			-- velocidade do jogador vX, vY
	player.vY = vY;
	player.lives = 5;
	player.clock = 0;
	player.gunX = gunX;			-- velocidade do disparo gunX, gunY
	player.gunY = gunY;
	player.shots = shots;		-- numero de balas no cartucho
	player.cartridge = {};		-- cartucho ou pente de tiros
   	player.color = {["r"] = 0 , ["g"] = 0, ["b"] = 1};
   	player.name = "player";
   	player.shoot = nil;
   	return player;
end

function Player:load()						
	-- carregar o cartucho com as balas
	for i = 1, self.shots, 1 do
		local shoot = Shoot:create(self.x, self.y, self.gunX, self.gunY, 1.0, self.color);
		table.insert(self.cartridge, shoot);
	end
end

function Player:draw()
    -- desenhar jogador
    love.graphics.setColor(self.color["r"], self.color["g"], self.color["b"]);
    love.graphics.polygon("fill", self.x, self.y + 20, 
    							  self.x + 10, self.y, 
    							  self.x + 20, self.y + 20, 
    							  self.x + 10, self.y + 30);
    -- desenhar tiros disparados
    for i, shoot in ipairs(self.cartridge) do
		shoot:draw();		
  	end
end

function Player:move(up, down, left, right)			
	-- up
	if up then
		self.y = self.y - self.vY;
	-- down
	elseif down then
		self.y = self.y + self.vY;
	end
	-- left
	if left then
		self.x = self.x - self.vX;
	-- right
	elseif right then
	    self.x = self.x + self.vX;
	end
end

function Player:fire(shoot) -- corrotina p/ atirar; sincronizar disparos
    local co = coroutine.create(function() shoot.atHand = false end);
    if coroutine.status(co) == 'dead' then 
        co = coroutine.create(function() shoot.atHand = false end)
    end
    coroutine.resume(co);
end

function Player:update(dt)
	-- pressionar seta up
	if love.keyboard.isDown('up') then
		self:move(true, false, false, false);   
    -- pressionar seta down
    elseif love.keyboard.isDown('down') then
        self:move(false, true, false, false);
    end    
    -- pressionar seta left
    if love.keyboard.isDown('left') then
        self:move(false, false, true, false);
    -- pressionar seta right
    elseif love.keyboard.isDown('right') then
        self:move(false, false, false, true);
    end
    -- pressionar tecla 'space'
    self.clock = self.clock + dt
    if love.keyboard.isDown("space") then
    	for i, shoot in ipairs(self.cartridge) do
  			-- disparar tiro
  			if shoot.atHand then
  				if self.clock >= shoot.delay then
  					self.clock = 0;
  					shoot.x = self.x + 10;			-- atualizar posicao de disparo
  					shoot.y = self.y;
  					self.shots = self.shots - 1;	-- atualizar numero de balas
  					Player:fire(shoot); 			-- atirar    
  					self.shoot = shoot;
  				else
            coroutine.yield();
          end			
  				break;
  			end
		end
	end
    -- atualizar os tiros disparados
    for i, shoot in ipairs(self.cartridge) do
		shoot:update();		
  	end
end