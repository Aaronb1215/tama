Object = require "classic"
peachy = require "peachy"
lume = require "lume"
Gamestate = require "hump.gamestate"
Timer = require "hump.timer"
Camera = require "hump.camera"

require "tama"
require "icon"
require "poop"

home = {}
hatchery = {}

width = love.graphics.getWidth()
height = love.graphics.getHeight()
	
love.graphics.setDefaultFilter("nearest", "nearest")
success = love.window.setMode(640, 480)

lightOn = true


function love.load()
	egg = love.graphics.newImage("sprites/egg.png")
	baby = love.graphics.newImage("sprites/baby.png")
	food = love.graphics.newImage("sprites/food.png")
	poop = love.graphics.newImage("sprites/poop.png")
	background = love.graphics.newImage("sprites/background.png")

	poops = {}
	icons = {}
	table.insert(icons, Icon(
		width/10 * 1, 48, 
		love.graphics.newImage("sprites/icons/fork.png"), 
		function()
			if mouseButton == "left" then
				tama:eat("cremepuff")
			else
				tama:eat("broccoli")
			end
			-- love.audio.play(sfx_beep)
		 end))
	table.insert(icons, Icon(
		width/10 * 3, 48,
		love.graphics.newImage("sprites/icons/ball.png"), 
		function()
			return
		 end))
	table.insert(icons, Icon(
		width/10 * 5, 48, 
		love.graphics.newImage("sprites/icons/discipline.png"), 
		function()
			return
		 end))
	table.insert(icons, Icon(
		width/10 * 7, 48, 
		love.graphics.newImage("sprites/icons/duck.png"), 
		function()
			love.audio.play(sfx_flush)
			while #poops >= 1 do
				table.remove(poops, 1)
			end
		 end))
	table.insert(icons, Icon(
		width/10 * 1, height/2 + 128, 
		love.graphics.newImage("sprites/icons/attention.png"), 
		function()
			return
		 end))
	table.insert(icons, Icon(
		width/10 * 3, height/2 + 128,
		love.graphics.newImage("sprites/icons/light.png"), 
		function()
			love.audio.play(sfx_light)
			if lightOn == true then lightOn = false else lightOn = true end
		 end))
	table.insert(icons, Icon(
		width/10 * 5, height/2 + 128, 
		love.graphics.newImage("sprites/icons/medicine.png"), 
		function()
			return
		 end))
	table.insert(icons, Icon(
		width/10 * 7, height/2 + 128, 
		love.graphics.newImage("sprites/icons/health.png"), 
		function()
			return
		 end))

	function icons:draw()
		for k,v in ipairs(self) do
			v:draw()
			-- love.graphics.rectangle("line", v.x, v.y, v.width, v.height)
		end
	end


	sfx_hatch = love.audio.newSource("sfx/hatch.wav", "stream")
	sfx_emerge = love.audio.newSource("sfx/emerge.wav", "stream")
	sfx_angry = love.audio.newSource("sfx/angry.wav", "stream")
	sfx_hurt = love.audio.newSource("sfx/hurt.wav", "stream")
	sfx_newborn = love.audio.newSource("sfx/newborn.wav", "stream")
	sfx_hatch = love.audio.newSource("sfx/hatch.wav", "stream")
	sfx_want = love.audio.newSource("sfx/want.wav", "stream")
	sfx_no = love.audio.newSource("sfx/no.wav", "stream")
	sfx_no = love.audio.newSource("sfx/no.wav", "stream")
	sfx_eat = love.audio.newSource("sfx/eat.wav", "stream")
	sfx_beep = love.audio.newSource("sfx/beep.wav", "stream")
	sfx_poop = love.audio.newSource("sfx/poop.wav", "stream")
	sfx_flush = love.audio.newSource("sfx/flush.wav", "stream")
	sfx_boing = love.audio.newSource("sfx/boing.wav", "stream")
	sfx_light = love.audio.newSource("sfx/light.wav", "stream")
	sfx_gameover = love.audio.newSource("sfx/gameover.mp3", "stream")

	camera = Camera(width/2, height/2)

	Gamestate.registerEvents()
	Gamestate.switch(hatchery)

end

function love.update(dt)
	mouse = {}
	mouse.x, mouse.y = love.mouse.getPosition()
	mouse.width = 10
	mouse.height = 10
	if love.mouse.isDown(1) == true then mouseButton = "left" end
	if love.mouse.isDown(2) then mouseButton = "right" end
	Timer.update(dt)
end

function love.draw()
end

function love.keypressed(key)
	tama:keypressed(key)
	if key == "escape" then
		love.event.quit()
	end
end

function home:enter()
	love.audio.stop()
	if tama.lifeStage == "egg" and tama.hatched then
		tama.lifeStage = "baby"
	end
	love.graphics.setBackgroundColor(0.6, 0.2, 0.6)
	-- tama = Tama(width/2, height/2)
	camera.scale = 3 
end

function home:update(dt)
	for k,v in ipairs(icons) do
		v:update(dt)
	end

	tama:update(dt)
end

function home:draw()
	camera:attach()

	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(background, background:getWidth(), background:getHeight(), 0, 0.5, 0.5)
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle("line", background:getWidth(), background:getHeight(), 
								background:getWidth()/2, background:getHeight()/2)
	love.graphics.setColor(1, 1, 1)

	lume.sort(poops, function(a, b) return a.y < b.y end)
	for k,v in ipairs(poops) do
		v:draw()
	end
	if not lightOn then
		love.graphics.setColor(0, 0, 0, 0.9)
		love.graphics.rectangle("fill", 0, 0, 3000, 3000)
		love.graphics.setColor(1, 1, 1)
	end
	tama:draw()


	camera:detach()
	love.graphics.print("health: " .. tama.health, 20, height/2 + 10)
	love.graphics.print("hunger: " .. tama.hunger, 20, height/2 - 20)
	love.graphics.print("fullness: " .. tama.full, 20, height/2 - 50)
	love.graphics.print("frame: " .. tama.baby:getFrame(), 20, height/2 - 80)
	love.graphics.print("mouse_x: " .. mouse.x, 20, height/2 - 110)
	love.graphics.print("mouse_y: " .. mouse.y, 20, height/2 - 140)
	local lightTest = "what"
	if lightOn then lightTest = "true" else lightTest = "false" end
	love.graphics.print("lightOn: " .. lightTest, 20, height/2 - 170)
	icons:draw()
end

function home:keypressed(key)
end

function hatchery:enter()
	love.graphics.setBackgroundColor(0.6, 0.3, 0.5)
	tama = Tama(width/2, height/2)
	camera.scale = 2
end

function hatchery:update(dt)
	if not tama.hatched then
		tama.egg:setSpeed(lume.lerp(tama.egg:getSpeed(), 10, 0.001))
	end

	if tama.egg:getSpeed() > 5 then
		tama:hatch()
		Timer.after(3, function() tama.lifeStage = "baby" Gamestate.switch(home) end)
	end

	tama:update(dt)
end

function hatchery:draw()
	camera:attach()

	love.graphics.setColor(1,1,1)
	for i=0,width/20 do
		for j=0, height/20 do
			love.graphics.circle("line", 20 * j, 20 * i, 2)
		end
	end
	tama:draw()
	camera:detach()
end

function hatchery:keypressed(key)
	if key == "space" and not tama.hatched then
		tama:hatch()
		Timer.after(3, function() tama.lifeStage = "baby" Gamestate.switch(home) end)
	end
end

function checkCollision(a, b)
	local a_left = a.x
	local a_right = a.x + a.width
	local a_top = a.y
	local a_bottom = a.y + a.height

	local b_left = b.x
	local b_right = b.x + b.width
	local b_top = b.y
	local b_bottom = b.y + b.height

	if a_right > b_left and 
	a_left < b_right and 
	a_bottom > b_top and 
	a_top < b_bottom then
		return true
	else
		return false
	end
end
