local Utils = {};

Utils.levels = {
	["level1"] = {["enemies"] = 2, ["gun"] = 2, ["obstacles"] = 1},
	["level2"] = {["enemies"] = 3, ["gun"] = 3, ["obstacles"] = 2},
	["level3"] = {["enemies"] = 4, ["gun"] = 4, ["obstacles"] = 1}
};

Utils.normalize = function(x, y)
	local dist = math.sqrt(x * x + y * y);
	return x / dist, y / dist;
end

Utils.playerHit = function(obj1, obj2)                    -- obj1 == player shoot
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

Utils.enemyHit = function(obj1, obj2)                    -- obj1 == enemy shoot
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

return Utils;