local yalaharDemons = MoveEvent()

local config = {
	[4244] = { sacrificePosition = Position(32859, 31056, 9), pushPosition = Position(32856, 31054, 9), destination = Position(32860, 31061, 9) }, -- west entrance
	[4245] = { sacrificePosition = Position(32894, 31044, 9), pushPosition = Position(32895, 31046, 9), destination = Position(32888, 31044, 9) } -- east entrance
}

function yalaharDemons.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local flame = config[item.actionid]
	if not flame then
		return true
	end

	local items = Tile(flame.sacrificePosition):getItems()
	for i = 1, #items do
		local tmpItem = items[i]
		if table.contains({8298, 8299, 8302, 8303}, tmpItem:getId()) then
			player:teleportTo(flame.destination)
			position:sendMagicEffect(CONST_ME_HITBYFIRE)
			flame.sacrificePosition:sendMagicEffect(CONST_ME_HITBYFIRE)
			flame.destination:sendMagicEffect(CONST_ME_HITBYFIRE)
			tmpItem:remove()
			return true
		end
	end

	player:teleportTo(flame.pushPosition)
	position:sendMagicEffect(CONST_ME_ENERGYHIT)
	flame.pushPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
	return true
end

yalaharDemons:type("stepin")
yalaharDemons:aid(4244, 4245)
yalaharDemons:register()
