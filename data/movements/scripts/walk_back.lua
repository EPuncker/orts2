function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local specialQuests = {2215, 2216, 10544, 12374, 12513, 26300, 27300, 28300}
	if (Container(item.uid) and not table.contains(specialQuests, item.actionid) and item.uid > 65535) then
		return true
	end

	player:teleportTo(fromPosition, true)
	return true
end
