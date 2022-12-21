local azerusKill = CreatureEvent("ServiceOfYalaharAzerus")

local teleportToPosition = Position(32780, 31168, 14)

local function removeTeleport(position)
	local teleportItem = Tile(position):getItemById(1387)
	if teleportItem then
		teleportItem:remove()
		position:sendMagicEffect(CONST_ME_POFF)
	end
end

function azerusKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster or targetMonster:getName():lower() ~= 'azerus' then
		return true
	end

	local position = targetMonster:getPosition()
	position:sendMagicEffect(CONST_ME_TELEPORT)
	local item = Game.createItem(1387, 1, position)
	if item:isTeleport() then
		item:setDestination(teleportToPosition)
	end
	targetMonster:say('Azerus ran into teleporter! It will disappear in 2 minutes. Enter it!', TALKTYPE_MONSTER_SAY, 0, 0, position)

	--remove portal after 2 min
	addEvent(removeTeleport, 2 * 60 * 1000, position)

	--clean arena of monsters
	local spectators, spectator = Game.getSpectators(Position(32783, 31166, 10), false, false, 10, 10, 10, 10)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() then
			spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
			spectator:remove()
		end
	end
	return true
end

azerusKill:register()

local diseasedTrioKill = CreatureEvent("ServiceOfYalaharDiseasedTrio")

local diseasedTrio = {
	['diseased bill'] = PlayerStorageKeys.InServiceofYalahar.DiseasedBill,
	['diseased dan'] = PlayerStorageKeys.InServiceofYalahar.DiseasedDan,
	['diseased fred'] = PlayerStorageKeys.InServiceofYalahar.DiseasedFred
}

function diseasedTrioKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	local bossStorage = diseasedTrio[targetMonster:getName():lower()]
	if not bossStorage then
		return true
	end

	local player = creature:getPlayer()
	if player:getStorageValue(bossStorage) < 1 then
		player:setStorageValue(bossStorage, 1)
		player:say('You slayed ' .. targetMonster:getName() .. '.', TALKTYPE_MONSTER_SAY)
	end

	if (player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.DiseasedDan) == 1
			and player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.DiseasedBill) == 1
			and player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.DiseasedFred) == 1
			and player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.AlchemistFormula) ~= 1) then
		player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.AlchemistFormula, 0)
	end
	return true
end

diseasedTrioKill:register()

local quaraLeadersKill = CreatureEvent("ServiceOfYalaharQuaraLeaders")

local quaraLeaders = {
	['inky'] = PlayerStorageKeys.InServiceofYalahar.QuaraInky,
	['sharptooth'] = PlayerStorageKeys.InServiceofYalahar.QuaraSharptooth,
	['splasher'] = PlayerStorageKeys.InServiceofYalahar.QuaraSplasher
}

function quaraLeadersKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	local bossStorage = quaraLeaders[targetMonster:getName():lower()]
	if not bossStorage then
		return true
	end

	local player = creature:getPlayer()
	if player:getStorageValue(bossStorage) < 1 then
		player:setStorageValue(bossStorage, 1)
		player:say('You slayed ' .. targetMonster:getName() .. '.', TALKTYPE_MONSTER_SAY)
		player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.QuaraState, 2)
		player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline, 41) -- StorageValue for Questlog 'Mission 07: A Fishy Mission'
		player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Mission07, 4)
	end
	return true
end

quaraLeadersKill:register()
