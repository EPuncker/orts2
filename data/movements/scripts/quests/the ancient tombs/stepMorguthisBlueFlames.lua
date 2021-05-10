local config = {
	[50139] = PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage1,
	[50140] = PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage2,
	[50141]	= PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage3,
	[50142]	= PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage4,
	[50143] = PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage5,
	[50144] = PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage6,
	[50145] = PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage7
}

function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local tableTarget = config[item.uid]
	if tableTarget then
		if player:getStorageValue(tableTarget) ~= 1 then
			player:setStorageValue(tableTarget, 1)
		end

		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	else
		local missingStorage = false
		for i = PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage1, PlayerStorageKeys.TheAncientTombs.MorguthisBlueFlameStorage7 do
			if player:getStorageValue(i) ~= 1 then
				missingStorage = true
				break
			end
		end

		if missingStorage then
			player:teleportTo(fromPosition, true)
			fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end

		player:teleportTo(Position(33163, 32694, 14))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end