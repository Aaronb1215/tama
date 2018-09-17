Poop = Object:extend()

function Poop:new(x, y)
	self.x = x
	self.y = y
	self.image = poop
	self.width = 16
	self.height = 16
end

function Poop:update(dt)
end

function Poop:draw()
	love.graphics.draw(self.image, self.x, self.y, 0, 1, 1, self.width/2, self.height/2)
end