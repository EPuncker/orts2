local fountain = Action()

function fountain.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.FountainOfLife) == 1 then
		return false
	end

	player:addHealth(player:getMaxHealth())
	player:addMana(player:getMaxMana())
	player:addAchievement('Fountain of Life')
	player:setStorageValue(PlayerStorageKeys.FountainOfLife, 1)
	player:say('You feel very refreshed and relaxed.', TALKTYPE_MONSTER_SAY)
	return true
end

fountain:aid(8815)
fountain:register()

local goshnar = Action()

function goshnar.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 2023 then
		return false
	end

	if not Tile(toPosition):getItemById(2016, 2) then
		return true
	end

	toPosition.z = toPosition.z + 1
	player:teleportTo(toPosition)
	toPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

goshnar:aid(2022)
goshnar:register()

local levers = Action()

local text = {
	[1] = "first",
	[2] = "second",
	[3] = "third",
	[4] = "fourth",
	[5] = "fifth",
	[6] = "sixth",
	[7] = "seventh",
	[8] = "eighth",
	[9] = "ninth",
	[10] = "tenth",
	[11] = "eleventh",
	[12] = "twelfth",
	[13] = "thirteenth",
	[14] = "fourteenth",
	[15] = "fifteenth"
}

local stonePositions = {
	Position(32851, 32333, 12),
	Position(32852, 32333, 12)
}

local function createStones()
	for i = 1, #stonePositions do
		local stone = Tile(stonePositions[i]):getItemById(1304)
		if not stone then
			Game.createItem(1304, 1, stonePositions[i])
		end
	end

	Game.setStorageValue(GlobalStorageKeys.PitsOfInfernoLevers, 0)
end

local function revertLever(position)
	local leverItem = Tile(position):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end
end

function levers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1945 then
		return false
	end

	local leverCount = math.max(0, Game.getStorageValue(GlobalStorageKeys.PitsOfInfernoLevers))
	if item.uid > 2049 and item.uid < 2065 then
		local number = item.uid - 2049
		if leverCount + 1 ~= number then
			return false
		end

		Game.setStorageValue(GlobalStorageKeys.PitsOfInfernoLevers, number)
		player:say('You flipped the ' .. text[number] .. ' lever. Hurry up and find the next one!', TALKTYPE_MONSTER_SAY, false, player, toPosition)
	elseif item.uid == 2065 then
		if leverCount ~= 15 then
			player:say('The final lever won\'t budge... yet.', TALKTYPE_MONSTER_SAY)
			return true
		end

		local stone
		for i = 1, #stonePositions do
			stone = Tile(stonePositions[i]):getItemById(1304)
			if stone then
				stone:remove()
				stonePositions[i]:sendMagicEffect(CONST_ME_EXPLOSIONAREA)
			end
		end

		addEvent(createStones, 15 * 60 * 1000)
	end

	item:transform(1946)
	addEvent(revertLever, 15 * 60 * 1000, toPosition)
	return true
end

levers:uid(2050, 2051, 2052, 2053, 2054, 2055, 2056, 2057, 2058, 2059, 2060, 2061, 2062, 2063, 2064, 2065)
levers:register()

local oil = Action()

local bridgePosition = Position(32801, 32336, 11)

local function revertBridge()
	Tile(bridgePosition):getItemById(5770):transform(493)
end

local function revertLever(position)
	local leverItem = Tile(position):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end
end

function oil.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1945 then
		return false
	end

	if not Tile(Position(32800, 32339, 11)):getItemById(2016, 11) then
		player:say('The lever is creaking and rusty.', TALKTYPE_MONSTER_SAY)
		return true
	end

	local water = Tile(bridgePosition):getItemById(493)
	if water then
		water:transform(5770)
		addEvent(revertBridge, 10 * 60 * 1000)
	end

	item:transform(1946)
	addEvent(revertLever, 10 * 60 * 1000, toPosition)
	return true
end

oil:uid(1021)
oil:register()

local stoneLever = Action()

function stoneLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		local stonePosition = Position(32849, 32282, 10)
		local stoneItem = Tile(stonePosition):getItemById(1304)
		if stoneItem then
			stoneItem:remove()
			stonePosition:sendMagicEffect(CONST_ME_EXPLOSIONAREA)
			item:transform(1946)
		end
	end
	return true
end

stoneLever:uid(3300)
stoneLever:register()

local walls = Action()

local pos = {
	[2025] = Position(32831, 32333, 11),
	[2026] = Position(32833, 32333, 11),
	[2027] = Position(32835, 32333, 11),
	[2028] = Position(32837, 32333, 11)
}

local function doRemoveFirewalls(fwPos)
	local tile = Position(fwPos):getTile()
	if tile then
		local thing = tile:getItemById(6289)
		if thing then
			thing:remove()
		end
	end
end


function walls.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		doRemoveFirewalls(pos[item.uid])
		Position(pos[item.uid]):sendMagicEffect(CONST_ME_FIREAREA)
	else
		Game.createItem(6289, 1, pos[item.uid])
		Position(pos[item.uid]):sendMagicEffect(CONST_ME_FIREAREA)
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

walls:uid(2025, 2026, 2027, 2028)
walls:register()

local ladderLevers = Action()

function ladderLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1945 then
		return false
	end

	item:transform(1946)

	if item.uid == 3301 then
		local pos = { Position(32861, 32305, 11), Position(32860, 32313, 11) }
		local lava = Tile(pos[1]):getItemById(598)
		if lava then
			lava:transform(1284)
		end

		local dirtId, dirtItem = { 4808, 4810 }
		for i = 1, #dirtId do
			dirtItem = Tile(pos[1]):getItemById(dirtId[i])
			if dirtItem then
				dirtItem:remove()
			end
		end
	elseif item.uid == 3302 then
		local item = Tile(pos[2]):getItemById(387)
		if item then
			item:remove()
		end
	end
	return true
end

ladderLevers:uid(3301, 3302)
ladderLevers:register()

local trapLever = Action()

function trapLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(item.itemid == 1945 and 1946 or 1945)

	if item.itemid ~= 1945 then
		return true
	end

	local stoneItem = Tile(Position(32826, 32274, 11)):getItemById(1285)
	if stoneItem then
		stoneItem:remove()
	end
	return true
end

trapLever:id(3304)
trapLever:register()

local bazirMirror = Action()

local config = {
	[39511] = {
		fromPosition = Position(32739, 32392, 14),
		toPosition = Position(32739, 32391, 14)
	},

	[39512] = {
		teleportPlayer = true,
		fromPosition = Position(32739, 32391, 14),
		toPosition = Position(32739, 32392, 14)
	}
}

function bazirMirror.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.actionid]
	if not useItem then
		return true
	end

	if useItem.teleportPlayer then
		player:teleportTo(Position(32712, 32392, 13))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say('Beauty has to be rewarded! Muahahaha!', TALKTYPE_MONSTER_SAY)
	end

	local tapestry = Tile(useItem.fromPosition):getItemById(6434)
	if tapestry then
		tapestry:moveTo(useItem.toPosition)
	end
	return true
end

bazirMirror:id(39511, 39512)
bazirMirror:register()

local bazirWrongLevers = Action()

function bazirWrongLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		player:teleportTo(Position(32806, 32328, 15))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		item:transform(1946)
	end
	return true
end

bazirWrongLevers:uid(50095, 50096, 50097, 50098, 50099, 50100, 50101, 50102, 50103, 50104)
bazirWrongLevers:register()

local bazirMazeLever = Action()

function bazirMazeLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local portal = Tile(Position(32816, 32345, 13)):getItemById(1387)
	if not portal then
		local item = Game.createItem(1387, 1, Position(32816, 32345, 13))
		if item:isTeleport() then
			item:setDestination(Position(32767, 32366, 15))
		end
	else
		portal:remove()
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

bazirMazeLever:uid(50105)
bazirMazeLever:register()

local fireThroneLever = Action()

local lava = {
	Position(32912, 32209, 15),
	Position(32913, 32209, 15),
	Position(32912, 32210, 15),
	Position(32913, 32210, 15)
}

function fireThroneLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local lavaTile
	for i = 1, #lava do
		lavaTile = Tile(lava[i]):getGround()
		if lavaTile and table.contains({407, 598}, lavaTile.itemid) then
			lavaTile:transform(lavaTile.itemid == 598 and 407 or 598)
			lava[i]:sendMagicEffect(CONST_ME_SMOKE)
		end
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

fireThroneLever:uid(50106)
fireThroneLever:register()

local mazeStone = Action()

function mazeStone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1946 then
		return false
	end

	toPosition.x = toPosition.x - 1
	toPosition.y = toPosition.y + 1

	local stone = Tile(toPosition):getItemById(1304)
	if stone then
		stone:remove()
	end

	item:transform(1946)
	return true
end

mazeStone:aid(50160)
mazeStone:register()
