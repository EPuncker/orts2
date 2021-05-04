function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.secretService.TBIMission03) == 1 then
		player:setStorageValue(PlayerStorageKeys.secretService.TBIMission03, 2)
		Game.createMonster('pirate buccaneer', Position(32641, 32733, 7))
		Game.createMonster('pirate buccaneer', Position(32642, 32733, 7))
	end
	return true
end
