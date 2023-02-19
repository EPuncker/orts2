local lever = Action()

local walls = {
	{position = Position(33148, 32867, 9), relocatePosition = Position(33148, 32869, 9)},
	{position = Position(33148, 32868, 9), relocatePosition = Position(33148, 32869, 9)},
	{position = Position(33149, 32867, 9), relocatePosition = Position(33149, 32869, 9)},
	{position = Position(33149, 32868, 9), relocatePosition = Position(33149, 32869, 9)}
}

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
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

lever:aid(5633)
lever:register()

local torch = Action()

function torch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local wallItem = Tile(33151, 32866, 8):getItemById(1100)
	if wallItem then
		wallItem:remove()
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	else
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

torch:aid(5632)
torch:register()
