local wall = {
	Position(33295, 31677, 15),
	Position(33296, 31677, 15),
	Position(33297, 31677, 15),
	Position(33298, 31677, 15),
	Position(33299, 31677, 15)
}

local behemothQuest = Action()

function behemothQuest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1946 then
		return false
	end

	local thing
	for i = 1, #wall do
		thing = Tile(wall[i]):getItemById(1304)
		if thing then
			thing:remove()
		end
	end

	item:transform(1946)
	return true
end

behemothQuest:uid(2007)
behemothQuest:register()
