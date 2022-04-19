local doorIds = {}
for index, value in ipairs(normalDoors) do
	if not table.contains(doorIds, value.openDoor) then
		table.insert(doorIds, value.openDoor)
	end

	if not table.contains(doorIds, value.closedDoor) then
		table.insert(doorIds, value.closedDoor)
	end
end

local normalDoor = Action()

function normalDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Creature.isInsideDoor(player, toPosition) then
		return true
	end

	for index, value in ipairs(normalDoors) do
		if value.closedDoor == item.itemid then
			item:transform(value.openDoor)
			return true
		end
	end

	for index, value in ipairs(normalDoors) do
		if value.openDoor == item.itemid then
			item:transform(value.closedDoor)
			return true
		end
	end

	return true
end

for index, value in ipairs(doorIds) do
	normalDoor:id(value)
end

normalDoor:register()
