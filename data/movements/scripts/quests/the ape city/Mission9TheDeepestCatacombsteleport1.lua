function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.TheApeCity.Questline) >= 17 then
		player:teleportTo(Position(32749, 32536, 10))
	else
		player:teleportTo(fromPosition)
		player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You don\'t have access to this area.')
	end

	position:sendMagicEffect(CONST_ME_TELEPORT)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end
