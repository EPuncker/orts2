local questDoor = MoveEvent()
questDoor:type("stepin")

function questDoor.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return false
	end

	if creature:getStorageValue(item.actionid) == -1 and not creature:getGroup():getAccess() then
		creature:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
		creature:teleportTo(fromPosition, true)
		return false
	end
	return true
end

for _, i in ipairs(openQuestDoors) do
	questDoor:id(i)
end
questDoor:register()
