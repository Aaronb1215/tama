Tama = Object:extend()

function Tama:new(x, y)
	self.x = x
	self.y = y
	self.speed = 300 
	self.width = 32
	self.height = 32
	self.hatched = false
	self.lifeStage = "egg"
	self.filter = function() 
					return "slide" 
					end


	self.egg = peachy.new("sprites/egg.json", egg, "Idle")
	self.baby = peachy.new("sprites/baby.json", baby, "Yes")
	self.food = peachy.new("sprites/food.json", food, "cremepuff")
	self.eating = false

	self.hunger = 10
	self.time = 0
end

function Tama:update(dt)
	local x = 0
	local y = 0

	destination = {}
	destination.width = self.width
	destination.height = self.height


	destination.x = self.x + x * (self.speed * dt)
	destination.y = self.y + y * (self.speed * dt)

	self.egg:update(dt)
	self.baby:update(dt)
	if self.eating then
		self.food:update(dt)
	end

	if self.time < 1000 then
		self.time = self.time + 1
	elseif self.time >= 1000 then
		self.time = 0
		self:tick()
	end
end

function Tama:draw()
	if self.lifeStage == "egg" then
		self.egg:draw(self.x, self.y, 0, 1, 1, self.egg:getWidth()/2, self.egg:getHeight()/2)
	elseif self.lifeStage == "baby" then
		self.baby:draw(self.x, self.y, 0, 1, 1, self.baby:getWidth()/2, self.baby:getHeight()/2)
	end

	if self.eating then
		self.food:draw(self.x + 16, self.y + 8, 0, 1, 1, self.food:getWidth()/2, self.food:getHeight()/2)
	end

	
end

function Tama:keypressed(key)
	if key == "space" and self.lifeStage == "baby" and not self.eating then
		self:eat() --Todo: Add a button in-game for doing this instead.
	end
end

function Tama:hatch()
		self.egg:setSpeed(1)
		self.egg:setTag("Hatch")
		Timer.after(0.3, function() love.audio.play(sfx_hatch) end)
		Timer.after(0.6, function() self.egg:setTag("Emerge") love.audio.play(sfx_emerge) end)
		Timer.after(0.6, function() self.egg:setTag("Wobble") love.audio.play(sfx_newborn) end)
		self.hatched = true
end

function Tama:eat()
	--Todo: Add food type parameter, vary effect based on how healthy.
	if self.hunger >= 10 then
		self.baby:setTag("TurnRight")
		Timer.after(0.6, function() 
				self.eating = true 
				self.baby:setTag("Eat") 
				self.food:setFrame(1) 
				self.food:play()

				Timer.during(5, function()
						if self.eating then
							if self.baby:getFrame() == 4 then
								love.audio.play(sfx_eat)
							end
						end
					end)
			end)

		Timer.after(3.8, function() 
				self.eating = false
				self.baby:setTag("Yes")
				self.hunger = self.hunger - 10
			end)
	elseif self.hunger < 10 then
		self.baby:setTag("No")
		love.audio.play(sfx_no)
		Timer.after(0.6, function() self.baby:setTag("Yes") love.audio.stop() end)
	end
end

function Tama:tick()
	self.hunger = self.hunger + 10
end