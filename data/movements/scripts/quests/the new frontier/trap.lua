local destination = Position(33170, 31253, 11)

function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Questline) == 22 then
		--Questlog, The New Frontier Quest 'Mission 07: Messengers Of Peace'
		player:setStorageValue(PlayerStorageKeys.TheNewFrontier.Mission07, 2)
		player:setStorageValue(PlayerStorageKeys.TheNewFrontier.Questline, 23)
	end

	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_POFF)
	player:say('So far for the negotiating peace. Now you have other problems to handle.', TALKTYPE_MONSTER_SAY)
	return true
end