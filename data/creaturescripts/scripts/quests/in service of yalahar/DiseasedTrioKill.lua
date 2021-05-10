local diseasedTrio = {
	['diseased bill'] = PlayerStorageKeys.InServiceofYalahar.DiseasedBill,
	['diseased dan']  = PlayerStorageKeys.InServiceofYalahar.DiseasedDan,
	['diseased fred'] = PlayerStorageKeys.InServiceofYalahar.DiseasedFred
}

function onKill(creature, target)
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