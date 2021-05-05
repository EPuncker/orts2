function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 2817 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission11) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission12) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission12, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Done! Report back to Omrabas.')
		player:addItem(21403, 1)
		item:remove()
	end
	return true
end