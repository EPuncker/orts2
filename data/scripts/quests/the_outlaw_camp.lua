local oven = Action()

local config = {
	[1945] = {position = {Position(32623, 32188, 9), Position(32623, 32189, 9)}},
	[1946] = {position = {Position(32623, 32189, 9), Position(32623, 32188, 9)}}
}

function oven.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.itemid]
	if not useItem then
		return true
	end


	local oven = Tile(useItem.position[1]):getTopTopItem()
	if oven and table.contains({1786, 1787}, oven.itemid) then
		oven:moveTo(useItem.position[2])
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

oven:uid(3400)
oven:register()

local powerSwitch = Action()

function powerSwitch.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	return true
end

powerSwitch:uid(3401)
powerSwitch:register()

local powerBurn = Action()

function powerBurn.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local power = Tile(Position(32613, 32220, 10))
	local wall = Tile(Position(32614, 32205, 10))
	local stone = Tile(Position(32614, 32206, 10))
	if item.itemid == 1945 and power:getItemById(2166) and wall:getItemById(1025) and stone:getItemById(1304) and Tile(Position(32614, 32209, 10)):getItemById(1774) then
		power:getItemById(2166):transform(1487)
		wall:getItemById(1025):remove()
		stone:getItemById(1304):transform(1025)
		Game.createItem(1487, 1, Position(32615, 32221, 10))
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

powerBurn:uid(3402)
powerBurn:register()
