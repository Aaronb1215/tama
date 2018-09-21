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
	self.mode = "idle"

	self.hunger = 0
	self.full = 0
	self.time = 0
	self.health = 100
	self.energy = 100
	self.happiness = 50

	Timer.every(10, function() 
						if self.mode == "idle" and self.health >= 50 and self.energy >= 30 then
							self.baby:setTag("Yes")
						end
					end)
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
	if self.mode == "eating" then
		self.food:update(dt)
	end



	if self.time < 100 and self.mode ~= "dead" then
		self.time = self.time + 1
	elseif self.time >= 100 and self.mode == "idle" or self.mode == "sleeping" then
		self.time = 0
		self:tick()
	end

	if self.mode == "idle" and self.health > 50 and self.energy > 30 and self.happiness > 40 then
		self.baby:setTag("Yes")
	elseif self.mode == "idle" and self.health < 50 then
		self.baby:setTag("Unhappy")
	elseif self.mode == "idle" and self.energy < 30 then
		self.baby:setTag("Tired")
	elseif self.mode == "idle" and self.happiness <= 20 then
		self.baby:setTag("Angry")
	elseif self.mode == "idle" and self.happiness < 40 and self.happiness > 20 then
		self.baby:setTag("Depressed")
	end


end

function Tama:draw()
	if not lightOn then
		love.graphics.setColor(0.2, 0.2, 0.6)
	else
		love.graphics.setColor(1, 1, 1)
	end
	if self.lifeStage == "egg" then
		self.egg:draw(self.x, self.y, 0, 1, 1, self.egg:getWidth()/2, self.egg:getHeight()/2)
	elseif self.lifeStage == "baby" then
		self.baby:draw(self.x, self.y, 0, 1, 1, self.baby:getWidth()/2, self.baby:getHeight()/2)
	end

	if self.mode == "eating" then
		self.food:draw(self.x + 16, self.y + 8, 0, 1, 1, self.food:getWidth()/2, self.food:getHeight()/2)
	end

	for i=1,self.hunger do
		love.graphics.setColor(1, 1, 1, 0.3)
		love.graphics.rectangle("fill", self.x - self.width/2 + 2 * i, self.y + self.height + 20, 1, 4)
		love.graphics.setColor(1, 1, 1, 1)
	end
	love.graphics.setColor(1, 1, 1, 1)

end

function Tama:keypressed(key)
	if key == "space" and self.lifeStage == "baby" and self.mode == "idle" then
		self:eat("broccoli") --Todo: Add a button in-game for doing this instead.
	end

	if key == "up" then 
		self.full = self.full + 30
	end

	if key == "down" then 
		self.health = self.health - 10
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

function Tama:eat(type)
	if self.mode ~= "idle" then return end
	--Todo: Add food type parameter, vary effect based on how healthy.
	local food = type or "cremepuff"
	if self.hunger >= 1 and self.lifeStage ~= "egg" and self.mode == "idle" then
		self.baby:setTag("TurnRight")
		Timer.after(0.6, function() 
				self.mode = "eating" 
				self.baby:setTag("Eat") 
				self.food:setTag(food)
				self.food:setFrame(1) 
				self.food:play()

				Timer.during(5, function()
						if self.mode == "eating" then
							if self.baby:getFrame() == 4 then
								love.audio.play(sfx_eat)
							end
						end
					end)
			end)

		Timer.after(3.7, function() 
				self.mode = "idle"
				self.baby:setTag("Yes")
				if food == "cremepuff" then
					self.hunger = self.hunger - 5
					self.full = self.full + 5
					self.health = self.health - 5
					self:react("Happy")
					self.happiness = self.happiness + 5
				elseif food == "broccoli" then
					self.hunger = self.hunger - 10
					self.full = self.full + 10
					if self.health < 95 then
						self.health = self.health + 5
					else
						self.health = 100
					end
					self:react("Annoyed")
					self.happiness = self.happiness - 5
				end
			end)
	elseif self.hunger < 1 then
		self.baby:setTag("No")
		love.audio.play(sfx_no)
		Timer.after(0.6, function() self.baby:setTag("Yes") love.audio.stop() end)
	end
end

function Tama:poop()
	self.mode = "pooping"
	self.baby:setTag("Poop")

	Timer.during(3, function()
						if self.mode == "pooping" then
							if self.baby:getFrame() == 9 then
								self.mode = "idle"
								self.baby:setTag("Yes")
								love.audio.play(sfx_poop)
								local newPoop = Poop(self.x + love.math.random(-50, 50), self.y + love.math.random(-5, 20))
								table.insert(poops, newPoop)
								if newPoop.x - self.x >= 0 then newPoop.x = newPoop.x + 20 end
								if newPoop.x - self.x < 0 then newPoop.x = newPoop.x - 20 end
								self.full = self.full - 15
							end
						end
					end)
	Timer.after(4, function() if self.mode == "pooping" then self.mode = "idle" end end)
end

function Tama:die()
	while #icons >= 1 do
		table.remove(icons, 1)
	end

	self.mode = "dead"
	self.baby:setTag("Death")
	Timer.during(5, function() if self.baby:getFrame() == self.baby:getLastFrame() then self.baby:stop(true) end end)
	Timer.after(3, function() love.audio.play(sfx_gameover) end)
	Timer.after(4, function() Timer.during(20, function() camera.scale = camera.scale * 0.999 end) end)
	Timer.after(31, function() lightOn = false end)
	Timer.after(34, function () Timer.during(5, function() love.audio.setVolume(love.audio.getVolume() - 0.01) end) end)
	Timer.after(36, function() love.event.quit() end)
end

function Tama:react(reaction)
	if self.mode == "idle" then
		self.mode = "reacting"
		local currentTag = self.baby:getTag()
		Timer.during(1.5, function() if reaction ~= currentTag then self.baby:setTag(reaction) end end)
		Timer.after(1.5, function() self.baby:setTag(currentTag) self.mode = "idle" end)
	else
		return
	end
end

function Tama:tick()
	
	if self.hunger < 100 then
		self.hunger = self.hunger + 1
	end

	if self.mode ~= "sleeping" and lightOn then
		self.energy = self.energy - 1
	elseif self.mode ~= "sleeping" and not lightOn then
		self.energy = self.energy - 5
	end

	if self.energy < 50 and self.mode == "idle" and not lightOn then
		self.mode = "sleeping"
		self.baby:setTag("Sleep")
	end

	if self.energy < 20 and self.mode == "idle" and lightOn then
		self.mode = "sleeping"
		self.baby:setTag("Sleep")
	end

	if self.mode == "sleeping" and lightOn then
		self.energy = self.energy + 4
	elseif self.mode == "sleeping" and not lightOn then
		self.energy = self.energy + 8
	end

	if self.energy >= 100 and self.mode == "sleeping" then 
		self.mode = "idle"
		love.audio.play(sfx_light)
		lightOn = true
		Timer.after(1, function() self.baby:setTag("Yes") self:react("Happy") end)
		end

	if self.energy >= 30 and self.mode == "sleeping" and lightOn then 
		self.mode = "idle" 
		self:react("Annoyed") 
	end

	if self.full > 10 and self.mode == "idle" then
		if math.floor(love.math.random(1, 3)) == 2 then
			self:poop()
		end
	end

	local previousHealth = self.health
	--Health downs.
	self.health = self.health - #poops
	if self.hunger > 50 then self.health = self.health - 1 end
	if self.hunger > 70 then self.health = self.health - 1 end
	if self.hunger > 90 then self.health = self.health - 1 end
	if self.hunger == 100 then
		-- self.mode = "starving" --TODO: Implement starving.
		return
	end

	if self.energy < 40 then self.health = self.health - 1 end
	if self.happiness < 0 then self.health = self.health - 1 end

	--Health ups.
	if self.health < 100 then
		if self.hunger > 30 then self.health = self.health + 1 end
		if #poops == 0 then self.health = self.health + 1 end
	end

	if self.mode == "sleeping" then self.health = self.health + 2 end

	--Happiness--
	if self.health < 50 then self.happiness = self.happiness - 1 end
	if self.energy < 50 then self.happiness = self.happiness - 1 end
	if self.mode == "idle" and not lightOn then self.happiness = self.happiness - 1 end
	if self.mode == "sleeping" and lightOn then self.happiness = self.happiness - 1 end
	if #poops > 0 then self.happiness = self.happiness - 2 end



	--DEATH TRIGGER--
	if self.health <= 0 then
		self:die()
		Timer.during(3, 
			function() 
				if self.mode == "dead" and self.baby:getFrame() == 6 then 
					love.audio.play(sfx_want) 
				end 
			end)
		-- love.audio.play(sfx_want)
	end

	if self.mode == "idle" and self.health < previousHealth then self:react("Annoyed") love.audio.play(sfx_hurt) end
end