function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission56) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission57) ~= 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission57, 1)
		Game.createMonster('Necromancer Servant', Position(33011, 32437, 11))
	end
end
