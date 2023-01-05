local slimeGobbler = Action()

local position = {
	Position(33313, 31852, 9),
	Position(33313, 31865, 9),
	Position(33313, 31881, 9),
	Position(33328, 31860, 9),
	Position(33328, 31885, 9),
	Position(33308, 31873, 9),
	Position(33320, 31873, 9),
	Position(33336, 31914, 9),
	Position(33343, 31914, 9),
	Position(33361, 31914, 9),
	Position(33352, 31900, 9),
	Position(33355, 31861, 9),
	Position(33355, 31885, 9),
	Position(33345, 31864, 9),
	Position(33345, 31881, 9),
	Position(33309, 31867, 9),
	Position(33311, 31854, 9),
	Position(33334, 31889, 9),
	Position(33340, 31890, 9),
	Position(33347, 31889, 9)
}

local creatureNames = {
	'iron servant',
	'golden servant',
	'diamond servant'
}

local function getFungusInArea(fromPos, toPos)
	for x = fromPos.x, toPos.x do
		for y = fromPos.y, toPos.y do
			for itemId = 13585, 13589 do
				if Tile(Position(x, y, fromPos.z)):getItemById(itemId) then
					return true
				end
			end
		end
	end
	return false
end

local function summonMonster(name, position)
	Game.createMonster(name, position)
	position:sendMagicEffect(CONST_ME_TELEPORT)
end

function slimeGobbler.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({13585, 13586, 13587, 13588, 13589}, target.itemid) then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.TheirMastersVoice.SlimeGobblerTimeout) < os.time() then
		target:transform(13590)
		player:setStorageValue(PlayerStorageKeys.TheirMastersVoice.SlimeGobblerTimeout, os.time() + 5)
		toPosition:sendMagicEffect(CONST_ME_POFF)

		if not getFungusInArea(Position(33306, 31847, 9), Position(33369, 31919, 9)) then
			for i = 1, #position do
				addEvent(summonMonster, 5 * 1000, creatureNames[math.random(#creatureNames)], position[i])
			end

			player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_RED)
			player:say('COME! My servants! RISE!', TALKTYPE_MONSTER_SAY)
			Game.setStorageValue(GlobalStorageKeys.TheirMastersVoice.ServantsKilled, 0)
			Game.setStorageValue(GlobalStorageKeys.TheirMastersVoice.CurrentServantWave, 0)
		else
			player:say('The slime gobbler gobbles large chunks of the slime fungus with great satisfaction.', TALKTYPE_MONSTER_SAY)
			player:addExperience(20, true, true)
		end
	end
	return true
end

slimeGobbler:id(13601)
slimeGobbler:register()

local servantsKill = CreatureEvent("MastersVoiceServants")

local magePositions = {
	Position(33328, 31859, 9),
	Position(33367, 31873, 9),
	Position(33349, 31899, 9)
}

local positions = {
	Position(33313, 31852, 9),
	Position(33313, 31865, 9),
	Position(33313, 31881, 9),
	Position(33328, 31860, 9),
	Position(33328, 31873, 9),
	Position(33328, 31885, 9),
	Position(33308, 31873, 9),
	Position(33320, 31873, 9),
	Position(33335, 31873, 9),
	Position(33360, 31873, 9),
	Position(33336, 31914, 9),
	Position(33343, 31914, 9),
	Position(33353, 31914, 9),
	Position(33361, 31914, 9),
	Position(33345, 31900, 9),
	Position(33352, 31900, 9),
	Position(33355, 31854, 9),
	Position(33355, 31861, 9),
	Position(33355, 31885, 9),
	Position(33345, 31864, 9),
	Position(33345, 31881, 9),
	Position(33309, 31867, 9),
	Position(33317, 31879, 9),
	Position(33311, 31854, 9),
	Position(33334, 31889, 9),
	Position(33340, 31890, 9),
	Position(33347, 31889, 9)
}

local servants = {
	'iron servant',
	'golden servant',
	'diamond servant'
}

local function fillFungus(fromPosition, toPosition)
	for x = fromPosition.x, toPosition.x do
		for y = fromPosition.y, toPosition.y do
			local position = Position(x, y, 9)
			local tile = Tile(position)
			if tile then
				local item = tile:getItemById(13590)
				if item then
					item:transform(math.random(13585, 13589))
					position:sendMagicEffect(CONST_ME_YELLOW_RINGS)
				end
			end
		end
	end
end

local function summonServant(position)
	Game.createMonster(servants[math.random(#servants)], position)
	position:sendMagicEffect(CONST_ME_TELEPORT)
end

function servantsKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if not table.contains(servants, targetMonster:getName():lower()) then
		return true
	end

	local wave, killedAmount = Game.getStorageValue(GlobalStorageKeys.TheirMastersVoice.CurrentServantWave), Game.getStorageValue(GlobalStorageKeys.TheirMastersVoice.ServantsKilled)
	if killedAmount == #positions and wave < 25 then
		Game.setStorageValue(GlobalStorageKeys.TheirMastersVoice.ServantsKilled, 0)
		Game.setStorageValue(GlobalStorageKeys.TheirMastersVoice.CurrentServantWave, wave + 1)

		for i = 1, #positions do
			addEvent(summonServant, 5 * 1000, positions[i])
		end

	elseif killedAmount < #positions and wave < 25 then
		Game.setStorageValue(GlobalStorageKeys.TheirMastersVoice.ServantsKilled, killedAmount + 1)

	elseif killedAmount == #positions and wave == 25 then
		Game.createMonster('mad mage', magePositions[math.random(#magePositions)])
		targetMonster:say('The Mad Mage has been spawned!', TALKTYPE_MONSTER_SAY)
		fillFungus({x = 33306, y = 31847}, {x = 33369, y = 31919})
	end
	return true
end

servantsKill:register()
