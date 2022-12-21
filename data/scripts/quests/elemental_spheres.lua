local overlordsKill = CreatureEvent("ElementalSpheresOverlords")

local overlords = {
	['energy overlord'] = {cStorage = PlayerStorageKeys.ElementalSphere.BossStorage, cGlobalStorage = GlobalStorageKeys.ElementalSphere.KnightBoss},
	['fire overlord'] = {cStorage = PlayerStorageKeys.ElementalSphere.BossStorage, cGlobalStorage = GlobalStorageKeys.ElementalSphere.SorcererBoss},
	['ice overlord'] = {cStorage = PlayerStorageKeys.ElementalSphere.BossStorage, cGlobalStorage = GlobalStorageKeys.ElementalSphere.PaladinBoss},
	['earth overlord'] = {cStorage = PlayerStorageKeys.ElementalSphere.BossStorage, cGlobalStorage = GlobalStorageKeys.ElementalSphere.DruidBoss},
	['lord of the elements'] = {}
}

function overlordsKill.onKill(creature, target)
	if not target:isMonster() then
		return true
	end

	local bossName = target:getName()
	local bossConfig = overlords[bossName:lower()]
	if not bossConfig then
		return true
	end

	if bossConfig.cGlobalStorage then
		Game.setStorageValue(bossConfig.cGlobalStorage, 0)
	end

	if bossConfig.cStorage and creature:getStorageValue(bossConfig.cStorage) < 1 then
		creature:setStorageValue(bossConfig.cStorage, 1)
	end

	creature:say('You slayed ' .. bossName .. '.', TALKTYPE_MONSTER_SAY)
	return true
end

overlordsKill:register()

local lever = Action()

local config = {
	{position = Position(33270, 31835, 10), itemid = 8300, toPosition = Position(33270, 31835, 12), vocationId = VOCATION_PALADIN},
	{position = Position(33268, 31838, 10), itemid = 8305, toPosition = Position(33267, 31838, 12), vocationId = VOCATION_DRUID},
	{position = Position(33266, 31835, 10), itemid = 8306, toPosition = Position(33265, 31835, 12), vocationId = VOCATION_KNIGHT},
	{position = Position(33268, 31833, 10), itemid = 8304, toPosition = Position(33268, 31833, 12), vocationId = VOCATION_SORCERER}
}

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1945 then
		item:transform(1945)
		return true
	end

	if player:getPosition() ~= Position(33270, 31835, 10) then
		return false
	end

	local spectators = Game.getSpectators(Position(33268, 31836, 12), false, true, 30, 30, 30, 30)
	if #spectators > 0 or Game.getStorageValue(GlobalStorageKeys.ElementalSphere.BossRoom) > 0 then
		player:say('Wait for the current team to exit.', TALKTYPE_MONSTER_SAY, false, 0, Position(33268, 31835, 10))
		return true
	end

	local players = {}
	for i = 1, #config do
		local creature = Tile(config[i].position):getTopCreature()
		if not creature or not creature:isPlayer() then
			player:say('You need one player of each vocation having completed the Elemental Spheres quest and also carrying the elemental rare item.', TALKTYPE_MONSTER_SAY, false, 0, Position(33268, 31835, 10))
			return true
		end

		local vocationId = creature:getVocation():getBase():getId()
		if vocationId ~= config[i].vocationId or creature:getItemCount(config[i].itemid) < 1 or creature:getStorageValue(PlayerStorageKeys.ElementalSphere.QuestLine) < 2 then
			player:say('You need one player of each vocation having completed the Elemental Spheres quest and also carrying the elemental rare item.', TALKTYPE_MONSTER_SAY, false, 0, Position(33268, 31835, 10))
			return true
		end

		players[#players + 1] = creature
	end

	for i = 1, #players do
		players[i]:teleportTo(config[i].toPosition)
		config[i].position:sendMagicEffect(CONST_ME_TELEPORT)
		config[i].toPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end

	item:transform(item.itemid + 1)
	return true
end

lever:uid(9024)
lever:register()

local firstMachine = Action()

local config = {
	[VOCATION_SORCERER] = Position(33183, 32197, 13),
	[VOCATION_DRUID] = Position(33331, 32076, 13),
	[VOCATION_PALADIN] = Position(33265, 32202, 13),
	[VOCATION_KNIGHT] = Position(33087, 32096, 13)
}

function firstMachine.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains({7911, 7912}, item.itemid) then
		local gemCount = player:getStorageValue(PlayerStorageKeys.ElementalSphere.MachineGemCount)
		if table.contains({33268, 33269}, toPosition.x) and toPosition.y == 31830 and toPosition.z == 10 and gemCount >= 20 then
			player:setStorageValue(PlayerStorageKeys.ElementalSphere.MachineGemCount, gemCount - 20)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(config[player:getVocation():getBase():getId()], false)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end

		toPosition.x = toPosition.x + (item.itemid == 7911 and 1 or -1)
		local tile = toPosition:getTile()
		if tile then
			local thing = tile:getItemById(item.itemid == 7911 and 7912 or 7911)
			if thing then
				thing:transform(thing.itemid + 4)
			end
		end

		item:transform(item.itemid + 4)
	else
		toPosition.x = toPosition.x + (item.itemid == 7915 and 1 or -1)
		local tile = toPosition:getTile()
		if tile then
			local thing = tile:getItemById(item.itemid == 7915 and 7916 or 7915)
			if thing then
				thing:transform(thing.itemid - 4)
			end
		end

		item:transform(item.itemid - 4)
	end
	return true
end

firstMachine:id(7911, 7912, 7915, 7916)
firstMachine:register()

local secondMachine = Action()

function secondMachine.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not toPosition:isInRange(Position(33238, 31806, 12), Position(33297, 31865, 12)) then
		return false
	end

	if table.contains({7913, 7914}, item.itemid) then
		toPosition.y = toPosition.y + (item.itemid == 7913 and 1 or -1)
		local machineItem = Tile(toPosition):getItemById(item.itemid == 7913 and 7914 or 7913)
		if machineItem then
			machineItem:transform(machineItem.itemid + 4)
		end

		item:transform(item.itemid + 4)
		player:say('ON', TALKTYPE_MONSTER_SAY, false, player, toPosition)
	else
		toPosition.y = toPosition.y + (item.itemid == 7917 and 1 or -1)
		local machineItem = Tile(toPosition):getItemById(item.itemid == 7917 and 7918 or 7917)
		if machineItem then
			machineItem:transform(machineItem.itemid - 4)
		end

		item:transform(item.itemid - 4)
		player:say('OFF', TALKTYPE_MONSTER_SAY, false, player, toPosition)
	end
	return true
end

secondMachine:id(7913, 7914, 7917, 7918)
secondMachine:register()

local firstSoils = Action()

local config = {
	[8298] = {targetId = 8572, transformId = 8576, effect = CONST_ME_BIGPLANTS},
	[8299] = {targetId = 8573, transformId = 8575},
	[8302] = {targetId = 8571, transformId = 8574, effect = CONST_ME_ICEATTACK},
	[8303] = {targetId = 8567, createId = 1495}
}

function firstSoils.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local soil = config[item.itemid]
	if not soil then
		return true
	end

	if soil.targetId ~= target.itemid then
		return true
	end

	if soil.transformId then
		target:transform(soil.transformId)
		target:decay()
	elseif soil.createId then
		local newItem = Game.createItem(soil.createId, 1, toPosition)
		if newItem then
			newItem:decay()
		end
	end

	if soil.effect then
		toPosition:sendMagicEffect(soil.effect)
	end

	item:transform(item.itemid, item.type - 1)
	return true
end

firstSoils:id(8298, 8299, 8302, 8303)
firstSoils:register()

local secondSoils = Action()

local spheres = {
	[8300] = {VOCATION_PALADIN, VOCATION_ROYAL_PALADIN},
	[8304] = {VOCATION_SORCERER, VOCATION_MASTER_SORCERER},
	[8305] = {VOCATION_DRUID, VOCATION_ELDER_DRUID},
	[8306] = {VOCATION_KNIGHT, VOCATION_ELITE_KNIGHT}
}

local globalTable = {
	[VOCATION_SORCERER] = 10005,
	[VOCATION_DRUID] = 10006,
	[VOCATION_PALADIN] = 10007,
	[VOCATION_KNIGHT] = 10008
}

function secondSoils.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({7917, 7918, 7913, 7914}, target.itemid) then
		return false
	end

	if not toPosition:isInRange(Position(33238, 31806, 12), Position(33297, 31865, 12)) then
		return false
	end

	if not table.contains(spheres[item.itemid], player:getVocation():getId()) then
		return false
	end

	if table.contains({7917, 7918}, target.itemid) then
		player:say('Turn off the machine first.', TALKTYPE_MONSTER_SAY)
		return true
	end

	toPosition:sendMagicEffect(CONST_ME_PURPLEENERGY)
	Game.setStorageValue(globalTable[player:getVocation():getBase():getId()], 1)
	item:remove(1)
	return true
end

secondSoils:id(8300, 8304, 8305, 8306)
secondSoils:register()

local OAELever = Action()

local config = {
	exitPosition = Position(33265, 31838, 10),
	area = {
		from = Position(33238, 31806, 12),
		to = Position(33297, 31865, 12)
	},

	positions = {
		Position(33272, 31840, 12),
		Position(33263, 31840, 12),
		Position(33263, 31831, 12),
		Position(33272, 31831, 12)
	},

	leverPositions = {
		Position(33273, 31831, 12),
		Position(33273, 31840, 12),
		Position(33262, 31840, 12),
		Position(33262, 31831, 12)
	},

	walls = {
		{from = Position(33275, 31834, 12), to = Position(33275, 31838, 12), wallId = 5072, soundPosition = Position(33275, 31836, 12)},
		{from = Position(33266, 31843, 12), to = Position(33270, 31843, 12), wallId = 5071, soundPosition = Position(33268, 31843, 12)},
		{from = Position(33260, 31834, 12), to = Position(33260, 31838, 12), wallId = 5072, soundPosition = Position(33260, 31836, 12)},
		{from = Position(33266, 31828, 12), to = Position(33270, 31828, 12), wallId = 5071, soundPosition = Position(33268, 31828, 12)}
	},

	roomArea = {
		from = Position(33261, 31829, 12),
		to = Position(33274, 31842, 12)
	},

	machineStorages = {GlobalStorageKeys.ElementalSphere.Machine1, GlobalStorageKeys.ElementalSphere.Machine2, GlobalStorageKeys.ElementalSphere.Machine3, GlobalStorageKeys.ElementalSphere.Machine4},
	centerPosition = Position(33267, 31836, 12),
	effectPositions = {
		Position(33261, 31829, 12), Position(33262, 31830, 12), Position(33263, 31831, 12),
		Position(33264, 31832, 12), Position(33265, 31833, 12), Position(33266, 31834, 12),
		Position(33267, 31835, 12), Position(33268, 31836, 12), Position(33269, 31837, 12),
		Position(33270, 31838, 12), Position(33271, 31839, 12), Position(33272, 31840, 12),
		Position(33273, 31841, 12), Position(33274, 31842, 12), Position(33274, 31829, 12),
		Position(33273, 31830, 12), Position(33272, 31831, 12), Position(33271, 31832, 12),
		Position(33270, 31833, 12), Position(33269, 31834, 12), Position(33268, 31835, 12),
		Position(33267, 31836, 12), Position(33266, 31837, 12), Position(33265, 31838, 12),
		Position(33264, 31839, 12), Position(33263, 31840, 12), Position(33262, 31841, 12),
		Position(33261, 31842, 12)
	}
}


local function resetRoom(players)
	for i = 1, #players do
		local player = Player(players[i])
		if player and player:getPosition():isInRange(config.area.from, config.area.to) then
			player:teleportTo(config.exitPosition)
			config.exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end
	end

	for i = 1, #config.walls do
		local wall = config.walls[i]
		for x = wall.from.x, wall.to.x do
			for y = wall.from.y, wall.to.y do
				local wallItem = Tile(Position(x, y, wall.from.z)):getItemById(wall.wallId)
				if wallItem then
					wallItem:remove()
				end
			end
		end
	end

	local creature = Creature('lord of the elements')
	if creature then
		creature:remove()
	end

	for i = 1, #config.leverPositions do
		local leverItem = Tile(config.leverPositions[i]):getItemById(1946)
		if leverItem then
			leverItem:transform(1945)
		end
	end

	Game.setStorageValue(GlobalStorageKeys.ElementalSphere.BossRoom, -1)
	for i = 1, #config.machineStorages do
		Game.setStorageValue(config.machineStorages[i], -1)
	end
	return true
end

local function warnPlayers(players)
	local player
	for i = 1, #players do
		player = Player(players[i])
		if player and player:getPosition():isInRange(config.roomArea.from, config.roomArea.to) then
			break
		end
		player = nil
	end

	if not player then
		return
	end

	player:say('You have 5 minutes from now on until you get teleported out.', TALKTYPE_MONSTER_YELL, false, 0, Position(33266, 31835, 13))
end

local function areMachinesCharged()
	for i = 1, #config.machineStorages do
		if Game.getStorageValue(config.machineStorages[i]) <= 0 then
			return false
		end
	end
	return true
end

function OAELever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1945 then
		return true
	end

	for i = 1, #config.machineStorages do
		Game.setStorageValue(config.machineStorages[i], 1)
	end

	if not areMachinesCharged() then
		return false
	end

	local index = table.find(config.positions, player:getPosition())
	if not index then
		return false
	end

	item:transform(1946)
	local leverCount = 0
	for i = 1, #config.leverPositions do
		if Tile(config.leverPositions[i]):getItemById(1946) then
			leverCount = leverCount + 1
		end
	end

	local walls = config.walls[index]
	for x = walls.from.x, walls.to.x do
		for y = walls.from.y, walls.to.y do
			Game.createItem(walls.wallId, 1, Position(x, y, walls.from.z))
		end
	end
	player:say('ZOOOOOOOOM', TALKTYPE_MONSTER_SAY, false, 0, walls.soundPosition)

	if leverCount ~= #config.leverPositions then
		return true
	end

	local players = {}
	for i = 1, #config.positions do
		local creature = Tile(config.positions[i]):getTopCreature()
		if creature then
			players[#players + 1] = creature.uid
		end
	end

	Game.setStorageValue(GlobalStorageKeys.ElementalSphere.BossRoom, 1)
	Game.createMonster('Lord of the Elements', config.centerPosition)
	player:say('You have 10 minutes from now on until you get teleported out.', TALKTYPE_MONSTER_YELL, false, 0, config.centerPosition)
	addEvent(warnPlayers, 5 * 60 * 1000, players)
	addEvent(resetRoom, 10 * 60 * 1000, players)

	for i = 1, #config.effectPositions do
		config.effectPositions[i]:sendMagicEffect(CONST_ME_ENERGYHIT)
	end
	return true
end

OAELever:uid(9025, 9026, 9027, 9028)
OAELever:register()
