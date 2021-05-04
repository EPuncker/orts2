function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission63) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission64) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission64, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found an incantation fragment.')
		player:addItem(21250, 1)
	end
	return true
end