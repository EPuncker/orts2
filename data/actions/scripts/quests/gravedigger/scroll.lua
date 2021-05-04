function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission53) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission54) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission54, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Somebody left a card. It says: Looking for the scroll? Come find me. Take the stairs next to the students. Dorm.')
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end