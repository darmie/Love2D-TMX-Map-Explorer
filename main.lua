-- Tell Lua where are the modules
package.path = './lib/?.lua;./lib/?/init.lua;' .. package.path

-- ATL needs to know where it is
TILED_LOADER_PATH = 'lib/ATL/AdvTiledLoader/'
local ATL = require('ATL/AdvTiledLoader')
-- local Dev = require('Dev')

local camera = {
	zoom = 1,
	x    = 0,
	y    = 0
}
local map
local mouse = {
	dragDrop = false
}

-- Initialization
function love.load(arguments)
	-- arguments[1] == 'app.love'
	local mapDir  = arguments[2] or 'maps/'
	local mapFile = arguments[3] or 'sample.tmx'
	-- load the map
	ATL.Loader.path = mapDir
	if love.filesystem.exists(mapDir .. mapFile) then
		map = ATL.Loader.load(mapFile)
	else
		error("File (" .. mapDir .. mapFile .. ") does not exists")
	end

end

function love.mousepressed( x, y, mb )
	-- zoom with mousewheel
	if mb == 'wu' then
		camera.zoom = camera.zoom + 0.2
	elseif mb == 'wd' then
		camera.zoom = camera.zoom - 0.2
	-- drag the map
	elseif mb == 'l' then
		mouse.dragDrop = true
		mouse.startX,  mouse.startY  = love.mouse.getPosition()
		mouse.cameraX, mouse.cameraY = camera.x - mouse.startX, camera.y - mouse.startY
		love.mouse.setVisible(false)
	end
end

function love.mousereleased( x, y, mb )
	if mb == 'l' then
		mouse.dragDrop = false
		love.mouse.setPosition(mouse.startX, mouse.startY)
		love.mouse.setVisible(true)
	end
end

function love.update(dt)

	-- camera position
	if mouse.dragDrop then -- mouse grab
		local x, y = love.mouse.getPosition()
		camera.x = mouse.cameraX + x
		camera.y = mouse.cameraY + y
	else -- keyboard
		if love.keyboard.isDown("up")    then camera.y = camera.y + 250 * dt end
		if love.keyboard.isDown("down")  then camera.y = camera.y - 250 * dt end
		if love.keyboard.isDown("left")  then camera.x = camera.x + 250 * dt end
		if love.keyboard.isDown("right") then camera.x = camera.x - 250 * dt end
	end


end


function love.keypressed(key)
	-- quit 
    if key == 'escape' then
        love.event.push('q')
    end
end


function love.draw()	
	local floor_x, floor_y = math.floor(camera.x), math.floor(camera.y)
	-- save the state
	love.graphics.push()
	love.graphics.scale(camera.zoom)
	love.graphics.translate(floor_x, floor_y)
	
	-- define the area to draw
	map:autoDrawRange(floor_x, floor_y, camera.zoom, 100) 
	map:draw()

	-- restore the state
	love.graphics.pop()
end