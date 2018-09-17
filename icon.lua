Icon = Object:extend()

function Icon:new(x, y, image, fn)
	self.x = x
	self.y = y
	self.image = image
	self.width = 16
	self.height = 16
	self.pressed = fn or function() love.audio.play(sfx_hurt) end
end

function Icon:update(dt)
	if checkCollision(self, mouse) and love.mouse.isDown(1) then
		self:pressed()
	end
end

function Icon:draw()
	love.graphics.setColor(0.8, 0.3, 0.6)
	love.graphics.rectangle("fill", self.x - 18, self.y - 18, self.width * 2 + 4, self.height * 2 + 4)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", self.x - 18, self.y - 18, self.width * 2 + 4, self.height * 2 + 4)
	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(self.image, self.x, self.y, 0, 2, 2, self.width/2, self.height/2)
end
