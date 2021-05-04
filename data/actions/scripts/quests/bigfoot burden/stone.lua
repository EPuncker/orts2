function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.BigfootBurden.GrindstoneStatus) == 1 or player:getStorageValue(PlayerStorageKeys.BigfootBurden.MissionGrindstoneHunt) ~= 1 then
		return false
	end

	toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
	item:transform(18335)

	if math.random(15) ~= 15 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You had no luck this time.')
		return true
	end

	player:setStorageValue(PlayerStorageKeys.BigfootBurden.GrindstoneStatus, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Your skill allowed you to grab a whetstone before the stone sinks into lava.')
	player:addItem(18337, 1)
	return true
end
