require "scripts.shoot";
require "scripts.player";
require "scripts.enemy";
require "scripts.obstacle";
local utils = require("scripts.utils");

-- elementos da cena principal
local player;
local enemies = {};
local obstacles = {};
local level = 1;

function love.load()
  	-- criar jogador
  	player = Player:create(utils.width / 2, 0.8 * utils.height, 4, 4, 0, -4.5, 500);
  	player:load();
  	-- criar level 1: inimigos e obstaculos
  	enemies, obstacles = utils.createLevel("level1");
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
  	love.graphics.print("Level: " .. level, 0.90 * utils.width, 5);
  	love.graphics.print("Lives: " .. player.lives, 0.90 * utils.width, 25);
  	love.graphics.print("Shots: " .. player.shots, 0.90 * utils.width, 45);
  	-- quando o jogador perder
  	if player.lives == 0 then
  		love.graphics.print("Game Over!", (utils.width / 2) - 10, utils.height / 2);
  	end
end

function love.update(dt)
    -- atualizar level
    local lv = 0;
    for i, enemy in ipairs(enemies) do
      if enemy.lives == 0 then
        lv = lv + 1;
      end
    end
    if lv == #enemies and level < 3 then
      level = level + 1;
      enemies, obstacles = utils.createLevel("level"..level);
    end
    -- atualizar jogador
    player:update(dt);
    -- atualizar inimigos
  	for i, enemy in ipairs(enemies) do
  		local dirX, dirY = utils.normalize(player.x - enemy.x, player.y - enemy.y);
  		enemy:update(dt, dirX, dirY);
  	end  
    -- atualizar obstaculos
    for i, obst in ipairs(obstacles) do
      if obst.resistance == 0 then
        obst.visible = false;
      end
    end
  	-- verificar colisao p/ tiro do jogador
  	for i, enemy in ipairs(enemies) do
  		if player.shoot and player.shoot.visible and player.lives > 0 then
  			if enemy.shoot and enemy.shoot.visible and utils.playerHit(player.shoot, enemy.shoot) then
  				enemy.shoot.visible = false;
  				player.shoot.visible = false;
  			elseif enemy.visible and utils.playerHit(player.shoot, enemy) then
  				enemy.visible = false;
  				enemy.lives = enemy.lives - 1;
  			end
  		else
  		    break;
  		end
  	end	
  	-- verificar colisao p/ tiro do inimigo
  	for i, enemy in ipairs(enemies) do
  		if enemy.shoot and enemy.shoot.visible then
  			if player.lives > 0 and utils.enemyHit(enemy.shoot, player) then
  				player.lives = player.lives - 1;
  				enemy.shoot.visible = false;
  			elseif obstacles[1].visible and utils.enemyHit(enemy.shoot, obstacles[1]) then
  				enemy.shoot.visible = false;
          obstacles[1].resistance = obstacles[1].resistance - 1; 				
  			elseif #obstacles > 1 and obstacles[2].visible and utils.enemyHit(enemy.shoot, obstacles[2]) then
  			    enemy.shoot.visible = false;
            obstacles[2].resistance = obstacles[2].resistance - 1;
  			end
  		else
  		    break;
  		end
  	end
end