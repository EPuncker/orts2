local theFirstSeal = Action()

local config = {
	[50000] = {position = Position(32259, 31891, 10), revert = true},
	[50001] = {position = Position(32259, 31890, 10), revert = true},
	[50002] = {position = Position(32266, 31860, 11)},

	time = 100
}

local function revertWall(wallPosition, leverPosition)
	local leverItem = Tile(leverPosition):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end

	Game.createItem(1498, 1, wallPosition)
end

local function removeWall(position)
	local tile = position:getTile()
	if not tile then
		return
	end

	local thing = tile:getItemById(1498)
	if thing then
		thing:remove()
		position:sendMagicEffect(CONST_ME_MAGIC_RED)
	end
end

function theFirstSeal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1945 then
		player:sendCancelMessage('The lever has already been used.')
		return true
	end

	local wall = config[item.uid]
	removeWall(wall.position)

	if wall.revert then
		addEvent(revertWall, config.time * 1000, wall.position, toPosition)
	end

	item:transform(1946)
	return true
end

theFirstSeal:uid(50000, 50001, 50002)
theFirstSeal:register()

local theSixthSeal = Action()

local config = {
	[50005] = Position(32309, 31975, 13),
	[50006] = Position(32309, 31976, 13),
	[50007] = Position(32311, 31975, 13),
	[50008] = Position(32311, 31976, 13),
	[50009] = Position(32313, 31975, 13),
	[50010] = Position(32313, 31976, 13)
}

function theSixthSeal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.uid]
	if not useItem then
		return true
	end

	local campfire = Tile(useItem):getItemById(item.itemid == 1945 and 1423 or 1421)
	if campfire then
		campfire:transform(item.itemid == 1945 and 1421 or 1423)
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

theSixthSeal:uid(50005, 50006, 50007, 50008, 50009, 50010)
theSixthSeal:register()

local theThirdSeal = Action()

local function doTransformCoalBasins(cbPos)
	local tile = Position(cbPos):getTile()
	if tile then
		local thing = tile:getItemById(1485)
		if thing then
			thing:transform(1484)
		end
	end
end

local config = {
	[0] = 50015,
	[1] = 50016,
	[2] = 50017,
	[3] = 50018,
	[4] = 50019,

	coalBasins = {
		Position(32214, 31850, 15),
		Position(32215, 31850, 15),
		Position(32216, 31850, 15)
	},

	effects = {
		[0] = {
			Position(32217, 31845, 14),
			Position(32218, 31845, 14),
			Position(32219, 31845, 14),
			Position(32220, 31845, 14),
			Position(32217, 31843, 14),
			Position(32218, 31842, 14),
			Position(32219, 31841, 14)
		},

		[1] = {
			Position(32217, 31844, 14),
			Position(32218, 31844, 14),
			Position(32219, 31843, 14),
			Position(32220, 31845, 14),
			Position(32219, 31845, 14)
		},

		[2] = {
			Position(32217, 31842, 14),
			Position(32219, 31843, 14),
			Position(32219, 31845, 14),
			Position(32218, 31844, 14),
			Position(32217, 31844, 14),
			Position(32217, 31845, 14)
		},

		[3] = {
			Position(32217, 31845, 14),
			Position(32218, 31846, 14),
			Position(32218, 31844, 14),
			Position(32219, 31845, 14),
			Position(32220, 31846, 14)
		},

		[4] = {
			Position(32219, 31841, 14),
			Position(32219, 31842, 14),
			Position(32219, 31846, 14),
			Position(32217, 31843, 14),
			Position(32217, 31844, 14),
			Position(32217, 31845, 14),
			Position(32218, 31843, 14),
			Position(32218, 31845, 14)
		},
	},
}

function theThirdSeal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local switchNum = Game.getStorageValue("switchNum")
	if switchNum == -1 then
		Game.setStorageValue("switchNum", 0)
	end

	local table = config[switchNum]
	if not table then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.ThirdSeal) < 1 then
		if item.uid == table then
			item:transform(1945)
			Game.setStorageValue("switchNum", math.max(1, Game.getStorageValue("switchNum") + 1))
			toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			for i = 1, #config.effects[switchNum] do
				Position(config.effects[switchNum][i]):sendMagicEffect(CONST_ME_ENERGYHIT)
			end
			if Game.getStorageValue("switchNum") == 5 then
				for i = 1, #config.coalBasins do
					doTransformCoalBasins(config.coalBasins[i])
				end
			end
		else
			toPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
		end
	else
		return false
	end
	return true
end

theThirdSeal:uid(50015, 50016, 50017, 50018, 50019)
theThirdSeal:register()

local lastDoor = Action()

function lastDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 5114 then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.Kiss) == 1 and player:getStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.LastSeal) < 1 then
		player:teleportTo(toPosition, true)
		item:transform(item.itemid + 1)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The door seems to be sealed against unwanted intruders.')
	end
	return true
end

lastDoor:aid(50021)
lastDoor:register()

local theFirstSealFlame = MoveEvent()

function theFirstSealFlame.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.FirstSeal) < 1 then
		player:setStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.FirstSeal, 1)
		player:teleportTo(Position(32266, 31849, 15), false)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		Game.createMonster('Ghost', Position(32276, 31902, 13), false, true)
		Game.createMonster('Ghost', Position(32274, 31902, 13), false, true)
		Game.createMonster('Demon Skeleton', Position(32276, 31904, 13), false, true)
	else
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

theFirstSealFlame:type("stepin")
theFirstSealFlame:uid(50004)
theFirstSealFlame:register()

local theSixthSealFlame = MoveEvent()

local config = {
	{position = Position(32309, 31975, 13), campfireId = 1421},
	{position = Position(32311, 31975, 13), campfireId = 1421},
	{position = Position(32313, 31975, 13), campfireId = 1423},
	{position = Position(32309, 31976, 13), campfireId = 1421},
	{position = Position(32311, 31976, 13), campfireId = 1421},
	{position = Position(32313, 31976, 13), campfireId = 1423}
}

function theSixthSealFlame.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.SixthSeal) >= 1 then
		player:teleportTo(fromPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	for i = 1, #config do
		local campfireItem = Tile(config[i].position):getItemById(config[i].campfireId)
		if not campfireItem then
			player:teleportTo(fromPosition)
			fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end

	player:setStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.SixthSeal, 1)
	player:teleportTo(Position(32261, 31856, 15))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

theSixthSealFlame:type("stepin")
theSixthSealFlame:uid(50011)
theSixthSealFlame:register()

local theFifthSealFlame = MoveEvent()

function theFifthSealFlame.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.FifthSeal) < 1 then
		player:setStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.FifthSeal, 1)
		player:teleportTo(Position(32268, 31856, 15), false)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(Position(32185, 31939, 14), false)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

theFifthSealFlame:type("stepin")
theFifthSealFlame:uid(50012)
theFifthSealFlame:register()

local theFifthSealPath = MoveEvent()

function theFifthSealPath.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 50014 then
		position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
	else
		player:teleportTo(Position(32185, 31939, 14), false)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

theFifthSealPath:type("stepin")
theFifthSealPath:aid(50014, 50015)
theFifthSealPath:register()

local theFourthSealSacrifice = MoveEvent()

local positions = {
	Position(32243, 31893, 14),
	Position(32242, 31891, 14),
	Position(32242, 31893, 14),
	Position(32243, 31891, 14)
}

function theFourthSealSacrifice.onAddItem(moveitem, tileitem, position)
	if moveitem.itemid ~= 2006 or moveitem.type ~= 2 then
		return true
	end

	moveitem:transform(2016, 2)

	for i = 1, #positions do
		positions[i]:sendMagicEffect(CONST_ME_DRAWBLOOD)
	end
	return true
end

theFourthSealSacrifice:type("additem")
theFourthSealSacrifice:uid(50013)
theFourthSealSacrifice:register()

local theFourthSealFlame = MoveEvent()

function theFourthSealFlame.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.FourthSeal) >= 1 then
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local bloodItem = Tile(Position(32243, 31892, 14)):getItemById(2016, 2)
	if not bloodItem then
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	bloodItem:remove()
	player:setStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.FourthSeal, 1)
	local destination = Position(32261, 31849, 15)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

theFourthSealFlame:type("stepin")
theFourthSealFlame:uid(50014)
theFourthSealFlame:register()

local theThirdSealWarlockTile = MoveEvent()

function theThirdSealWarlockTile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.ThirdSealWarlocks) < 1 then
		player:setStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.ThirdSealWarlocks, 1)
		position:sendMagicEffect(CONST_ME_MAGIC_RED)
		Game.createMonster('Warlock', Position(32215, 31835, 15), false, true)
		Game.createMonster('Warlock', Position(32215, 31840, 15), false, true)
	end
	return true
end

theThirdSealWarlockTile:type("stepin")
theThirdSealWarlockTile:aid(50016)
theThirdSealWarlockTile:register()

local theThirdSealFlame = MoveEvent()

local config = {
	[0] = 50015,
	[1] = 50016,
	[2] = 50017,
	[3] = 50018,
	[4] = 50019,

	basinPositions = {
		Position(32214, 31850, 15),
		Position(32215, 31850, 15),
		Position(32216, 31850, 15)
	},

	switchPositions = {
		Position(32220, 31846, 15),
		Position(32220, 31845, 15),
		Position(32220, 31844, 15),
		Position(32220, 31843, 15),
		Position(32220, 31842, 15)
	},

	destination = Position(32271, 31857, 15)
}

local function resetItem(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end

function theThirdSealFlame.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.ThirdSeal) >= 1 or Game.getStorageValue('switchNum') ~= 5 then
		player:teleportTo(fromPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	player:setStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.ThirdSeal, 1)
	Game.setStorageValue('switchNum', 0)
	player:teleportTo(config.destination)
	config.destination:sendMagicEffect(CONST_ME_TELEPORT)

	for i = 1, #config.basinPositions do
		resetItem(config.basinPositions[i], 1484, 1485)
	end

	for i = 1, #config.switchPositions do
		resetItem(config.switchPositions[i], 1945, 1946)
	end
	return true
end

theThirdSealFlame:type("stepin")
theThirdSealFlame:uid(50020)
theThirdSealFlame:register()

local theSecondSealPearl = MoveEvent()

local config = {
	{position = Position(32173, 31871, 15), pearlId = 2143},
	{position = Position(32180, 31871, 15), pearlId = 2144}
}

function theSecondSealPearl.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.SecondSeal) >= 1 then
		player:teleportTo(fromPosition, true)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local pearlItems = {}
	for i = 1, #config do
		local pearlItem = Tile(config[i].position):getItemById(config[i].pearlId)
		if not pearlItem then
			player:teleportTo(fromPosition, true)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end

		pearlItems[#pearlItems + 1] = pearlItem
	end

	for i = 1, #pearlItems do
		pearlItems[i]:remove(1)
	end

	player:teleportTo(Position(position.x, position.y - 6, position.z))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

theSecondSealPearl:type("stepin")
theSecondSealPearl:aid(50017)
theSecondSealPearl:register()

local theSecondSealFlame = MoveEvent()

function theSecondSealFlame.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.SecondSeal) < 1 then
		player:setStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.SecondSeal, 1)
		player:teleportTo(Position(32272, 31849, 15))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

theSecondSealFlame:type("stepin")
theSecondSealFlame:uid(50021)
theSecondSealFlame:register()

local theLastFlame = MoveEvent()

function theLastFlame.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:setStorageValue(PlayerStorageKeys.QueenOfBansheesQuest.LastSeal, 1)
	player:teleportTo(Position(32269, 31853, 15))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

theLastFlame:type("stepin")
theLastFlame:uid(50022)
theLastFlame:register()
