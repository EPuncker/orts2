function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.SamsOldBackpack) == 2 then
		player:setStorageValue(PlayerStorageKeys.SamsOldBackpack, 3)
		player:addItem(2503, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a dwarven armor.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
	end
	return true
end
