function onUse(player, item, fromPosition, target, toPosition, isHotkey)

	local power1 = Tile(Position(32613, 32220, 10))
	local wall = Tile(Position(32614, 32205, 10))
	local stone = Tile(Position(32614, 32206, 10))

	if item.itemid == 1945 and power1:getItemById(2166) and wall:getItemById(1025) and stone:getItemById(1304) and Tile(Position(32614, 32209, 10)):getItemById(1774) then
		power1:getItemById(2166):transform(1487)
		wall:getItemById(1025):remove()
		stone:getItemById(1304):transform(1025)
		Game.createItem(1487, 1, Position(32615, 32221, 10))
	end
	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end
