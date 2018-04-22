LISPUP={'mov','shoot'}
function newblip (posx,posy,velm,velt)
  local x,y=posx,posy
  local function wait(self)
    self.isactiveafter=os.clock()+velm
    coroutine.yield()
  end
  return {
    update = coroutine.wrap(function (self)
        while(true) do
          local width, height = love.graphics.getDimensions( )
          if math.random(20)==1 then
            plx,ply=player.try()
            shootx,shooty=normalize(plx-(x+5),ply-(y+10))
            listashoots.enemy[#listashoots.enemy+1]=newshoot_enemy(x+5,y+10,velt,10*shootx,10*shooty)
          end
          wait(self)
        end
      end),
    affected = function (posx,posy)
      if posx>x-5 and posx<x+20 and posy>y-5 and posy<y+20 then
      -- "pegou" o blip
        return true
      else
        return false
      end
    end,
    draw = function ()
      --love.graphics.setColor(0,1,0,1)
      love.graphics.polygon("fill", x,y,x+10,y,x+5,y+10)
    end,
    die = function (pos)
      table.remove(listabls,pos)
      if true then
        listaPUP[#listaPUP+1]=new_powerup(x,y,LISPUP[1])
        
      end
    end,
    isactiveafter=0
  }
end
function newshoot_enemy (posx,posy,vel,nx,ny)
  local x, y = posx, posy
  local function wait(self)
    self.isactiveafter=os.clock()+vel
    coroutine.yield()
  end

  return {
    update = coroutine.wrap(function (self)
      while(true) do
        local width, height = love.graphics.getDimensions( )
        y = y + ny
        x = x + nx
        xpl,ypl=player.try()
        if(x>=xpl and x<=xpl+20 and y>=ypl and y<=ypl+35) then
          life=life-1
          remove_shoot(self,listashoots.enemy)
        elseif y > height then
          remove_shoot(self,listashoots.enemy)
        end
        wait(self)
      end
    end),
    draw = function()
      --love.graphics.setColor(1, 0, 0)
      love.graphics.circle('fill',x,y,5)
    end,
    affected = function(posx,posy)
      if posx>x-10 and posx<x+10 and posy>y-10 and posy<y+10 then
      -- "pegou" o tiro
        return true
      else
        return false
      end
    end,
    isactiveafter=0
  }
end
function newshoot_friendly (posx,posy,vel)
  local x, y = posx, posy
  local function wait(self)
    self.isactiveafter=os.clock()+vel
    coroutine.yield()
  end

  return {
    update = coroutine.wrap(function (self)
      while(true) do
        local width, height = love.graphics.getDimensions( )
        dead=false
        y = y-10
        if y < 0 then
          remove_shoot(self,listashoots.friendly)
        else
          for i in ipairs(listabls) do
            if listabls[i].affected(x,y) then
              listabls[i].die(i)
              dead=true
              break
            end
          end
          if(dead) then
            remove_shoot(self,listashoots.friendly)
          else
            for i in ipairs(listashoots.enemy) do
              if listashoots.enemy[i].affected(x,y) then
                table.remove(listashoots.enemy,i)
                remove_shoot(self,listashoots.friendly)
                break
              end
            end
          end
        end
        if y < 0 then
          remove_shoot(self,listashoots.friendly)
        end
        wait(self)
      end
    end),
    draw = function()
      --love.graphics.setColor(0, 0, 1)
      love.graphics.circle('fill',x,y,5)
    end,
    isactiveafter=0
  }
end
function newplayer (vel)
  local width, height = love.graphics.getDimensions( )
  local x, y = (width/2)-15,2*height/3
  local shoot_delay=0
  local movPup=0
  local buffduration=0
  local function wait(self)
    self.isactiveafter=os.clock()+vel/(1+movPup)
    coroutine.yield()
  end
  local function move(x1,y1)
    if x+x1 < width-30 and x+x1 >0 then
      x = x + x1
    end
    if y+y1 < height-20 and y+y1 >190 then
      y= y + y1
    end
  end
  local function reset_buff()
    movbuff=0
  end
  local function check_over()
    if os.clock()>buffduration then
      reset_buff()
    end
  end
  return {
  try = function ()
    return x,y
  end,
  update = coroutine.wrap(function (self)
    while(true) do
      if love.keyboard.isDown('up') then
        move(0,-10)
      elseif love.keyboard.isDown('down') then
        move(0,10)
      end
      if love.keyboard.isDown('right') then
        move(10,0)
      elseif love.keyboard.isDown('left') then
        move(-10,0)
      end
      if love.keyboard.isDown('x') and shoot_delay<os.clock() then
        listashoots.friendly[#listashoots.friendly+1]=newshoot_friendly(x+10,y,vel/2)
        shoot_delay=os.clock()+10*vel
      end
      check_over()
      wait(self)
    end
  end),
  draw = function ()
    --love.graphics.setColor(0,0,1)
    love.graphics.polygon('fill', x, y+20, x+10, y, x+20, y+20, x+10, y+30) 
  end,
  apply_PUP = function (pup)
    reset_buff()
    if pup=='mov' then
      movPup=1
    end
    buffduration=os.clock()+30
  end,
  isactiveafter=0
  
  }
end
function new_powerup(posx,posy,pup)
  local x, y = posx, posy
  local function wait(self)
    self.isactiveafter=os.clock()+0.01
    coroutine.yield()
  end

  return {
    update = coroutine.wrap(function (self)
      while(true) do
        local width, height = love.graphics.getDimensions( )
        y = y+1
        xpl,ypl=player.try()
        if(x>=xpl and x<=xpl+20 and y>=ypl and y<=ypl+35) then
          print(pup)
          player.apply_PUP(pup)
          remove_shoot(self,listaPUP)
        elseif y > height then
          remove_shoot(self,listaPUP)
        end
        wait(self)
      end
    end),
    draw = function()
      --love.graphics.setColor(1, 1, 1)
      love.graphics.polygon('fill',x,y+5,x+5,y,x+5,y+10,x+10,y+5)
    end,
    isactiveafter=0
  }
end
function new_wave()
  local width, height = love.graphics.getDimensions( )
  level=level+1
  auxx=width/9
  enemies=2*level+2
  auxy=200/((enemies/5)+1)
  local j=0
  while enemies>0 do
    if enemies>5 then
      for  i = 1, 5 do
        listabls[i+5*j] = newblip(2*(i-1)*auxx+auxx/2,(j+1)*auxy,0.5,0.04)
      end
    else
      for  i = 1, enemies do
        listabls[i+5*j] = newblip(2*(i-1)*auxx+auxx/2,(j+1)*auxy,0.5,0.04)
      end
    end
    enemies=enemies-5
    j=j+1
  end
end

function love.load()
  player =  newplayer(0.04)
  listabls = {}
  listashoots={}
  listashoots.friendly={}
  listashoots.enemy={}
  listaPUP={}
  life=3
  level=0
  new_wave()
end

function love.draw()
  player.draw()
  for i = 1,#listabls do
    listabls[i].draw()
  end
  for i = 1,#listashoots.enemy do
    listashoots.enemy[i].draw()
  end
  for i = 1,#listashoots.friendly do
    listashoots.friendly[i].draw()
  end
  for i = 1,#listaPUP do
    listaPUP[i].draw()
  end
  local width, height = love.graphics.getDimensions( )
  --love.graphics.setColor(1,1,1)
  aux=width/9
  for i=1,4 do
    love.graphics.line(aux*(2*(i-1)+1),3*height/4,aux*(2*i),3*height/4)
  end
  love.graphics.print("Level: " .. level, width-60, 0)
  if(life>=0) then
    love.graphics.print("Life: " .. life, width-60, 20)
  else
    love.graphics.print("Game Over!" , width/2, height/2,0,2,2)
    love.timer.sleep(1)
  end
end

function love.update(dt)
  time=os.clock()
  if time>player.isactiveafter then
    player:update()
  end
  for i = 1,#listabls do
    if time>listabls[i].isactiveafter then
      listabls[i]:update()
    end
  end
  for i = 1,#listashoots.enemy do
    if listashoots.enemy[i] then --bug
      if time>listashoots.enemy[i].isactiveafter then
        listashoots.enemy[i]:update()
      end
    end
  end
  for i = 1,#listashoots.friendly do
    if listashoots.friendly[i] then --bug
      if time>listashoots.friendly[i].isactiveafter then
        listashoots.friendly[i]:update()
      end
    end
  end
  for i = 1,#listaPUP do
    if listaPUP[i] then --bug
      if time>listaPUP[i].isactiveafter then
        listaPUP[i]:update()
      end
    end
  end
  if #listabls == 0 then
    listashoots.friendly={}
    listashoots.enemy={}
    new_wave()
  end
end
function remove_shoot(shoot,lista)
  for i in ipairs(lista) do
    if lista[i]==shoot then
      table.remove(lista,i)
      return
    end
  end
end
function normalize(x,y)
  local dist= math.sqrt(x*x+y*y)
  return x/dist,y/dist
 end 