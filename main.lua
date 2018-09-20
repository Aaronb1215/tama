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
play = {}

width = love.graphics.getWidth()
height = love.graphics.getHeight()
	
love.graphics.setDefaultFilter("nearest", "nearest")
success = love.window.setMode(640, 480)

lightOn = true
devMode = false


function love.load()
	egg = love.graphics.newImage("sprites/egg.png")
	baby = love.graphics.newImage("sprites/baby.png")
	food = love.graphics.newImage("sprites/food.png")
	poop = love.graphics.newImage("sprites/poop.png")
	arrow = love.graphics.newImage("sprites/arrow.png")
	arrow_right = love.graphics.newImage("sprites/arrow_right.png")
	background = love.graphics.newImage("sprites/background.png")
	background_game = love.graphics.newImage("sprites/background_game.png")

	poops = {}
	icons = {}
	table.insert(icons, Icon(
		width/10 * 1, 48, 
		love.graphics.newImage("sprites/icons/fork.png"), 
		function()
			if mouseButton == "left" and tama.mode == "idle" then
				tama:eat("cremepuff")
			elseif mouseButton == "right" and tama.mode == "idle" then
				tama:eat("broccoli")
			end
		 end))
	table.insert(icons, Icon(
		width/10 * 3, 48,
		love.graphics.newImage("sprites/icons/ball.png"), 
		function()
			Gamestate.switch(play)
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
			if tama.mode == "pooping" then tama.mode = "idle" end
			while #poops >= 1 do
				table.remove(poops, 1)
				tama:react("Happy")
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
			if devMode then devMode = false else devMode = true end
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
	sfx_happy = love.audio.newSource("sfx/happy.wav", "stream")
	sfx_light = love.audio.newSource("sfx/light.wav", "stream")
	sfx_gameover = love.audio.newSource("sfx/gameover.mp3", "stream")
	sfx_gamemusic = love.audio.newSource("sfx/gamemusic.mp3", "stream")

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
	if devMode then
		love.graphics.print("energy: " .. tama.energy, 20, height/2 + 40)
		love.graphics.print("health: " .. tama.health, 20, height/2 + 10)
		love.graphics.print("hunger: " .. tama.hunger, 20, height/2 - 20)
		love.graphics.print("fullness: " .. tama.full, 20, height/2 - 50)
		love.graphics.print("frame: " .. tama.baby:getFrame(), 20, height/2 - 80)
		love.graphics.print("mouse_x: " .. mouse.x, 20, height/2 - 110)
		love.graphics.print("mouse_y: " .. mouse.y, 20, height/2 - 140)
		local lightTest = "what"
		if lightOn then lightTest = "true" else lightTest = "false" end
		love.graphics.print("lightOn: " .. lightTest, 20, height/2 - 170)
		love.graphics.print("mode: " .. tama.mode, 20, height/2 - 200)
	end
	icons:draw()
end

function home:keypressed(key)
	if key == "`" then if devMode then devMode = false else devMode = true end end
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

function play:enter()
	arrows = {}
	correctAnswer = lume.randomchoice({"Left", "Right"})
	myAnswer = nil
	answered = false
	camera.scale = 1.0
	tamaplay = peachy.new("sprites/baby.json", baby, "Right", 0.6)
	tamaplay:setTag("LeftRight")
	love.audio.play(sfx_gamemusic)

	leftArrow = table.insert(arrows, Icon(
	32, 240, 
	arrow, 
	function()
		myAnswer = "Left"
		love.audio.stop()
		Timer.during(0.5, function() tamaplay:setTag(correctAnswer) end)
	 end, false))

	rightArrow = table.insert(arrows, Icon(
	640 - 32, 240, 
	arrow_right, 
	function()
		myAnswer = "Right"
		love.audio.stop()
		Timer.during(0.5, function() tamaplay:setTag(correctAnswer) end)
	 end, false))
end

function play:update(dt)
	tamaplay:update(dt)
	for k,v in ipairs(arrows) do
		v:update(dt)
	end

	if myAnswer ~= nil then
		tamaplay:setSpeed(1)
		Timer.after(0.5, function() 
			if myAnswer == correctAnswer then 
				tamaplay:setTag("Happy")
				love.audio.play(sfx_happy)
				Timer.after(3, function() Gamestate.switch(home) end)
			else
				tamaplay:setTag("Annoyed")
				love.audio.play(sfx_hurt)
				Timer.after(3, function() Gamestate.switch(home) end)
			end
		end)
	end
end

function play:draw()
	love.graphics.draw(background_game, 0, 0, 0, 2, 2)
	for k,v in ipairs(arrows) do
		v:draw()
	end
	tamaplay:draw(320, 240, 0, 3, 3, 16, 16)
end

function play:keypressed(key)
	if key == "space" then Gamestate.switch(home) end

	if key == "right" or key == "left" then
		myAnswer = key 
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
