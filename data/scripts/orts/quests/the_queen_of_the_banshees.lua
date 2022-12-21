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
