Enemy = {}
Enemy.__index = Enemy;

function Enemy:create(x, y, gunX, gunY, shots)
	local enemy = {};
   	setmetatable(enemy, Enemy);
   	enemy.x = x;				-- origem x, y
	enemy.y = y;
	enemy.clock = 0;
	enemy.lives = 1;
	enemy.gunX = gunX;			-- velocidade do disparo gunX, gunY
	enemy.gunY = gunY;
	enemy.shots = shots;		-- numero de balas no cartucho
	enemy.cartridge = {};		-- cartucho ou pente de tiros
   	enemy.color = {["r"] = 0 , ["g"] = 1, ["b"] = 0};
   	enemy.name = "enemy";
   	enemy.visible = true;
   	enemy.shoot = nil;
   	return enemy;
end

function Enemy:load()						
	-- carregar o cartucho com as balas
	for i = 1, self.shots, 1 do
		local shoot = Shoot:create(self.x + 15, self.y + 10, self.gunX * 0, self.gunY * 1, 3.5, self.color);
		table.insert(self.cartridge, shoot);
	end
end

function Enemy:draw()
	if self.visible then
		-- desenhar inimigo
		love.graphics.setColor(self.color["r"], self.color["g"], self.color["b"]);
    	love.graphics.polygon("fill", self.x, self.y,
    	 						      self.x + 30, self.y,
    	 						      self.x + 15, self.y + 20);

    	-- desenhar tiros disparados
    	for i, shoot in ipairs(self.cartridge) do
			shoot:draw();		
  		end
	end   
end

function Enemy:update(dt, dirX, dirY)       		-- direcao do disparo dirX, dirY
	if self.visible then
		-- atualizar os tiros disparados
    	for i, shoot in ipairs(self.cartridge) do
			shoot:update();		
  		end
  		-- atirar
  		self.clock = self.clock + dt
    	for i, shoot in ipairs(self.cartridge) do
  			-- disparar tiro
  			if shoot.atHand then
  				if self.clock >= shoot.delay then
					self.clock = 0;
  					shoot.vX = self.gunX * dirX;	-- atualizar a direcao de disparo
  					shoot.vY = self.gunY * dirY;
  					self.shots = self.shots - 1;	-- atualizar numero de balas
  					shoot.atHand = false; 			-- atirar			
  					self.shoot = shoot;
  				end
  				break;
  			end
		end	
	end
end