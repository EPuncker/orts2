function onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'wiggler' then
		return true
	end

	local player = creature:getPlayer()
	local value = player:getStorageValue(PlayerStorageKeys.BigfootBurden.ExterminatedCount)
	if value < 10 and player:getStorageValue(PlayerStorageKeys.BigfootBurden.MissionExterminators) == 1 then
		player:setStorageValue(PlayerStorageKeys.BigfootBurden.ExterminatedCount, value + 1)
	end
	return true
end