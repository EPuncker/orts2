local bearRoomQuestLever = Action()

function bearRoomQuestLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		local stonePosition = Position(32145, 32101, 11)
		local stoneItem = Tile(stonePosition):getItemById(1304)
		if stoneItem then
			stoneItem:remove()
			item:transform(1946)
		end
	else
		Tile(stonePosition):relocateTo(Position(32145, 32102, 11))
		Game.createItem(1304, 1, stonePosition)
		item:transform(1945)
	end
	return true
end

bearRoomQuestLever:uid(1056)
bearRoomQuestLever:register()
