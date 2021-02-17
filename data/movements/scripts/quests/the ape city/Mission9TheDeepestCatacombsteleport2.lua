local amphoraPositions = {
	Position(32792, 32527, 10),
	Position(32823, 32525, 10),
	Position(32876, 32584, 10),
	Position(32744, 32586, 10)
}


function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for i = 1, #amphoraPositions do
		local amphoraItem = Tile(amphoraPositions[i]):getItemById(4997)
		if not amphoraItem then
			player:teleportTo(Position(32852, 32544, 10))
			position:sendMagicEffect(CONST_ME_TELEPORT)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "There are 4 large amphoras that must be broken in order to open the teleporter.")
			return true
		end
	end

	player:teleportTo(Position(32885, 32632, 11))
	position:sendMagicEffect(CONST_ME_TELEPORT)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end
