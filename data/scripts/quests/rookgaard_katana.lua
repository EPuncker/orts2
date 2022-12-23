local katanaQuestDoor = Action()

function katanaQuestDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	return false
end

katanaQuestDoor:aid(1002)
katanaQuestDoor:register()

local katanaQuestLever = Action()

function katanaQuestLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1946 then
		local doorPosition = Position(32177, 32148, 11)
		local doorItem = Tile(doorPosition):getItemById(5107)
		if doorItem then
			doorItem:transform(5109)
			doorItem:setActionId(1002)
			item:transform(1945)
		end
	else
		local tile = Tile(doorPosition)
		local doorItem = tile:getItemById(5109)
		if doorItem then
			local relocatePosition = Position(32178, 32148, 11)
			tile:relocateTo(relocatePosition, true)

			doorItem:transform(5107)
			doorItem:setActionId(1001)
			item:transform(1946)
		end
	end
	return true
end

katanaQuestLever:aid(5637)
katanaQuestLever:register()
