local walls = Action()

local config = {
	[4249] = {position = Position(32792, 31581, 7), itemId = 1037},
	[4250] = {position = Position(32790, 31594, 7), itemId = 1285}
}

function walls.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local wall = config[item.actionid]
	if not wall then
		return true
	end

	local wallItem = Tile(wall.position):getItemById(wall.itemId)
	if wallItem then
		wallItem:remove()
	else
		Game.createItem(wall.itemId, 1, wall.position)
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

walls:aid(4249, 4250)
walls:register()

local escape = MoveEvent()

function escape.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	position:sendMagicEffect(CONST_ME_TELEPORT)

	local sacrificeItem, destination = Tile(Position(32816, 31601, 9)):getItemById(2319)
	if not sacrificeItem then
		destination = Position(32818, 31599, 9)
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	sacrificeItem:remove()

	if player:getStorageValue(PlayerStorageKeys.Dragonfetish) == 1 then
		player:setStorageValue(PlayerStorageKeys.Dragonfetish, 0)
	end

	destination = Position(32701, 31639, 6)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

escape:type("stepin")
escape:aid(4246)
escape:register()

local fall = MoveEvent()

function fall.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	position.z = position.z + 1
	player:teleportTo(position)
	return true
end

fall:type("stepin")
fall:aid(4247, 4248)
fall:register()

local walls = MoveEvent()

local config = {
	[4251] = {position = Position(32796, 31594, 5), itemId = 1025},
	[4252] = {position = Position(32796, 31576, 5), itemId = 1025}
}

function walls.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local wall = config[item.actionid]
	if not wall then
		return true
	end

	local wallItem = Tile(wall.position):getItemById(wall.itemId)
	if wallItem then
		wallItem:remove()
	end

	item:transform(item.itemid - 1)
	return true
end

walls:type("stepin")
walls:aid(4251, 4252)
walls:register()

local walls = MoveEvent()

function walls.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local wall = config[item.actionid]
	if not wall then
		return true
	end

	if not Tile(wall.position):getItemById(wall.itemId) then
		Game.createItem(wall.itemId, 1, wall.position)
	end

	item:transform(item.itemid + 1)
	return true
end

walls:type("stepout")
walls:aid(4251, 4252)
walls:register()

local exit = MoveEvent()

local config = {
	{position = Position(32802, 31584, 1), itemId = 1945},
	{position = Position(32803, 31584, 1), itemId = 1946},
	{position = Position(32804, 31584, 1), itemId = 1945},
	{position = Position(32805, 31584, 1), itemId = 1946}
}

function exit.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local correct, leverItem = true
	for i = 1, #config do
		leverItem = Tile(config[i].position):getItemById(config[i].itemId)
		if not leverItem then
			correct = false
			break
		end
	end

	position:sendMagicEffect(CONST_ME_TELEPORT)

	local destination
	if not correct then
		destination = Position(32803, 31587, 1)
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	destination = Position(32701, 31639, 6)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

exit:type("stepin")
exit:aid(4253)
exit:register()
