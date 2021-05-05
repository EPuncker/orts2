function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4661 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission52) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission53) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission53, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "An invisible hand pulls you inside.")
		player:teleportTo(Position(33011, 32392, 10))
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	elseif player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission54) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission55) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission55, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Get out of my room!")
		player:teleportTo(Position(33008, 32392, 10))
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end