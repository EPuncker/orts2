function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4638 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission28) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission29) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission29, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The ashes swirl with a life of their own, mixing with the sparks of the altar.')
		item:remove(1)
	end
	return true
end