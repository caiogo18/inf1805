Obstacle = {};
Obstacle.__index = Obstacle;

function Obstacle:create(x, y, width, height)
	local obst = {};
   	setmetatable(obst, Obstacle);
	obst.x = x;					-- origem x, y (top-left corner)
	obst.y = y;
	obst.width = width;			-- dimensoes width e height 
	obst.height = height;
	obst.resistance = 4; 
	obst.color = {["r"] = 0 , ["g"] = 255, ["b"] = 255};
	obst.visible = true;
	obst.name = "obstacle";
   	return obst;
end

function Obstacle:draw()
	if self.visible then
		love.graphics.setColor(self.color["r"], self.color["g"], self.color["b"]);
		love.graphics.rectangle("fill", self.x, self.y, self.width, self.height);
	end
end