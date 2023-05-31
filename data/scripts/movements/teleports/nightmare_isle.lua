local setting = {
	{storage = GlobalStorageKeys.WorldBoard.NightmareIsle.darashiaNorthWest, teleportPosition = Position(33032, 32400, 7)},
	{storage = GlobalStorageKeys.WorldBoard.NightmareIsle.darashiaNorth, teleportPosition = Position(33215, 32273, 7)},
	{storage = GlobalStorageKeys.WorldBoard.NightmareIsle.darashiaNorthWest, teleportPosition = Position(33255, 32678, 7)}
}

local teleport = MoveEvent()

function teleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	for i = 1, #setting do
		local table = setting[i]
		local backStorage = table.storage
		if Game.getStorageValue(backStorage) >= 1 then
			player:teleportTo(table.teleportPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			break
		end
	end
	return true
end

teleport:aid(2091)
teleport:register()
