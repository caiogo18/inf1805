Shoot = {};
Shoot.__index = Shoot;

function Shoot:create(x, y, vX, vY, delay, color)
	local shoot = {};
   	setmetatable(shoot, Shoot);
	shoot.x = x;			-- origem x, y
	shoot.y = y;
	shoot.vX = vX;			-- velocidade vX, vY
	shoot.vY = vY;
	shoot.delay = delay;	-- intervalo entre tiros
	shoot.atHand = true;	-- disponivel (no cartucho)
	shoot.color = color;
	shoot.name = "shoot";
	shoot.visible = true;
   	return shoot;
end

function Shoot:draw()
	-- desenhar tiros disparados
    if not self.atHand and self.visible then
		love.graphics.setColor(self.color["r"], self.color["g"], self.color["b"]);
    	love.graphics.circle('fill', self.x, self.y, 5);
    end
end

function Shoot:update()
	-- atualizar somente os tiros disparados
	if not self.atHand and self.visible then 
		self.x = self.x + self.vX;
		self.y = self.y + self.vY;
	end
end