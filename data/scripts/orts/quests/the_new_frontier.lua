local arena = Action()

local config = {
	bosses = {
		{'Baron Brute', 'The Axeorcist'},
		{'Menace', 'Fatality'},
		{'Incineron', 'Coldheart'},
		{'Dreadwing', 'Doomhowl'},
		{'Haunter', 'The Dreadorian'},
		{'Rocko', 'Tremorak'},
		{'Tirecz'}
	},

	teleportPositions = {
		Position(33059, 31032, 3),
		Position(33057, 31034, 3)
	},

	positions = {
		-- other bosses
		Position(33065, 31035, 3),
		Position(33068, 31034, 3),

		-- first 2 bosses
		Position(33065, 31033, 3),
		Position(33066, 31037, 3)
	}
}

local function summonBoss(name, position)
	Game.createMonster(name, position)
	position:sendMagicEffect(CONST_ME_TELEPORT)
end

local function clearArena()
	local spectators = Game.getSpectators(Position(33063, 31034, 3), false, false, 10, 10, 10, 10)
	local exitPosition = Position(33049, 31017, 2)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(exitPosition)
			exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		else
			spectator:remove()
		end
	end
end

function arena.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local player1 = Tile(Position(33080, 31014, 2)):getTopCreature()
	if not(player1 and player1:isPlayer()) then
		return true
	end

	local player2 = Tile(Position(33081, 31014, 2)):getTopCreature()
	if not(player2 and player2:isPlayer()) then
		return true
	end

	if player1:getStorageValue(PlayerStorageKeys.TheNewFrontier.Questline) ~= 25 then
		player1:sendTextMessage(MESSAGE_STATUS_SMALL, 'You already finished this battle.')
		return true
	end

	if Game.getStorageValue(PlayerStorageKeys.TheNewFrontier.Mission09) == 1 then
		player1:sendTextMessage(MESSAGE_STATUS_SMALL, 'The arena is already in use.')
		return true
	end

	Game.setStorageValue(PlayerStorageKeys.TheNewFrontier.Mission09, 1)
	addEvent(clearArena, 30 * 60 * 1000)
	player1:teleportTo(config.teleportPositions[1])
	player1:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player2:teleportTo(config.teleportPositions[2])
	player2:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	for i = 1, #config.bosses do
		for j = 1, #config.bosses[i] do
			addEvent(summonBoss, (i - 1) * 90 * 1000, config.bosses[i][j], config.positions[j + (i == 1 and 2 or 0)])
		end
	end
	return true
end

arena:uid(3157)
arena:register()

local beaver = Action()

function beaver.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 8002 then
		if player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Questline) == 5 and player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Beaver1) < 1 then
			Game.createMonster("thieving squirrel", toPosition)
			toPosition:sendMagicEffect(CONST_ME_TELEPORT)
			player:setStorageValue(PlayerStorageKeys.TheNewFrontier.Beaver1, 1)
			player:setStorageValue(PlayerStorageKeys.TheNewFrontier.Mission02, player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Mission02) + 1) --Questlog, The New Frontier Quest "Mission 02: From Kazordoon With Love"
			Game.createMonster("thieving squirrel", toPosition)
			player:say("You've marked the tree, but its former inhabitant has stolen your bait! Get it before it runs away!", TALKTYPE_MONSTER_SAY)
			item:remove()
		end
	elseif target.actionid == 8003 then
		if player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Questline) == 5 and player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Beaver2) < 1 then
			for i = 1, 5 do
				pos = toPosition
				Game.createMonster("wolf", pos)
				toPosition:sendMagicEffect(CONST_ME_TELEPORT)
			end

			Game.createMonster("war wolf", toPosition)
			toPosition:sendMagicEffect(CONST_ME_TELEPORT)
			player:setStorageValue(PlayerStorageKeys.TheNewFrontier.Beaver2, 1)
			player:setStorageValue(PlayerStorageKeys.TheNewFrontier.Mission02, player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Mission02) + 1) --Questlog, The New Frontier Quest "Mission 02: From Kazordoon With Love"
			player:say("You have marked the tree but it seems someone marked it already! He is not happy with your actions and he brought friends!", TALKTYPE_MONSTER_SAY)
		end
	elseif target.actionid == 8004 then
		if player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Questline) == 5 and player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Beaver3) < 1 then
			for i = 1, 3 do
				pos = toPosition
				Game.createMonster("enraged squirrel", pos)
				toPosition:sendMagicEffect(CONST_ME_TELEPORT)
			end

			player:setStorageValue(PlayerStorageKeys.TheNewFrontier.Beaver3, 1)
			player:setStorageValue(PlayerStorageKeys.TheNewFrontier.Mission02, player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Mission02) + 1) --Questlog, The New Frontier Quest "Mission 02: From Kazordoon With Love"
			player:say("You have marked the tree, but you also angered the aquirrel family who lived on it!", TALKTYPE_MONSTER_SAY)
		end
	end

	if player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Beaver1) == 1 and player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Beaver2) == 1 and player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Beaver3) == 1 then
		player:setStorageValue(PlayerStorageKeys.TheNewFrontier.Questline, 6)
	end
	return true
end

beaver:id(11100)
beaver:register()

local lever = Action()

local config = {
	[8005] = Position(33055, 31527, 14),
	[8006] = Position(33065, 31489, 15)
}

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.actionid]
	if not targetPosition then
		return true
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)

	toPosition.x = item.actionid == 8005 and toPosition.x + 1 or toPosition.x - 1
	local creature = Tile(toPosition):getTopCreature()
	if not creature or not creature:isPlayer() then
		return true
	end

	if item.itemid ~= 1945 then
		return true
	end

	if item.actionid == 8005 then
		if creature:getStorageValue(PlayerStorageKeys.TheNewFrontier.Mission05) == 7 then
			targetPosition.z = 10
		elseif creature:getStorageValue(PlayerStorageKeys.TheNewFrontier.Mission03) == 3 then
			targetPosition.z = 12
		end
	end

	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	creature:teleportTo(targetPosition)
	targetPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

lever:id(8005, 8006)
lever:register()

local vine = Action()

local config = {
	[3153] = Position(33022, 31536, 6),
	[3154] = Position(33020, 31536, 4)
}

function vine.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.uid]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition)
	targetPosition:sendMagicEffect(CONST_ME_POFF)
	return true
end

vine:uid(3153, 3154)
vine:register()

local retreat = Action()

function retreat.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local destination = Position(33170, 31247, 11)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_POFF)
	return true
end

retreat:uid(3156)
retreat:register()

local shardOfCorruption = CreatureEvent("NewFrontierShardOfCorruption")

function shardOfCorruption.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'shard of corruption' then
		return true
	end

	local player = creature:getPlayer()
	if player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Questline) == 12 then --Questlog, The New Frontier Quest 'Mission 04: The Mine Is Mine'
		player:setStorageValue(PlayerStorageKeys.TheNewFrontier.Mission04, 2)
		player:setStorageValue(PlayerStorageKeys.TheNewFrontier.Questline, 13)
	end
	return true
end

shardOfCorruption:register()

local tireczKill = CreatureEvent("NewFrontierTirecz")

local exitPosition = {Position(33053, 31022, 7), Position(33049, 31017, 2)}

local function clearArena()
	local spectators, spectator = Game.getSpectators(Position(33063, 31034, 3), false, false, 10, 10, 10, 10)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(exitPosition[2])
			exitPosition[2]:sendMagicEffect(CONST_ME_TELEPORT)
		else
			spectator:remove()
		end
	end
end

function tireczKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'tirecz' then
		return true
	end

	local spectators, spectator = Game.getSpectators(Position(33063, 31034, 3), false, true, 10, 10, 10, 10)
	for i = 1, #spectators do
		spectator = spectators[i]
		spectator:teleportTo(exitPosition[1])
		exitPosition[1]:sendMagicEffect(CONST_ME_TELEPORT)
		spectator:say('You have won! As new champion take the ancient armor as reward before you leave.', TALKTYPE_MONSTER_SAY)
		if spectator:getStorageValue(PlayerStorageKeys.TheNewFrontier.Questline) == 25 then
			-- Questlog: The New Frontier Quest 'Mission 09: Mortal Combat'
			spectator:setStorageValue(PlayerStorageKeys.TheNewFrontier.Mission09, 2)
			spectator:setStorageValue(PlayerStorageKeys.TheNewFrontier.Questline, 26)
		end
	end

	Game.setStorageValue(PlayerStorageKeys.TheNewFrontier.Mission09, -1)
	clearArena()
	return true
end

tireczKill:register()
