function onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'shard of corruption' then
		return true
	end

	local player = creature:getPlayer()
	if player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Questline) == 12 then
		--Questlog, The New Frontier Quest 'Mission 04: The Mine Is Mine'
		player:setStorageValue(PlayerStorageKeys.TheNewFrontier.Mission04, 2)
		player:setStorageValue(PlayerStorageKeys.TheNewFrontier.Questline, 13)
	end
	return true
end