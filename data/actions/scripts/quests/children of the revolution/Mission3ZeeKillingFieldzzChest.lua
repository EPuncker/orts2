function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline) == 9 then
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline, 10)
		player:addItem(10760, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a flask of poison.")
	elseif player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.StrangeSymbols) == 2 then
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.StrangeSymbols, 3)
		player:addItem(11106, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a flask of extra greasy oil.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
	end
	return true
end