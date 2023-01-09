local waterfall = MoveEvent()

local config = {
	swimmingPosition = Position(32968, 32626, 5),
	caveEntrancePosition = Position(32968, 32631, 8),
	caveExitPosition = Position(32971, 32620, 8)
}

function waterfall.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if position.x == 32966 and position.y == 32626 and position.z == 5 then -- Jumping off the mountain edge into the water / onto water edge
		player:teleportTo(config.swimmingPosition)
		config.swimmingPosition:sendMagicEffect(CONST_ME_WATERSPLASH)
	elseif position.x == 32968 and position.y == 32630 and position.z == 7 then -- Splash effect when jumping down the waterfall
		position:sendMagicEffect(CONST_ME_WATERSPLASH)
	elseif position.x == 32968 and position.y == 32629 and position.z == 7 then -- Teleport when entering the waterfall / cave
		player:teleportTo(config.caveEntrancePosition)
		player:setDirection(DIRECTION_SOUTH)
	elseif position.x == 32967 and position.y == 32630 and position.z == 8 then -- Leaving the cave through teleport
		player:teleportTo(config.caveExitPosition)
		player:setDirection(DIRECTION_EAST)
	end
	return true
end

waterfall:type("stepin")
waterfall:aid(50022)
waterfall:register()
