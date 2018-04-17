
function newblip (posy,velm,velt,dir)
  local x, y = 0, posy
  local function wait(self)
    self.isactiveafter=os.clock()+velm/100
    coroutine.yield()
  end
  return {
    update = coroutine.wrap(function (self)
        while(true) do
          local width, height = love.graphics.getDimensions( )
          if dir==1 then
            x = x+10
            if x > width then
                -- volta para a esquerda da janela
              x = 0
            end
          else
            x = x-10
            if x < 0 then
                -- volta para a esquerda da janela
              x = width
            end
          end
          if math.random(20)==1 then
            listashoots.enemy[#listashoots.enemy+1]=newshoot_enemy(x,y,velt)
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
    isactiveafter=0
  }
end
function newshoot_enemy (posx,posy,vel)
  local x, y = posx, posy
  local function wait(self)
    self.isactiveafter=os.clock()+vel/50
    coroutine.yield()
  end

  return {
    update = coroutine.wrap(function (self)
      while(true) do
        local width, height = love.graphics.getDimensions( )
        y = y+10
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
    self.isactiveafter=os.clock()+1/vel
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
              if(math.random(20)==1) then
                listabuff[#listabuff+1]=new_item(x,y,'fast')
              end
              table.remove(listabls,i)
              dead=true
              break
            end
          end
          for i in ipairs(listabls) do
            if listabls[i].affected(x,y) then
              table.remove(listabls,i)
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
  local movbuff=0
  local buffduration=0
  local function wait(self)
    self.isactiveafter=os.clock()+vel/(20+movbuff)
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
        listashoots.friendly[#listashoots.friendly+1]=newshoot_friendly(x+10,y,50)
        shoot_delay=os.clock()+vel/6
      end
      check_over()
      wait(self)
    end
  end),
  draw = function ()
    --love.graphics.setColor(0,0,1)
    love.graphics.polygon('fill', x, y+20, x+10, y, x+20, y+20, x+10, y+30) 
  end,
  apply_buff = function (buff)
    reset_buff()
    if buff=='fast' then
      movbuff=20
    end
    buffduration=os.clock()+30
  end,
  isactiveafter=0
  }
end
function new_wave()
  level=level+1
  aux=200/level
  for j = 1 , level do
    for i = 1, 5 do
      listabls[i+5*(j-1)] = newblip((j-1)*aux,math.random(10),math.random(10),math.random(2))
    end
  end
end

function new_item(posx,posy,buff)
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
          player.apply_buff(buff)
          remove_shoot(self,listabuff)
        elseif y > height then
          remove_shoot(self,listabuff)
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
function love.load()
  player =  newplayer(1)
  listabls = {}
  listashoots={}
  listashoots.friendly={}
  listashoots.enemy={}
  listabuff={}
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
  for i = 1,#listabuff do
    listabuff[i].draw()
  end
  local width, height = love.graphics.getDimensions( )
  --love.graphics.setColor(1,1,1)
  love.graphics.line(0,200,width,200)
  love.graphics.print("Level: " .. level, width-60, height-40)
  if(life>=0) then
    love.graphics.print("Life: " .. life, width-60, height-20)
  else
    love.graphics.print("Game Over!" , width/2, height/2,0,2,2)
    love.timer.sleep(1)
  end
end

function love.update(dt)
  if os.clock()>player.isactiveafter then
    player:update()
  end
  for i = 1,#listabls do
    if os.clock()>listabls[i].isactiveafter then
      listabls[i]:update()
    end
  end
  for i = 1,#listashoots.enemy do
    if listashoots.enemy[i] then --bug
      if os.clock()>listashoots.enemy[i].isactiveafter then
        listashoots.enemy[i]:update()
      end
    end
  end
  for i = 1,#listashoots.friendly do
    if listashoots.friendly[i] then --bug
      if os.clock()>listashoots.friendly[i].isactiveafter then
        listashoots.friendly[i]:update()
      end
    end
  end
  for i = 1,#listabuff do
    if listabuff[i] then --bug
      if os.clock()>listabuff[i].isactiveafter then
        listabuff[i]:update()
      end
    end
  end
  if #listabls == 0 then
    listashoots.friendly={}
    listashoots.enemy={}
    listabuff={}
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

