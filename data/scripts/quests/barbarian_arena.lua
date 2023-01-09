local arenaKill = CreatureEvent("SvargrondArenaKill")

function arenaKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return
	end

	local player = creature:getPlayer()
	local pit = player:getStorageValue(PlayerStorageKeys.SvargrondArena.Pit)
	if pit < 1 or pit > 10 then
		return
	end

	local arena = player:getStorageValue(PlayerStorageKeys.SvargrondArena.Arena)
	if arena < 1 then
		return
	end

	if not table.contains(ARENA[arena].creatures, targetMonster:getName():lower()) then
		return
	end

	-- Remove pillar and create teleport
	local pillarTile = Tile(PITS[pit].pillar)
	if pillarTile then
		local pillarItem = pillarTile:getItemById(SvargrondArena.itemPillar)
		if pillarItem then
			pillarItem:remove()

			local teleportItem = Game.createItem(SvargrondArena.itemTeleport, 1, PITS[pit].tp)
			if teleportItem then
				teleportItem:setActionId(25200)
			end

			SvargrondArena.sendPillarEffect(pit)
		end
	end

	player:setStorageValue(PlayerStorageKeys.SvargrondArena.Pit, pit + 1)
	player:say('Victory! Head through the new teleporter into the next room.', TALKTYPE_MONSTER_SAY)
	return true
end

arenaKill:register()

local arenaDoor = Action()

local storages = {
	[26100] = PlayerStorageKeys.SvargrondArena.Greenhorn,
	[27100] = PlayerStorageKeys.SvargrondArena.Scrapper,
	[28100] = PlayerStorageKeys.SvargrondArena.Warlord
}

function arenaDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 5133 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.SvargrondArena.Arena) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This door seems to be sealed against unwanted intruders.')
		return true
	end

	local cStorage = storages[item.actionid]
	if cStorage then
		if player:getStorageValue(cStorage) ~= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'It\'s locked.')
			return true
		end

		item:transform(item.itemid + 1)
		player:teleportTo(toPosition, true)
	else
		if player:getStorageValue(PlayerStorageKeys.SvargrondArena.Pit) ~= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This door seems to be sealed against unwanted intruders.')
			return true
		end

		item:transform(item.itemid + 1)
		player:teleportTo(toPosition, true)
	end
	return true
end

arenaDoor:id(13100, 26100, 27100, 28100)
arenaDoor:register()

local arenaPit = MoveEvent()

local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(120000)
condition:setOutfit({lookType = 111})

function arenaPit.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local playerId = player.uid
	if item.actionid == 25300 then
		player:addCondition(condition)

		player:setStorageValue(PlayerStorageKeys.SvargrondArena.Pit, 0)
		player:teleportTo(SvargrondArena.kickPosition)
		player:say('Coward!', TALKTYPE_MONSTER_SAY)
		SvargrondArena.cancelEvents(playerId)
		return true
	end

	local pitId = player:getStorageValue(PlayerStorageKeys.SvargrondArena.Pit)
	local arenaId = player:getStorageValue(PlayerStorageKeys.SvargrondArena.Arena)
	if pitId > 10 then
		player:teleportTo(SvargrondArena.rewardPosition)
		player:setStorageValue(PlayerStorageKeys.SvargrondArena.Pit, 0)

		if arenaId == 1 then
			SvargrondArena.rewardPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			player:setStorageValue(PlayerStorageKeys.SvargrondArena.Greenhorn, 1)
			player:say('Welcome back, little hero!', TALKTYPE_MONSTER_SAY)
		elseif arenaId == 2 then
			SvargrondArena.rewardPosition:sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
			player:setStorageValue(PlayerStorageKeys.SvargrondArena.Scrapper, 1)
			player:say('Congratulations, brave warrior!', TALKTYPE_MONSTER_SAY)
		elseif arenaId == 3 then
			SvargrondArena.rewardPosition:sendMagicEffect(CONST_ME_FIREWORK_RED)
			player:setStorageValue(PlayerStorageKeys.SvargrondArena.Warlord, 1)
			player:say('Respect and honour to you, champion!', TALKTYPE_MONSTER_SAY)
		end

		player:setStorageValue(PlayerStorageKeys.SvargrondArena.Arena, player:getStorageValue(PlayerStorageKeys.SvargrondArena.Arena) + 1)
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_ORANGE, 'Congratulations! You completed ' .. ARENA[arenaId].name .. ' arena, you should take your reward now.')
		player:setStorageValue(ARENA[arenaId].questLog, 2)
		player:addAchievement(ARENA[arenaId].achievement)
		SvargrondArena.cancelEvents(playerId)
		return true
	end

	local occupant = SvargrondArena.getPitOccupant(pitId, player)
	if occupant then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, occupant:getName() .. ' is currently in the next arena pit. Please wait until ' .. (occupant:getSex() == PLAYERSEX_FEMALE and 's' or '') .. 'he is done fighting.')
		player:teleportTo(fromPosition, true)
		return true
	end

	SvargrondArena.cancelEvents(playerId)
	SvargrondArena.resetPit(pitId)
	SvargrondArena.scheduleKickPlayer(playerId, pitId)
	Game.createMonster(ARENA[arenaId].creatures[pitId], PITS[pitId].summon, false, true)

	player:teleportTo(PITS[pitId].center)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:say('Fight!', TALKTYPE_MONSTER_SAY)
	return true
end

arenaPit:type("stepin")
arenaPit:aid(25200, 25300)
arenaPit:register()

local arenaEnter = MoveEvent()

function arenaEnter.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local pitId = player:getStorageValue(PlayerStorageKeys.SvargrondArena.Pit)
	if pitId < 1 or pitId > 10 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You cannot enter without Halvar\'s permission.')
		player:teleportTo(fromPosition)
		return true
	end

	local arenaId = player:getStorageValue(PlayerStorageKeys.SvargrondArena.Arena)
	if not(PITS[pitId] and ARENA[arenaId]) then
		player:teleportTo(fromPosition)
		return true
	end

	local occupant = SvargrondArena.getPitOccupant(pitId, player)
	if occupant then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, occupant:getName() .. ' is currently in the next arena pit. Please wait until ' .. (occupant:getSex() == PLAYERSEX_FEMALE and 's' or '') .. 'he is done fighting.')
		player:teleportTo(fromPosition)
		return true
	end

	SvargrondArena.resetPit(pitId)
	SvargrondArena.scheduleKickPlayer(player.uid, pitId)
	Game.createMonster(ARENA[arenaId].creatures[pitId], PITS[pitId].summon, false, true)

	player:teleportTo(PITS[pitId].center)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	player:say('FIGHT!', TALKTYPE_MONSTER_SAY)
	return true
end

arenaEnter:type("stepin")
arenaEnter:aid(25100)
arenaEnter:register()

local arenaTrophy = MoveEvent()

function arenaTrophy.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	local arenaId = item.uid - 23200
	if arenaId >= creature:getStorageValue(PlayerStorageKeys.SvargrondArena.Arena) then
		return true
	end

	local cStorage = ARENA[arenaId].reward.trophyStorage
	if creature:getStorageValue(cStorage) ~= 1 then
		local rewardPosition = creature:getPosition()
		rewardPosition.y = rewardPosition.y - 1

		local rewardItem = Game.createItem(ARENA[arenaId].reward.trophy, 1, rewardPosition)
		if rewardItem then
			rewardItem:setDescription(string.format(ARENA[arenaId].reward.desc, creature:getName()))
		end

		creature:setStorageValue(cStorage, 1)
		creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	end
	return true
end

arenaTrophy:type("stepin")
arenaTrophy:uid(23201, 23202, 23203)
arenaTrophy:register()
