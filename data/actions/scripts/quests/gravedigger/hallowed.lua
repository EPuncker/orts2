function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4634 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission19) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission20) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission20, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The flames roar and eat the bone hungrily. The Dark Lord is satisfied with your gift')
		item:remove()
	end
	return true
end