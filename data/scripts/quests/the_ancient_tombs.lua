local oasisTombLeverDoor = Action()

local function revertCarrotAndLever(position, carrotPosition)
	local leverItem = Tile(position):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end

	local carrotItem = Tile(carrotPosition):getItemById(2684)
	if carrotItem then
		carrotItem:remove()
	end
end

function oasisTombLeverDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1243 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You first must find the Carrot under one of the three hats to get the access!')
		return true
	end

	if item.itemid ~= 1945 then
		return true
	end

	local doorPosition = Position(33122, 32765, 14)
	if math.random(3) == 1 then
		local hatPosition = Position(toPosition.x - 1, toPosition.y, toPosition.z)
		hatPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		doorPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		Game.createItem(2684, 1, hatPosition)

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You found the carrot! The door is open!')
		item:transform(1946)
		addEvent(revertCarrotAndLever, 4 * 1000, toPosition, hatPosition)

		local doorItem = Tile(doorPosition):getItemById(1243)
		if doorItem then
			doorItem:transform(1244)
		end
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You guessed wrong! Take this! Carrot changed now the Hat!')
	doAreaCombatHealth(player, COMBAT_PHYSICALDAMAGE, player:getPosition(), 0, -200, -200, CONST_ME_POFF)
	return true
end

oasisTombLeverDoor:aid(12107)
oasisTombLeverDoor:register()

local ancientRuinsTombInstruments = Action()

local config = {
	[2367] = 1,
	[2373] = 2,
	[2370] = 3,
	[2372] = 4,
	[2369] = 5,
	[1241] = 5
}

function ancientRuinsTombInstruments.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetTable = config[item.itemid]
	local storage = PlayerStorageKeys.TheAncientTombs.VashresamunInstruments
	if not targetTable then
		player:setStorageValue(storage, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You played them wrong, now you must begin with first again!')
		doTargetCombat(0, player, COMBAT_PHYSICALDAMAGE, -20, -20, CONST_ME_GROUNDSHAKER)
		return true
	end

	if player:getStorageValue(storage) == targetTable and targetTable < 4 then
		player:setStorageValue(storage, math.max(1, player:getPlayerStorageValue(storage)) + 1)
		fromPosition:sendMagicEffect(CONST_ME_SOUND_BLUE)
	else
		player:setStorageValue(storage, 5)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You played them in correct order and got the access through door!')
	end

	if item.itemid == 1241 and player:getStorageValue(storage) == 5 then
		player:teleportTo(toPosition, true)
		item:transform(item.itemid + 1)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You first must play the instruments in correct order to get the access!")
	end
	return true
end

ancientRuinsTombInstruments:aid(12105)
ancientRuinsTombInstruments:register()

local activeTeleportSwitches = Action()

local config = {
	[50242] = GlobalStorageKeys.TheAncientTombs.ThalasSwitchesGlobalStorage,
	[50243] = GlobalStorageKeys.TheAncientTombs.DiprathSwitchesGlobalStorage,
	[50244] = GlobalStorageKeys.TheAncientTombs.AshmunrahSwitchesGlobalStorage
}

local function resetScript(position, storage)
	local item = Tile(position):getItemById(1946)
	if item then
		item:transform(1945)
	end

	Game.setStorageValue(storage, Game.getStorageValue(storage) - 1)
end

function activeTeleportSwitches.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local storage = config[item.actionid]
	if not storage then
		return true
	end

	if item.itemid ~= 1945 then
		return false
	end

	Game.setStorageValue(storage, Game.getStorageValue(storage) + 1)
	item:transform(1946)
	addEvent(resetScript, 4 * 60 * 1000, toPosition, storage)
	return true
end

activeTeleportSwitches:aid(50242, 50243, 50244)
activeTeleportSwitches:register()

local peninsulaTombmaze = MoveEvent()

function peninsulaTombmaze.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:teleportTo(fromPosition)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

peninsulaTombmaze:type("stepin")
peninsulaTombmaze:aid(12101)
peninsulaTombmaze:register()

local tombTeleports = MoveEvent()

local config = {
	[3950] = {removeId = 2350, destination = Position(33182, 32714, 14), exitDestination = Position(33231, 32705, 8)}, -- from Morguthis Boss
	[3951] = {removeId = 2351, destination = Position(33174, 32934, 15), exitDestination = Position(33282, 32744, 8)}, -- from Thalas Boss
	[3952] = {removeId = 2353, destination = Position(33126, 32591, 15), exitDestination = Position(33250, 32832, 8)}, -- from Mahrdis Boss
	[3953] = {removeId = 2352, destination = Position(33145, 32665, 15), exitDestination = Position(33025, 32868, 8)}, -- from Omruc Boss
	[3954] = {removeId = 2348, destination = Position(33041, 32774, 14), exitDestination = Position(33133, 32642, 8)}, -- from Rahemos Boss
	[3955] = {removeId = 2354, destination = Position(33349, 32827, 14), exitDestination = Position(33131, 32566, 8)}, -- from Dipthrah Boss
	[3956] = {removeId = 2349, destination = Position(33186, 33012, 14), exitDestination = Position(33206, 32592, 8)} -- from Vashresamun Boss
}

function tombTeleports.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = config[item.uid]
	if not teleport then
		return true
	end

	if not player:removeItem(teleport.removeId, 1) then
		player:teleportTo(teleport.exitDestination)
		teleport.exitDestination:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	player:teleportTo(teleport.destination)
	teleport.destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

tombTeleports:type("stepin")
tombTeleports:uid(3950, 3951, 3952, 3953, 3954, 3955, 3956)
tombTeleports:aid(12108)
tombTeleports:register()

local craftHelmet = MoveEvent()

function craftHelmet.onAddItem(moveitem, tileitem, position)
	if moveitem.itemid == 2147 then
		local tile = Tile(position):getItemById(2342)
		if not tile then
			return true
		end

		tile:transform(2343)
		tile:decay()
		position:sendMagicEffect(CONST_ME_FIREAREA)
		Item(moveitem.uid):remove(1)
		return true
	end

	local helmetIds = {2335, 2336, 2337, 2338, 2339, 2340, 2341}
	if not table.contains(helmetIds, moveitem.itemid) then
		return true
	end

	local tile, helmetItems = Tile(position), {}
	local helmetItem
	for i = 1, #helmetIds do
		helmetItem = tile:getItemById(helmetIds[i])
		if not helmetItem then
			return true
		end

		helmetItems[#helmetItems + 1] = helmetItem
	end

	for i = 1, #helmetItems do
		helmetItems[i]:remove()
	end

	Game.createItem(2342, 1, position)
	position:sendMagicEffect(CONST_ME_FIREAREA)
	return true
end

craftHelmet:type("additem")
craftHelmet:aid(60626)
craftHelmet:register()

local enterThalasTeleportSwitchesDone = MoveEvent()

function enterThalasTeleportSwitchesDone.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if Game.getStorageValue(GlobalStorageKeys.TheAncientTombs.ThalasSwitchesGlobalStorage) < 8 then
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local destination = Position(33367, 32805, 14)
	player:teleportTo(Position(33367, 32805, 14))
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

enterThalasTeleportSwitchesDone:type("stepin")
enterThalasTeleportSwitchesDone:uid(50135)
enterThalasTeleportSwitchesDone:register()

local enterThalasPoisonTile = MoveEvent()

local condition = Condition(CONDITION_POISON, CONDITIONID_COMBAT)
condition:setParameter(CONDITION_PARAM_DELAYED, true)
condition:setParameter(CONDITION_PARAM_MINVALUE, 20)
condition:setParameter(CONDITION_PARAM_MAXVALUE, 70)
condition:setParameter(CONDITION_PARAM_STARTVALUE, 50)
condition:setParameter(CONDITION_PARAM_TICKINTERVAL, 6000)
condition:setParameter(CONDITION_PARAM_FORCEUPDATE, true)

function enterThalasPoisonTile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:getPosition():sendMagicEffect(CONST_ME_GREEN_RINGS)
	player:addCondition(condition)
	item:transform(417)
	return true
end

enterThalasPoisonTile:type("stepin")
enterThalasPoisonTile:uid(50136)
enterThalasPoisonTile:register()

local enterDiprathTeleportSwitchesDone = MoveEvent()

function enterDiprathTeleportSwitchesDone.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if Game.getStorageValue(GlobalStorageKeys.TheAncientTombs.DiprathSwitchesGlobalStorage) < 11 then
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local destination = Position(33083, 32568, 14)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

enterDiprathTeleportSwitchesDone:type("stepin")
enterDiprathTeleportSwitchesDone:uid(50137)
enterDiprathTeleportSwitchesDone:register()

local enterAshmunrahTeleportSwitchesDone = MoveEvent()

function enterAshmunrahTeleportSwitchesDone.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if Game.getStorageValue(GlobalStorageKeys.TheAncientTombs.AshmunrahSwitchesGlobalStorage) < 6 then
		player:teleportTo(fromPosition, true)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local destination = Position(33198, 32885, 11)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

enterAshmunrahTeleportSwitchesDone:type("stepin")
enterAshmunrahTeleportSwitchesDone:uid(50138)
enterAshmunrahTeleportSwitchesDone:register()

local stepMorguthisBlueFlames = MoveEvent()

local config = {
	[50139] = PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage1,
	[50140] = PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage2,
	[50141]	= PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage3,
	[50142]	= PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage4,
	[50143] = PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage5,
	[50144] = PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage6,
	[50145] = PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage7
}

function stepMorguthisBlueFlames.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local tableTarget = config[item.uid]
	if tableTarget then
		if player:getStorageValue(tableTarget) ~= 1 then
			player:setStorageValue(tableTarget, 1)
		end

		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	else
		local missingStorage = false
		for i = PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage1, PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage7 do
			if player:getStorageValue(i) ~= 1 then
				missingStorage = true
				break
			end
		end

		if missingStorage then
			player:teleportTo(fromPosition, true)
			fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end

		player:teleportTo(Position(33163, 32694, 14))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

stepMorguthisBlueFlames:type("stepin")
stepMorguthisBlueFlames:uid(50139, 50140, 50141, 50142, 50143, 50144, 50145, 50146)
stepMorguthisBlueFlames:register()
