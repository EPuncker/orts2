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
