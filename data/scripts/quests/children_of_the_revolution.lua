local zeeKillingFieldzzChest = Action()

function zeeKillingFieldzzChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline) == 9 then
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline, 10)
		player:addItem(10760, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a flask of poison.")
	elseif player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.StrangeSymbols) == 2 then
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.StrangeSymbols, 3)
		player:addItem(11106, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a flask of extra greasy oil.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
	end
	return true
end

zeeKillingFieldzzChest:uid(3164)
zeeKillingFieldzzChest:register()

local zeeKillingFieldzzPoisonWater = Action()

function zeeKillingFieldzzPoisonWater.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 8012 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline) == 10 then
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline, 11)
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission03, 2) --Questlog, Children of the Revolution "Mission 3: Zee Killing Fieldzz"
		item:remove()
		player:say("The rice has been poisoned. This will weaken the Emperor's army significantly. Return and tell Zalamon about your success.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

zeeKillingFieldzzPoisonWater:id(10760)
zeeKillingFieldzzPoisonWater:register()

local zeeWayofZztonezzLevers = Action()

local leverChange = {
	[1] = {1, 3, 2, 4},
	[2] = {2, 1, 3, 4},
	[3] = {2, 3, 1, 4},
	[4] = {3, 2, 4, 1},
	[5] = {4, 2, 1, 3}
}

local position = {
	[1] = {
		Position(33355, 31126, 7),
		Position(33356, 31126, 7),
		Position(33357, 31126, 7),
		Position(33358, 31126, 7)
	},
	[2] = {
		Position(33352, 31126, 5),
		Position(33353, 31126, 5),
		Position(33354, 31126, 5),
		Position(33355, 31126, 5)
	}
}

function zeeWayofZztonezzLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 8013 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline) ~= 14 then
		player:say("The lever does not budge.", TALKTYPE_MONSTER_SAY)
		return true
	end

	local lever, tmp, ground = toPosition.y - 31122, {}
	for i = 1, #position[1] do
		ground = Tile(position[1][i]):getGround()
		if ground then
			tmp[i] = ground.itemid
		end
	end

	for i = 1, #position[2] do
		ground = Tile(position[2][i]):getGround()
		if ground then
			ground:transform(tmp[leverChange[lever][i]])
			ground:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	end

	local groundIds, pass = {10856, 10853, 10855, 10850}, 0
	for i = 1, #position[2] do
		ground = Tile(position[2][i]):getGround()
		if ground and ground.itemid == groundIds[i] then
			pass = pass + 1
		end
	end

	if pass ~= 4 then
		return true
	end

	player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline, 17)
	player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission04, 5) --Questlog, Children of the Revolution "Mission 4: Zze Way of Zztonezz"
	player:say("After a cracking noise a deep humming suddenly starts from somewhere below.", TALKTYPE_MONSTER_SAY)

	target:transform(target.itemid == 10044 and 10045 or 10044)
	return true
end

zeeWayofZztonezzLevers:aid(8013)
zeeWayofZztonezzLevers:register()

local zeeWayofZztonezzGreaseOil = Action()

function zeeWayofZztonezzGreaseOil.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 8013 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline) == 13 then
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline, 14)
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission04, 4) --Questlog, Children of the Revolution "Mission 4: Zze Way of Zztonezz"
		item:remove()
		player:say("Due to being extra greasy, the leavers can now be moved.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

zeeWayofZztonezzGreaseOil:id(11106)
zeeWayofZztonezzGreaseOil:register()

local zalamonDoor = Action()

function zalamonDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Mission08) >= 2 and player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission11) < 2 then
		if item.itemid == 10791 then
			player:teleportTo(toPosition, true)
			item:transform(item.itemid + 1)
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
	end
	return true
end

zalamonDoor:uid(3170)
zalamonDoor:register()

local temple = MoveEvent()

function temple.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline) == 4 then --Questlog, Children of the Revolution 'Mission 1: Corruption'
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission01, 2)
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline, 5)
		player:say('The temple has been corrupted and is lost. Zalamon should be informed about this as soon as possible.', TALKTYPE_MONSTER_SAY)
	end
	return true
end

temple:type("stepin")
temple:uid(3163)
temple:register()

local symbols = MoveEvent()

function symbols.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.StrangeSymbols) < 1 and player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission03) >= 2 then --Questlog, Children of the Revolution 'Mission 4: Zze Way of Zztonezz'
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission04, 2)
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.StrangeSymbols, 1)
		player:say('A part of the floor before you displays an arrangement of strange symbols.', TALKTYPE_MONSTER_SAY)
	end
	return true
end

symbols:type("stepin")
symbols:uid(3166)
symbols:register()

local spy = MoveEvent()

local config = {
	[8009] = {storageKey = PlayerStorageKeys.ChildrenoftheRevolution.SpyBuilding01, text = 'An impressive ammount of fish is stored here.'},
	[8010] = {storageKey = PlayerStorageKeys.ChildrenoftheRevolution.SpyBuilding02, text = 'A seemingly endless array of weapon stretches before you into the darkness.'},
	[8011] = {storageKey = PlayerStorageKeys.ChildrenoftheRevolution.SpyBuilding03, text = 'These barracks seem to be home for quite a lot of soldiers.'}
}

function spy.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetTile = config[item.actionid]
	if not targetTile then
		return true
	end

	if player:getStorageValue(targetTile.storageKey) < 1 then --Questlog, Children of the Revolution 'Mission 2: Imperial Zzecret Weaponzz'
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission02, player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission02) + 1)
		player:setStorageValue(targetTile.storageKey, 1)
		player:say(targetTile.text, TALKTYPE_MONSTER_SAY)
	end
	return true
end

spy:type("stepin")
spy:aid(8009, 8010, 8011)
spy:register()

local teleport = MoveEvent()

local config = {
	[3167] = {storageKey = PlayerStorageKeys.ChildrenoftheRevolution.Questline, toPosition = {Position(33257, 31116, 8), Position(33356, 31126, 7)}},
	[3168] = {storageKey = PlayerStorageKeys.ChildrenoftheRevolution.Questline, toPosition = {Position(33356, 31125, 7), Position(33261, 31079, 8)}}
}

function teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetTile = config[item.uid]
	if not targetTile then
		return true
	end

	local hasStorageValue = player:getStorageValue(targetTile.storageKey) >= 19
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(targetTile.toPosition[hasStorageValue and 1 or 2])
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	if not hasStorageValue then
		player:say('This portal should not be entered unprepared', TALKTYPE_MONSTER_SAY)
	end
	return true
end

teleport:type("stepin")
teleport:uid(3167, 3168)
teleport:register()

local stairs = MoveEvent()

local stairsPosition = Position(33265, 31116, 7)

local function revertStairs()
	Tile(stairsPosition):getItemById(9197):transform(3219)
end

function stairs.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if not Tile(position):getItemById(3687) then
		return true
	end

	local stairs = Tile(stairsPosition):getItemById(3219)
	if stairs then
		stairs:transform(9197)
		addEvent(revertStairs, 5 * 30 * 1000)
	end

	player:say('The area around the gate is suspiciously quiet, you have a bad feeling about this.', TALKTYPE_MONSTER_SAY)
	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission05) == 1 then --Questlog, Children of the Revolution 'Mission 5: Phantom Army'
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission05, 2)
	end
	return true
end

stairs:type("stepin")
stairs:uid(3169)
stairs:register()

local click = MoveEvent()

local config = {
	positions = {
		Position(33258, 31080, 8),
		Position(33266, 31084, 8),
		Position(33259, 31089, 8),
		Position(33263, 31093, 8)
	},
	stairPosition = Position(33265, 31116, 8),
	areaCenter = Position(33268, 31119, 7),
	zalamonPosition = Position(33353, 31410, 8),

	summonArea = {
		from = Position(33252, 31105, 7),
		to = Position(33288, 31134, 7)
	},
	waves = {
		{monster = 'eternal guardian', size = 20},
		{monster = 'eternal guardian', size = 20},
		{monster = 'eternal guardian', size = 20},
		{monster = 'lizard chosen', size = 20}
	}
}

function doClearMissionArea()
	Game.setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission05, -1)

	local spectators, spectator = Game.getSpectators(config.areaCenter, false, true, 26, 26, 20, 20)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(config.zalamonPosition)
			spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			if spectator:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline) == 19 then
				spectator:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline, 20)
			end
		else
			spectator:remove()
		end
	end
	return true
end

local function removeStairs()
	local stair = Tile(config.stairPosition):getItemById(3687)
	if stair then
		stair:transform(3653)
	end
end

local function summonWave(i)
	local wave = config.waves[i]
	local summonPosition
	for i = 1, wave.size do
		summonPosition = Position(math.random(config.summonArea.from.x, config.summonArea.to.x), math.random(config.summonArea.from.y, config.summonArea.to.y), 7)
		Game.createMonster(wave.monster, summonPosition)
		summonPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end
end

function click.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline) ~= 19
		or Game.getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission05) == 1 then
		return true
	end

	local players = {}
	for i = 1, #config.positions do
		local creature = Tile(config.positions[i]):getTopCreature()
		if creature and creature:isPlayer() then
			players[#players + 1] = creature
		end
	end

	if #players ~= #config.positions then
		return true
	end

	for i = 1, #players do
		players[i]:say('A clicking sound tatters the silence.', TALKTYPE_MONSTER_SAY)
	end

	local stair = Tile(config.stairPosition):getItemById(3653)
	if stair then
		stair:transform(3687)
	end
	Game.setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission05, 1)

	for wave = 1, #config.waves do
		addEvent(summonWave, wave * 30 * 1000, wave)
	end
	addEvent(removeStairs, 30 * 1000)
	addEvent(doClearMissionArea, 5 * 30 * 1000)
	return true
end

click:type("stepin")
click:uid(8014)
click:register()
