function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission39) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission40) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission40, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<sizzle> <fizz>')
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	end
	return true
end