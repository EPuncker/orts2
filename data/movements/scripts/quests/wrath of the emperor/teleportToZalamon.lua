function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Questline) < 31 then
		player:teleportTo(fromPosition)
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Questline) > 32 then
		local destination = Position(33078, 31219, 8)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local destination = Position(33359, 31397, 9)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end
