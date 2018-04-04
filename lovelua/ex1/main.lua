--Caio Gonçalves Feiertag 1510590
function retangulo (x,y,w,h)
  local originalx, originaly, rx, ry, rw, rh = x, y, x, y, w, h
  local function naimagem (mx, my)
    return (mx>rx) and (mx<rx+rw) and (my>ry) and (my<ry+rh)
  end
  return {
    draw =function ()
      love.graphics.rectangle("line", rx, ry, rw, rh)
    end,
    keypressed =function (key)
      local mx, my = love.mouse.getPosition()
      if naimagem (mx,my) then
        if key == 'b'  then
          ry = originaly
          rx = originalx
        elseif key=="down"  then
          ry = ry + 10
        elseif key=="right" then
          rx = rx + 10
        elseif key=="up"    then
          ry = ry - 10
        elseif key=="left"  then
          rx = rx - 10
        end
      end
    end
  }
end
function love.load()
  --faz 2 fileiras de retangulo
  vret={}
  for i=1, 4 do
    vret[i]=retangulo (0+(i-1)*200, 100, 200, 150);
  end
  for i=1, 4 do
    vret[i+4]=retangulo (0+(i-1)*200, 300, 200, 150);
  end
end
function love.keypressed(key)
  --chama keypressed de todos os retangulos, entao em interseçoes todos na interseçao movem
  for i=1, #vret do
    vret[i].keypressed(key)
  end
end
function love.draw ()
  -- desenha todos os retangulos
  for i=1, #vret do
    vret[i].draw()
  end
end