Object = require "classic"
peachy = require "peachy"
lume = require "lume"
Gamestate = require "hump.gamestate"
Timer = require "hump.timer"
Camera = require "hump.camera"

require "tama"

home = {}
hatchery = {}

width = love.graphics.getWidth()
height = love.graphics.getHeight()
	
love.graphics.setDefaultFilter("nearest", "nearest")
success = love.window.setMode(640, 480)


function love.load()
	egg = love.graphics.newImage("sprites/egg.png")
	baby = love.graphics.newImage("sprites/baby.png")
	food = love.graphics.newImage("sprites/food.png")
	background = love.graphics.newImage("sprites/background.png")

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

	camera = Camera(width/2, height/2)

	Gamestate.registerEvents()
	Gamestate.switch(hatchery)

end

function love.update(dt)
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
	camera:zoom(1)
end

function home:update(dt)
	tama:update(dt)
end

function home:draw()
	love.graphics.print("hunger: " .. tama.hunger, 20, height/2 - 20)
	love.graphics.print("frame: " .. tama.baby:getFrame(), 20, height/2 - 50)
	camera:attach()

	love.graphics.setColor(1, 1, 1)
	love.graphics.draw(background, background:getWidth(), background:getHeight(), 0, 0.5, 0.5)

	tama:draw()
	camera:detach()
end

function home:keypressed(key)
end

function hatchery:enter()
	love.graphics.setBackgroundColor(0.6, 0.3, 0.5)
	tama = Tama(width/2, height/2)
	camera:zoom(4)
end

function hatchery:update(dt)
	if not tama.hatched then
		tama.egg:setSpeed(lume.lerp(tama.egg:getSpeed(), 10, 0.001))
	end

	if tama.egg:getSpeed() > 5 then
		tama.egg:setSpeed(1)
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