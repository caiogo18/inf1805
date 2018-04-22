local Utils = {
	width, 
	height, 
	enemies,
	obstacles
};

Utils.width, Utils.height = love.graphics.getDimensions();
Utils.enemies = {};
Utils.obstacles = {};

Utils.levels = { -- fases do jogo - podem ser customizadas de varias maneiras
	["level1"] = {["enemies"] = 2, ["gun"] = 2, ["obstacles"] = 1},
	["level2"] = {["enemies"] = 3, ["gun"] = 3, ["obstacles"] = 2},
	["level3"] = {["enemies"] = 4, ["gun"] = 4, ["obstacles"] = 1}
};

Utils.normalize = function(x, y) -- funcao p/ normalizar vetores 
	local dist = math.sqrt(x * x + y * y);
	return x / dist, y / dist;
end

Utils.playerHit = function(obj1, obj2)  -- obj1 == player shoot
										-- obj2 == enemy shoot or enemy
	-- colisao entre dois tiros
	if obj1.name == "shoot" and obj2.name == "shoot" then
		if obj1.x >= obj2.x - 10 and obj1.x <= obj2.x + 10 and obj1.y >= obj2.y - 10 and obj1.y <= obj2.y + 10 then
			return true;
		else
		    return false;
		end
	-- colisao entre o tiro e o inimigo
	elseif obj1.name == "shoot" and obj2.name == "enemy" then
	    if obj1.x >= obj2.x and obj1.x <= obj2.x + 30 and obj1.y >= obj2.y and obj1.y <= obj2.y + 20 then
	    	return true;
	    else
	        return false;
	    end   
	end
end

Utils.enemyHit = function(obj1, obj2)   -- obj1 == enemy shoot
										-- obj2 == player or obstacle
	-- colisao entre tiro e jogador
	if obj1.name == "shoot" and obj2.name == "player" then	
		if obj1.x >= obj2.x and obj1.x <= obj2.x + 20 and obj1.y >= obj2.y and obj1.y <= obj2.y + 30 then
			return true;
		else
		    return false;
		end
	-- colisao entre o tiro e o obstaculo
	elseif obj1.name == "shoot" and obj2.name == "obstacle" then
	    if obj1.x >= obj2.x and obj1.x <= obj2.x + obj2.width and obj1.y >= obj2.y and obj1.y <= obj2.y + obj2.height then
	    	return true;
	    else
	        return false;
	    end   
	end
end

Utils.createLevel = function(level) -- configurar determinado level
	-- limpar as tabelas
	Utils.enemies = {};
	Utils.obstacles = {};
	--criar inimigos
  	local num = Utils.levels[level]["enemies"];
  	local gunX = Utils.levels[level]["gun"];
  	for i = 1, num, 1 do
  		local enemy = Enemy:create(Utils.width * i / (num + 1), 0.1 * Utils.height, gunX, gunX, 200);
		enemy:load();
		table.insert(Utils.enemies, enemy);
  	end
  	--criar obstaculos
  	num = Utils.levels[level]["obstacles"];
  	for i = 1, num, 1 do
  		local obstacle = Obstacle:create((Utils.width * i / (num + 1)) - 40, 0.6 * Utils.height, 80, 50);
		table.insert(Utils.obstacles, obstacle);
  	end
  	return Utils.enemies, Utils.obstacles;
end

return Utils;