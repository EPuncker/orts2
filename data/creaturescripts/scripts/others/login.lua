-- ordered as in creaturescripts.xml
local events = {
	'TutorialCockroach',
	'ElementalSpheresOverlords',
	'BigfootBurdenVersperoth',
	'BigfootBurdenWarzone',
	'BigfootBurdenWeeper',
	'BigfootBurdenWiggler',
	'SvargrondArenaKill',
	'NewFrontierShardOfCorruption',
	'NewFrontierTirecz',
	'ServiceOfYalaharDiseasedTrio',
	'ServiceOfYalaharAzerus',
	'ServiceOfYalaharQuaraLeaders',
	'InquisitionBosses',
	'InquisitionUngreez',
	'KillingInTheNameOfKills',
	'MastersVoiceServants',
	'SecretServiceBlackKnight',
	'ThievesGuildNomad',
	'WotELizardMagistratus',
	'WotELizardNoble',
	'WotEKeeper',
	'WotEBosses',
	'WotEZalamon',
	'PlayerDeath',
	'AdvanceSave',
	'AdvanceRookgaard',
	'PythiusTheRotten',
	'DropLoot'
}

local function onMovementRemoveProtection(cid, oldPosition, time)
	local player = Player(cid)
	if not player then
		return true
	end

	local playerPosition = player:getPosition()
	if (playerPosition.x ~= oldPosition.x or playerPosition.y ~= oldPosition.y or playerPosition.z ~= oldPosition.z) or player:getTarget() or time <= 0 then
		player:setStorageValue(PlayerStorageKeys.combatProtectionStorage, 0)
		return true
	end

	addEvent(onMovementRemoveProtection, 1000, cid, oldPosition, time - 1)
end

function onLogin(player)
	local loginStr = 'Welcome to ' .. configManager.getString(configKeys.SERVER_NAME) .. '!'
	if player:getLastLoginSaved() <= 0 then
		loginStr = loginStr .. ' Please choose your outfit.'
		player:sendTutorial(1)
	else
		if loginStr ~= '' then
			player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)
		end

		loginStr = string.format('Your last visit was on %s.', os.date('%a %b %d %X %Y', player:getLastLoginSaved()))
	end
	player:sendTextMessage(MESSAGE_STATUS_DEFAULT, loginStr)

	local playerId = player:getId()

	-- Stamina
	nextUseStaminaTime[playerId] = 0

	-- Promotion
	local vocation = player:getVocation()
	local promotion = vocation:getPromotion()
	if player:isPremium() then
		local value = player:getStorageValue(PlayerStorageKeys.Promotion)
		if not promotion and value ~= 1 then
			player:setStorageValue(PlayerStorageKeys.Promotion, 1)
		elseif value == 1 then
			player:setVocation(promotion)
		end
	elseif not promotion then
		player:setVocation(vocation:getDemotion())
	end

	-- Events
	for i = 1, #events do
		player:registerEvent(events[i])
	end

	if player:getStorageValue(PlayerStorageKeys.combatProtectionStorage) <= os.time() then
		player:setStorageValue(PlayerStorageKeys.combatProtectionStorage, os.time() + 10)
		onMovementRemoveProtection(playerId, player:getPosition(), 10)
	end
	return true
end
