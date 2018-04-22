require "scripts.shoot";
require "scripts.player";
require "scripts.enemy";
require "scripts.obstacle";

local utils = require("scripts.utils");
local width, height = love.graphics.getDimensions();

-- elementos da cena principal
local player;
local enemies = {};
local obstacles = {};
local level = 1;

function createLevel(level)
	--criar inimigos do level
  	local n = utils.levels[level]["enemies"];
  	local gun = utils.levels[level]["gun"];
  	local enems = {};
	local obsts = {};
  	for i = 1, n, 1 do
  		local enemy = Enemy:create(width * i / (n + 1), 0.1 * height, gun, gun, 200);
		enemy:load();
		table.insert(enems, enemy);
  	end
  	--criar obstaculos do level
  	local k = utils.levels[level]["obstacles"];
  	print(k)
  	for i = 1, k, 1 do
  		local obstacle = Obstacle:create((width * i / (k + 1)) - 40, 0.6 * height, 80, 50);
		table.insert(obsts, obstacle);
  	end
  	enemies = enems;
  	obstacles = obsts;
end

function love.load()
  	-- criar jogador
  	player = Player:create(width / 2, 0.8 * height, 4, 4, 0, -4.5, 500);
  	player:load();
  	-- criar level 1: inimigos e obstaculos
  	createLevel("level1");
end

function love.draw()
	-- desenhar jogador
	player:draw();
	-- desenhar inimigos
	for i, enemy in ipairs(enemies) do
  		enemy:draw();
  	end
  	-- desenhar obstaculos
  	for i, obstacle in ipairs(obstacles) do
  		obstacle:draw();
  	end
  	-- desenhar labels
  	love.graphics.setColor(255, 0, 0, 1);
  	love.graphics.print("Level: " .. level, 0.90 * width, 5);
  	love.graphics.print("Lives: " .. player.lives, 0.90 * width, 25);
  	love.graphics.print("Shots: " .. player.shots, 0.90 * width, 45);

  	-- se jogador estiver morto
  	if player.lives == 0 then
  		love.graphics.print("Game Over!", (width / 2) - 10, height / 2);
  	end

  	-- -- o jogador venceu
  	-- if level == 3 then
  	-- 	love.graphics.print("You win!", (width / 2) - 10, height / 2);
  	-- end
end

function love.update(dt)
	-- atualizar jogador
	player:update(dt);
	-- atualizar inimigos
  	for i, enemy in ipairs(enemies) do
  		local dirX, dirY = utils.normalize(player.x - enemy.x, player.y - enemy.y);
  		enemy:update(dt, dirX, dirY);
  	end
  	-- verificar colisao p/ tiro do jogador
  	for i, enemy in ipairs(enemies) do
  		if player.shoot and player.shoot.visible and player.lives > 0 then
  			if enemy.shoot and utils.playerHit(player.shoot, enemy.shoot) then
  				enemy.shoot.visible = false;
  				player.shoot.visible = false;
  			elseif utils.playerHit(player.shoot, enemy) then
  				enemy.visible = false;
  				enemy.lives = 0;
  			end
  		else
  		    break;
  		end
  	end	
  	-- verificar colisao p/ tiro do inimigo
  	for i, enemy in ipairs(enemies) do
  		if enemy.shoot and enemy.shoot.visible and player.lives > 0 then
  			if utils.enemyHit(enemy.shoot, player) then
  				player.lives = player.lives - 1;
  				enemy.shoot.visible = false;
  			elseif obstacles[1].visible and utils.enemyHit(enemy.shoot, obstacles[1]) then
  				obstacles[1].resistance = obstacles[1].resistance - 1;
  				enemy.shoot.visible = false;
  			elseif #obstacles == 2 and obstacles[2].visible and utils.enemyHit(enemy.shoot, obstacles[2]) then
  			    obstacles[2].resistance = obstacles[2].resistance - 1;
  				enemy.shoot.visible = false;
  			end
  		else
  		    break;
  		end
  	end
  	-- atualizar level
  	local t = 0;
  	for i, enemy in ipairs(enemies) do
  		if enemy.lives == 0 then
  			t = t + 1;
  		end
  	end
  	if t == #enemies and level < 3 then
  		level = level + 1;
  		createLevel("level"..level);	
  	end
  	-- atualiza obstaculos
  	for i, obst in ipairs(obstacles) do
  		if obst.resistance == 0 then
  			obst.visible = false;
  		end
  	end
end