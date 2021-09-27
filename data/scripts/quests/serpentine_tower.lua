local walls = {
	{position = Position(33148, 32867, 9), relocatePosition = Position(33148, 32869, 9)},
	{position = Position(33148, 32868, 9), relocatePosition = Position(33148, 32869, 9)},
	{position = Position(33149, 32867, 9), relocatePosition = Position(33149, 32869, 9)},
	{position = Position(33149, 32868, 9), relocatePosition = Position(33149, 32869, 9)}
}

local serpentineLever = Action()

function serpentineLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		local wallItem
		for i = 1, #walls do
			wallItem = Tile(walls[i].position):getItemById(1498)
			if wallItem then
				wallItem:remove()
			end
		end

		item:transform(1946)
	else
		local wall
		for i = 1, #walls do
			wall = walls[i]
			Tile(wall.position):relocateTo(wall.relocatePosition)
			Game.createItem(1498, 1, wall.position)
		end

		item:transform(1945)
	end
	return true
end

serpentineLever:aid(5633)
serpentineLever:register()

local serpentineTorch = Action()

function serpentineTorch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local wallItem = Tile(33151, 32866, 8):getItemById(1100)
	if wallItem then
		wallItem:remove()
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	else
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

serpentineTorch:aid(5632)
serpentineTorch:register()

local setting = {
	[5630] = {
		teleportPosition = Position(33145, 32863, 7),
		effect = CONST_ME_MAGIC_GREEN,
		potPosition = Position(33151, 32864, 7)
	},

	[5631] = {
		teleportPosition = Position(33147, 32864, 7),
		effect = CONST_ME_MAGIC_GREEN
	}
}

local whitePearl = MoveEvent()

function whitePearl.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = setting[item.actionid]
	if not teleport then
		return true
	end

	if teleport.potPosition then
		local potItem = Tile(Position(33145, 32862, 7)):getItemById(2562)
		if potItem then
			player:teleportTo(teleport.potPosition)
			teleport.potPosition:sendMagicEffect(teleport.effect)
			return true
		end
	end

	player:teleportTo(teleport.teleportPosition)
	teleport.teleportPosition:sendMagicEffect(teleport.effect)
	return true
end

whitePearl:type("stepin")

for index, value in pairs(setting) do
	whitePearl:aid(index)
end

whitePearl:register()
