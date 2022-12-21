local trianguleTowerLever = Action()

function trianguleTowerLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local tile = Tile(Position(32566, 32119, 7))
	if item.itemid == 1945 then
		if tile:getItemById(1025) then
			tile:getItemById(1025):remove()
			item:transform(1946)
		else
			Game.createItem(1025, 1, Position(32566, 32119, 7))
		end
	else
		Game.createItem(1025, 1, Position(32566, 32119, 7))
		item:transform(1945)
	end
	return true
end

trianguleTowerLever:uid(50023)
trianguleTowerLever:register()
