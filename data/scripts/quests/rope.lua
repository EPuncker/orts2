local edronRope = MoveEvent()

function edronRope.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.EdronRopeQuest) >= os.time() then
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'In this cave there is a rope. It once belonged to a wanderer who was stuck. Only take it if you\'re stuck as well.')
	player:setStorageValue(PlayerStorageKeys.EdronRopeQuest, os.time() + 30)
	return true
end

edronRope:type("stepin")
edronRope:aid(4254)
edronRope:register()
