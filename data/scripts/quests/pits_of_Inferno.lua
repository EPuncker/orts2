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

local checkThrones = MoveEvent()

local storages = {
	[2090] = PlayerStorageKeys.PitsOfInferno.ThroneInfernatil,
	[2091] = PlayerStorageKeys.PitsOfInferno.ThroneTafariel,
	[2092] = PlayerStorageKeys.PitsOfInferno.ThroneVerminor,
	[2093] = PlayerStorageKeys.PitsOfInferno.ThroneApocalypse,
	[2094] = PlayerStorageKeys.PitsOfInferno.ThroneBazir,
	[2095] = PlayerStorageKeys.PitsOfInferno.ThroneAshfalor,
	[2096] = PlayerStorageKeys.PitsOfInferno.ThronePumin
}

function checkThrones.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	if creature:getStorageValue(storages[item.uid]) ~= 1 then
		creature:teleportTo(fromPosition)
		creature:say('You\'ve not absorbed energy from this throne.', TALKTYPE_MONSTER_SAY)
	end
	return true
end

checkThrones:type("stepin")
checkThrones:uid(2090, 2091, 2092, 2093, 2094, 2095, 2096)
checkThrones:register()

local fireTiles = MoveEvent()

local fires = {
	[2040] = {vocationId = VOCATION_SORCERER, damage = 300},
	[2041] = {vocationId = VOCATION_SORCERER, damage = 600},
	[2042] = {vocationId = VOCATION_SORCERER, damage = 1200},
	[2043] = {vocationId = VOCATION_SORCERER, damage = 2400},
	[2044] = {vocationId = VOCATION_SORCERER, damage = 3600},
	[2045] = {vocationId = VOCATION_SORCERER, damage = 7200},

	[2046] = {vocationId = VOCATION_DRUID, damage = 300},
	[2047] = {vocationId = VOCATION_DRUID, damage = 600},
	[2048] = {vocationId = VOCATION_DRUID, damage = 1200},
	[2049] = {vocationId = VOCATION_DRUID, damage = 2400},
	[2050] = {vocationId = VOCATION_DRUID, damage = 3600},
	[2051] = {vocationId = VOCATION_DRUID, damage = 7200},

	[2052] = {vocationId = VOCATION_PALADIN, damage = 300},
	[2053] = {vocationId = VOCATION_PALADIN, damage = 600},
	[2054] = {vocationId = VOCATION_PALADIN, damage = 1200},
	[2055] = {vocationId = VOCATION_PALADIN, damage = 2400},
	[2056] = {vocationId = VOCATION_PALADIN, damage = 3600},
	[2057] = {vocationId = VOCATION_PALADIN, damage = 7200},

	[2058] = {vocationId = VOCATION_KNIGHT, damage = 300},
	[2059] = {vocationId = VOCATION_KNIGHT, damage = 600},
	[2060] = {vocationId = VOCATION_KNIGHT, damage = 1200},
	[2061] = {vocationId = VOCATION_KNIGHT, damage = 2400},
	[2062] = {vocationId = VOCATION_KNIGHT, damage = 3600},
	[2063] = {vocationId = VOCATION_KNIGHT, damage = 7200}
}

function fireTiles.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local fire = fires[item.actionid]
	if not fire then
		return true
	end

	if player:getVocation():getBase():getId() == fire.vocationId then
		doTargetCombat(0, player, COMBAT_FIREDAMAGE, -300, -300, CONST_ME_HITBYFIRE)
	else
		local combatType = COMBAT_FIREDAMAGE
		if fire.damage > 300 then
			combatType = COMBAT_PHYSICALDAMAGE
		end
		doTargetCombat(0, player, combatType, -fire.damage, -fire.damage, CONST_ME_FIREATTACK)
	end
	return true
end

fireTiles:type("stepin")

for index, value in pairs(fires) do
	fireTiles:aid(index)
end

fireTiles:register()

local ladder = MoveEvent()

function ladder.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local ladderPosition = Position(32854, 32321, 11)
	local ladderItem = Tile(ladderPosition):getItemById(5543)
	if not ladderItem then
		Game.createItem(5543, 1, ladderPosition)
		player:say('You hear a rumbling from far away.', TALKTYPE_MONSTER_SAY, false, player)
	end
	return true
end

ladder:type("stepin")
ladder:aid(2002)
ladder:register()

local ladder = MoveEvent()

function ladder.onStepOut(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local ladderPosition = Position(32854, 32321, 11)
	local ladderItem = Tile(ladderPosition):getItemById(5543)
	if ladderItem then
		ladderItem:remove()
		player:say('You hear a rumbling from far away.', TALKTYPE_MONSTER_SAY, false, player)
	end
	return true
end

ladder:type("stepout")
ladder:aid(2002)
ladder:register()

local stone = MoveEvent()

function stone.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local stonePosition = Position(32849, 32282, 10)
	local stoneItem, leverItem = Tile(stonePosition):getItemById(1304), Tile(Position(32850, 32268, 10)):getItemById(1946)
	if not stoneItem and leverItem then
		Game.createItem(1304, 1, stonePosition)
		leverItem:transform(1945)
		player:say('You hear a rumbling from far away.', TALKTYPE_MONSTER_SAY, false, player)
	end
	return true
end

stone:type("stepin")
stone:aid(4001)
stone:register()

local drawbridge = MoveEvent()

local bridgePosition = Position(32851, 32309, 11)
local relocatePosition = Position(32852, 32310, 11)
local dirtIds = {4808, 4810}

function drawbridge.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	local tile = Tile(bridgePosition)
	local lavaItem = tile:getItemById(598)
	if lavaItem then
		lavaItem:transform(1284)

		local dirtItem
		for i = 1, #dirtIds do
			dirtItem = tile:getItemById(dirtIds[i])
			if dirtItem then
				dirtItem:remove()
			end
		end
	end
	return true
end

drawbridge:type("stepin")
drawbridge:aid(4002)
drawbridge:register()

local drawbridge = MoveEvent()

function drawbridge.onStepOut(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	local tile = Tile(bridgePosition)
	local bridgeItem = tile:getItemById(1284)
	if bridgeItem then
		tile:relocateTo(relocatePosition)
		bridgeItem:transform(598)

		for i = 1, #dirtIds do
			Game.createItem(dirtIds[i], 1, bridgePosition)
		end
	end
	return true
end

drawbridge:type("stepout")
drawbridge:aid(4002)
drawbridge:register()

local shortcuts = MoveEvent()

local storages = {
	[8816] = PlayerStorageKeys.PitsOfInferno.ShortcutHub,
	[8817] = PlayerStorageKeys.PitsOfInferno.ShortcutLevers
}

function shortcuts.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local cutoffStorage = storages[item.actionid]
	if player:getStorageValue(cutoffStorage) ~= 1 then
		player:setStorageValue(cutoffStorage, 1)
	end
	return true
end

shortcuts:type("stepin")
shortcuts:aid(8816, 8817)
shortcuts:register()

local thrones = MoveEvent()

local config = {
	[2080] = {storage = PlayerStorageKeys.PitsOfInferno.ThroneInfernatil, text = 'You have touched Infernatil\'s throne and absorbed some of his spirit.', effect = CONST_ME_FIREAREA, toPosition = Position(32909, 32211, 15)},
	[2081] = {storage = PlayerStorageKeys.PitsOfInferno.ThroneTafariel, text = 'You have touched Tafariel\'s throne and absorbed some of his spirit.', effect = CONST_ME_MORTAREA, toPosition = Position(32761, 32243, 15)},
	[2082] = {storage = PlayerStorageKeys.PitsOfInferno.ThroneVerminor, text = 'You have touched Verminor\'s throne and absorbed some of his spirit.', effect = CONST_ME_POISONAREA, toPosition = Position(32840, 32327, 15)},
	[2083] = {storage = PlayerStorageKeys.PitsOfInferno.ThroneApocalypse, text = 'You have touched Apocalypse\'s throne and absorbed some of his spirit.', effect = CONST_ME_EXPLOSIONAREA, toPosition = Position(32875, 32267, 15)},
	[2084] = {storage = PlayerStorageKeys.PitsOfInferno.ThroneBazir, text = 'You have touched Bazir\'s throne and absorbed some of his spirit.', effect = CONST_ME_MAGIC_GREEN, toPosition = Position(32745, 32385, 15)},
	[2085] = {storage = PlayerStorageKeys.PitsOfInferno.ThroneAshfalor, text = 'You have touched Ashfalor\'s throne and absorbed some of his spirit.', effect = CONST_ME_FIREAREA, toPosition = Position(32839, 32310, 15)},
	[2086] = {storage = PlayerStorageKeys.PitsOfInferno.ThronePumin, text = 'You have touched Pumin\'s throne and absorbed some of his spirit.', effect = CONST_ME_MORTAREA, toPosition = Position(32785, 32279, 15)}
}

function thrones.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	local throne = config[item.uid]
	if not throne then
		return true
	end

	local cStorage = throne.storage
	if creature:getStorageValue(cStorage) ~= 1 then
		creature:setStorageValue(cStorage, 1)
		creature:getPosition():sendMagicEffect(throne.effect)
		creature:say(throne.text, TALKTYPE_MONSTER_SAY)
	else
		creature:teleportTo(throne.toPosition)
		creature:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
		creature:say('Begone!', TALKTYPE_MONSTER_SAY)
	end
	return true
end

thrones:type("stepin")
thrones:uid(2080, 2081, 2082, 2083, 2084, 2085, 2086)
thrones:register()

local tibleTile = MoveEvent()

local destinations = {
	[2000] = Position(32791, 32331, 10),
	[2001] = Position(32791, 32327, 10)
}

function tibleTile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if player:getItemCount(1970) < 1 then
		player:teleportTo(fromPosition)
		return true
	end

	player:teleportTo(destinations[item.uid])
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

tibleTile:type("stepin")
tibleTile:aid(2000, 2001)
tibleTile:register()

local tileTeleports = MoveEvent()

local config = {
	[28810] = Position(32838, 32304, 9),
	[28811] = Position(32839, 32320, 9),
	[28812] = Position(32844, 32310, 9),
	[28813] = Position(32847, 32307, 9),
	[28814] = Position(32856, 32306, 9),
	[28815] = Position(32827, 32308, 9),
	[28816] = Position(32840, 32317, 9),
	[28817] = Position(32855, 32296, 9),
	[28818] = Position(32857, 32307, 9),
	[28819] = Position(32856, 32289, 9),
	[28820] = Position(32843, 32313, 9),
	[28821] = Position(32861, 32320, 9),
	[28822] = Position(32841, 32323, 9),
	[28823] = Position(32847, 32287, 9),
	[28824] = Position(32854, 32323, 9),
	[28825] = Position(32855, 32304, 9),
	[28826] = Position(32841, 32323, 9),
	[28827] = Position(32861, 32317, 9),
	[28828] = Position(32827, 32314, 9),
	[28829] = Position(32858, 32296, 9),
	[28830] = Position(32861, 32301, 9),
	[28831] = Position(32855, 32321, 9),
	[28832] = Position(32855, 32320, 9),
	[28833] = Position(32855, 32318, 9),
	[28834] = Position(32855, 32319, 9)
}

function tileTeleports.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetPosition = config[item.actionid]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition)
	return true
end

tileTeleports:type("stepin")

for index, value in pairs(config) do
	tileTeleports:aid(index)
end

tileTeleports:register()

local trap = MoveEvent()

function trap.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	position.z = position.z + 1
	player:teleportTo(position)
	position:sendMagicEffect(CONST_ME_FIREATTACK)
	return true
end

trap:type("stepin")
trap:aid(7799)
trap:register()

local secondTrap = MoveEvent()

local stonePosition = Position(32826, 32274, 11)

function removeStone()
	local stoneItem = Tile(stonePosition):getItemById(1285)
	if stoneItem then
		stoneItem:remove()
		stonePosition:sendMagicEffect(CONST_ME_POFF)
	end
end

function secondTrap.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:teleportTo(Position(32826, 32273, 12))
	player:getPosition():sendMagicEffect(CONST_ME_EXPLOSIONAREA)
	Game.createItem(1285, 1, stonePosition)
	addEvent(removeStone, 10 * 1000)
	return true
end

secondTrap:type("stepin")
secondTrap:uid(3303)
secondTrap:register()

local bazirTiles = MoveEvent()

local config = {
	[16772] = Position(32754, 32365, 15),
	[16773] = Position(32725, 32381, 15),
	[16774] = Position(32827, 32241, 12),
	[50082] = Position(32745, 32394, 14),
	[50083] = Position(32745, 32394, 14)
}

function bazirTiles.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetPosition = config[item.actionid]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition)
	return true
end

bazirTiles:type("stepin")
bazirTiles:aid(16772, 16773, 16774, 50082, 50083)
bazirTiles:register()

local puminTeleport = MoveEvent()

function puminTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.PitsOfInferno.Pumin) > 8 then
		player:teleportTo(Position(32786, 32308, 15))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'To enter Pumin\'s domain you must gain permission from the bureaucrats.')
	end
	return true
end

puminTeleport:type("stepin")
puminTeleport:aid(50087)
puminTeleport:register()
