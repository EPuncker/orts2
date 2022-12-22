local bargateLever = Action()

local config = {
	gatePositions = {
		Position(32569, 31421, 9),
		Position(32569, 31422, 9)
	},

	leverPositions = {
		Position(32568, 31421, 9),
		Position(32570, 31421, 9)
	},

	removeCreaturePosition = Position(32568, 31422, 9),
	wallID = 3519,
	wallID2 = 3524,
	tileID = 3154
}

function bargateLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile, thing, thing2 , creature, lever, leverstatus
	leverstatus = item.itemid
	for i = 1, #config.leverPositions do
		lever = Tile(config.leverPositions[i]):getItemById(leverstatus == 1945 and 1945 or 1946)
		lever:transform(item.itemid == 1945 and 1946 or 1945)
	end

	for i = 1, #config.gatePositions do
		tile = Tile(config.gatePositions[i])
		if tile then
			creature = tile:getTopCreature()
			if leverstatus == 1945 then
				thing = tile:getItemById(config.wallID)
				thing2 = tile:getItemById(config.wallID2)
				if thing and thing2 then
					thing:remove()
					thing2:remove()
				end
			else
				Game.createItem(config.wallID, 1, config.gatePositions[i])
				Game.createItem(config.wallID2, 1, config.gatePositions[i])
			end

			if creature then
				creature:teleportTo(config.removeCreaturePosition)
			end
		end
	end
	return true
end

bargateLever:aid(12606)
bargateLever:register()

local deeperMineWagon = Action()

local config = {
	[1] = Position(32566, 31505, 9),
	[2] = Position(32611, 31513, 9)
}

function deeperMineWagon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[player:getStorageValue(PlayerStorageKeys.hiddenCityOfBeregar.RoyalRescue)]
	if not targetPosition then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have permission to use this yet.")
		return true
	end

	player:teleportTo(targetPosition, true)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

deeperMineWagon:aid(50128)
deeperMineWagon:register()

local oreWagon = Action()

local config = {
	[50098] = Position(32687, 31470, 13),
	[50099] = Position(32600, 31504, 13),
	[50100] = Position(32604, 31338, 11),
	[50101] = Position(32611, 31513, 9),
	[50102] = Position(32652, 31507, 10),
	[50103] = Position(32692, 31501, 11),
	[50104] = Position(32687, 31470, 13),
	[50105] = Position(32687, 31470, 13),
	[50106] = Position(32687, 31470, 13),
	[50107] = Position(32580, 31487, 9),
	[50108] = Position(32687, 31470, 13),
	[50109] = Position(32617, 31514, 9)
}

function oreWagon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.actionid]
	if not targetPosition then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.hiddenCityOfBeregar.OreWagon) == 1 then
		player:teleportTo(targetPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't know how to use this yet.")
	return true
end

oreWagon:aid(50098, 50099, 50100, 50101, 50102, 50103, 50104, 50105, 50106, 50107, 50108, 50109)
oreWagon:register()

local gapWagon = Action()

function gapWagon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(Position(32571, 31508, 9))
	if tile and tile:getItemById(7122) and player:getStorageValue(PlayerStorageKeys.hiddenCityOfBeregar.RoyalRescue) == 1 then
		player:setStorageValue(PlayerStorageKeys.hiddenCityOfBeregar.RoyalRescue, 2)
		player:teleportTo(Position(32578, 31507, 9))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You safely passed the gap but your bridge collapsed behind you.", TALKTYPE_MONSTER_SAY, false, 0, player:getPosition())

		local thing = tile:getItemById(7122)
		if thing then
			thing:remove()
		end

		local secondThing = tile:getItemById(5779)
		if secondThing then
			secondThing:remove()
		end
	else
		player:teleportTo(Position(32580, 31487, 9))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You need to build a bridge to pass the gap.", TALKTYPE_MONSTER_SAY, false, 0, player:getPosition())
	end
	return true
end

gapWagon:aid(50112)
gapWagon:register()

local tunnelWagon = Action()

function tunnelWagon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Tile(Position(32619, 31514, 9)):getItemById(5709) then
		player:teleportTo(Position(32580, 31487, 9))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say("You need to build a bridge to pass the gap.", TALKTYPE_MONSTER_SAY, false, 0, player:getPosition())
		return false
	end

	player:setStorageValue(PlayerStorageKeys.hiddenCityOfBeregar.RoyalRescue, 3)
	player:teleportTo(Position(32625, 31514, 9))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:say("You safely passed the tunnel.", TALKTYPE_MONSTER_SAY, false, 0, player:getPosition())
	Game.createItem(5709, 1, Position(32619, 31514, 9))

	local tile = Tile(Position(32617, 31513, 9))
	if tile then
		local thing = tile:getItemById(1027)
		if thing then
			thing:remove()
		end
	end

	local secondTile = Tile(Position(32617, 31513, 9))
	if secondTile then
		local thing = tile:getItemById(1205)
		if thing then
			thing:remove()
		end
	end
	return true
end

tunnelWagon:aid(50115)
tunnelWagon:register()

local coalWagon = Action()

local wagons = {
	[7131] = Position(32717, 31492, 11),
	[8749] = Position(32699, 31492, 11)
}

function coalWagon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local lastPosition = wagons[item.itemid]
	if not lastPosition then
		return false
	end

	local wagonPosition = item:getPosition()
	if wagonPosition == lastPosition then
		return false
	end

	local tile = Tile(wagonPosition)
	if item.itemid == 7131 then
		wagonPosition.x = wagonPosition.x + 2
		tile:getTopTopItem():moveTo(wagonPosition)
	elseif item.itemid == 8749 and item.actionid == 50117 then
		wagonPosition.x = wagonPosition.x - 2
		tile:getItemById(7131):moveTo(wagonPosition)
		tile:getItemById(8749):moveTo(wagonPosition)
	end

	player:say("SQUEEEEAK", TALKTYPE_MONSTER_SAY, false, 0, wagonPosition)
	return true
end

coalWagon:aid(50117)
coalWagon:register()

local coalLevers = Action()

local config = {
	[50108] = {actionId = 50122, wagonPos = Position(32696, 31495, 11)},
	[50109] = {actionId = 50123, wagonPos = Position(32694, 31495, 11)},
	[50110] = {actionId = 50124, wagonPos = Position(32692, 31495, 11)},
	[50111] = {actionId = 50125, wagonPos = Position(32690, 31495, 11)}
}

function coalLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.uid]
	if not useItem then
		return true
	end

	local machine = Tile(Position(32699, 31494, 11)):getItemById(8641)
	if not machine then
		return false
	end

	if machine.actionid == 50121 then
		local wagon = Game.createItem(7132, 1, useItem.wagonPos)
		if wagon then
			wagon:setActionId(useItem.actionId)
		end

		machine:transform(8642)
	end

	item:transform(item.itemid == 10044 and 10045 or 10044)
	return true
end

coalLevers:uid(50108, 50109, 50110, 50111)
coalLevers:register()

local coalExitWagons = Action()

local config = {
	[50122] = Position(32704, 31507, 12), -- small tunnel with golems
	[50123] = Position(32661, 31495, 13), -- mushroom quest
	[50124] = Position(32687, 31470, 13), -- wagon maze
	[50125] = Position(32690, 31495, 11) -- room with lava that I couldn't find, setting destination to the same as mushroom quest
}

function coalExitWagons.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.actionid]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	item:remove()
	return true
end

coalExitWagons:aid(50122, 50123, 50124, 50125)
coalExitWagons:register()

local wagonMazeLevers = Action()

local levers = {
	[50113] = Position(32696, 31453, 13),
	[50114] = Position(32692, 31453, 13),
	[50115] = Position(32687, 31452, 13),
	[50116] = Position(32682, 31455, 13),
	[50117] = Position(32688, 31456, 13),
	[50118] = Position(32692, 31459, 13),
	[50119] = Position(32696, 31461, 13),
	[50120] = Position(32695, 31464, 13),
	[50121] = Position(32690, 31465, 13),
	[50122] = Position(32684, 31464, 13),
	[50123] = Position(32688, 31469, 13)
}

function wagonMazeLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local lever = levers[item.uid]
	if lever then
		local tile = Tile(lever)
		if tile:getItemById(7130) then
			tile:getItemById(7130):transform(7121)
		else
			local targetItem = tile:getItems()[1]
			targetItem:transform(targetItem:getId() + 1)
		end
	end

	item:transform(item.itemid == 10044 and 10045 or 10044)
	return true
end

wagonMazeLevers:uid(50113, 50114, 50115, 50116, 50117, 50118, 50119, 50120, 50121, 50122, 50123)
wagonMazeLevers:register()

local wagonMazeExit = Action()

function wagonMazeExit.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local destinations = {
		{teleportPos = Position(32692, 31501, 11), railCheck = Tile(Position(32688, 31469, 13)):getItemById(7124) and Tile(Position(32690, 31465, 13)):getItemById(7122)}, -- Coal Room
		{teleportPos = Position(32549, 31407, 11), railCheck = Tile(Position(32688, 31469, 13)):getItemById(7124) and Tile(Position(32690, 31465, 13)):getItemById(7125) and Tile(Position(32684, 31464, 13)):getItemById(7123)}, -- Infested Tavern
		{teleportPos = Position(32579, 31487, 9), railCheck = Tile(Position(32688, 31469, 13)):getItemById(7124) and Tile(Position(32690, 31465, 13)):getItemById(7125) and Tile(Position(32684, 31464, 13)):getItemById(7122) and Tile(Position(32682, 31455, 13)):getItemById(7124)}, -- Beregar
		{teleportPos = Position(32701, 31448, 15), railCheck = Tile(Position(32688, 31469, 13)):getItemById(7124) and Tile(Position(32690, 31465, 13)):getItemById(7125) and Tile(Position(32684, 31464, 13)):getItemById(7122) and Tile(Position(32682, 31455, 13)):getItemById(7121) and Tile(Position(32687, 31452, 13)):getItemById(7125) and Tile(Position(32692, 31453, 13)):getItemById(7126)}, -- NPC Tehlim
		{teleportPos = Position(32721, 31487, 15), railCheck = Tile(Position(32688, 31469, 13)):getItemById(7121) and Tile(Position(32692, 31459, 13)):getItemById(7123) and Tile(Position(32696, 31453, 13)):getItemById(7123)}, -- Troll tribe's hideout
		{teleportPos = Position(32600, 31504, 13), railCheck = Tile(Position(32688, 31469, 13)):getItemById(7123) and Tile(Position(32695, 31464, 13)):getItemById(7123)} -- City's Entrance
	}

	for i = 1, #destinations do
		local destination = destinations[i]
		if destination.railCheck then
			player:teleportTo(destination.teleportPos)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end
	return true
end

wagonMazeExit:uid(50124)
wagonMazeExit:register()

local ladder = Action()

function ladder.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:teleportTo(Position(32680, 31508, 10))
	return true
end

ladder:id(10035)
ladder:register()

local oreWagon = MoveEvent()

function oreWagon.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.hiddenCityOfBeregar.OreWagon) ~= 1 then
		player:setStorageValue(PlayerStorageKeys.hiddenCityOfBeregar.OreWagon, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found the entrance to the hidden city of Beregar and may now use the ore wagon.')
	end
	return true
end

oreWagon:type("stepin")
oreWagon:aid(50091)
oreWagon:register()

local elevator = MoveEvent()

local config = {
	[50092] = Position(32612, 31499, 15),
	[50093] = Position(32612, 31499, 14)
}

function elevator.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = config[item.actionid]
	if not teleport then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.hiddenCityOfBeregar.GoingDown) == 2 then
		player:teleportTo(teleport)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You don\'t know how to use this yet.')
	end
	return true
end

elevator:type("stepin")
elevator:aid(50092, 50093)
elevator:register()

local gap = MoveEvent()

function gap.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:teleportTo(Position(32569, 31507, 9))
	player:say('Use the wagon to pass the gap.', TALKTYPE_MONSTER_SAY)
	return true
end

gap:type("stepin")
gap:aid(50111)
gap:register()

local tunel = MoveEvent()

function tunel.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:teleportTo(Position(32616, 31514, 9))
	player:say('Use the ore wagon to pass this spot.', TALKTYPE_MONSTER_SAY)
	return true
end

tunel:type("stepin")
tunel:aid(50116)
tunel:register()

local bellow = MoveEvent()

function bellow.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	local crucibleItem = Tile(Position(32699, 31495, 11)):getItemById(10040)
	if not crucibleItem then
		return true
	end

	if crucibleItem.actionid == 0 then
		crucibleItem:setActionId(50120)
		Position(32696, 31494, 11):sendMagicEffect(CONST_ME_POFF)
	elseif crucibleItem.actionid == 50120 then
		crucibleItem:setActionId(50121)
		Position(32695, 31494, 10):sendMagicEffect(CONST_ME_POFF)
	elseif crucibleItem.actionid == 50121 then
		Tile(Position(32699, 31494, 11)):getItemById(8641):setActionId(50121)
		creature:say('TSSSSHHHHH', TALKTYPE_MONSTER_SAY, false, 0, Position(32695, 31494, 11))
		creature:say('CHOOOOOOOHHHHH', TALKTYPE_MONSTER_SAY, false, 0, Position(32698, 31492, 11))
	end
	return true
end

bellow:type("stepin")
bellow:uid(50107)
bellow:register()

local pythiusTeleport = MoveEvent()

function pythiusTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.hiddenCityOfBeregar.PythiusTheRotten) < os.time() then
		position.y = position.y + 4
		player:teleportTo(position)
		player:say("OFFER ME SOMETHING IF YOU WANT TO PASS!", TALKTYPE_MONSTER_YELL, false, player, Position(32589, 31407, 15))
		position:sendMagicEffect(CONST_ME_FIREAREA)
		return true
	end

	local destination = Position(32601, 31397, 14)
	player:teleportTo(destination)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

pythiusTeleport:type("stepin")
pythiusTeleport:uid(50127)
pythiusTeleport:register()

local pythiusBossTeleport = MoveEvent()

local function roomIsOccupied()
	local spectators = Game.getSpectators(Position(32566, 31406, 15), false, true, 7, 7)
	if #spectators ~= 0 then
		return true
	end

	return false
end

function pythiusBossTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 50126 then
		if player:getStorageValue(PlayerStorageKeys.QuestChests.FirewalkerBoots) == 1 or roomIsOccupied() then
			player:teleportTo(fromPosition)
			fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end

		item:remove()

		local steamPosition = Position(32551, 31379, 15)
		iterateArea(
			function(position)
				local groundItem = Tile(position):getGround()
				if groundItem and groundItem.itemid == 5815 then
					groundItem:transform(598)
				end
			end,
			Position(32550, 31373, 15),
			steamPosition
		)

		Game.createItem(1304, 1, steamPosition)
		local steamItem = Game.createItem(9341, 1, steamPosition)
		if steamItem then
			steamItem:setActionId(50127)
		end

		local destination = Position(32560, 31404, 15)
		player:teleportTo(destination)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		destination:sendMagicEffect(CONST_ME_TELEPORT)

		local monster = Game.createMonster('Pythius the Rotten', Position(32571, 31406, 15))
		if monster then
			monster:say("WHO IS SNEAKING AROUND BEHIND MY TREASURE?", TALKTYPE_MONSTER_YELL, false, player)
		end
	else
		local spectators, spectator = Game.getSpectators(Position(32566, 31406, 15), false, false, 7, 7)
		for i = 1, #spectators do
			spectator = spectators[i]
			if spectator:isMonster() then
				spectator:remove()
			end
		end

		local destination = Position(32552, 31378, 15)
		player:teleportTo(destination)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

pythiusBossTeleport:type("stepin")
pythiusBossTeleport:aid(50125, 50126)
pythiusBossTeleport:register()

local bridgeTeleport = MoveEvent()

function bridgeTeleport.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	creature:teleportTo(Position(32637, 31509, 10))
	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

bridgeTeleport:type("stepin")
bridgeTeleport:aid(50199)
bridgeTeleport:register()
