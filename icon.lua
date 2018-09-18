Icon = Object:extend()

function Icon:new(x, y, image, fn)
	self.x = x
	self.y = y
	self.image = image
	self.width = 16
	self.height = 16
	self.pressable = true
	self.pressed = fn --or function() love.audio.play(sfx_beep) end
end

function Icon:update(dt)
	if checkCollision(self, mouse) and love.mouse.isDown(1) and self.pressable then
		self:pressed()
		self:timeOut()
	end

	if checkCollision(self, mouse) and love.mouse.isDown(2) and self.pressable then
		self:pressed()
		self:timeOut()
	end

end

function Icon:draw()
	love.graphics.setColor(0.8, 0.3, 0.6)
	love.graphics.rectangle("fill", self.x - 18, self.y - 18, self.width * 2 + 4, self.height * 2 + 4, 8, 8, 8)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", self.x - 18, self.y - 18, self.width * 2 + 4, self.height * 2 + 4, 8, 8, 8)

	if checkCollision(self, mouse) and self.pressable then
		love.graphics.setColor(1, 1, 1, 1)
	else
		love.graphics.setColor(0.2, 0.2, 0.2)
	end

	love.graphics.draw(self.image, self.x, self.y, 0, 2, 2, self.width/2, self.height/2)
	love.graphics.setColor(1, 1, 1, 1)
end

function Icon:timeOut()
	self.pressable = false
	Timer.after(0.2, function() self.pressable = true end)
end