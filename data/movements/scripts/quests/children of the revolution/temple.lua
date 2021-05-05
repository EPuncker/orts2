function onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline) == 4 then
		--Questlog, Children of the Revolution 'Mission 1: Corruption'
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission01, 2)
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline, 5)
		player:say('The temple has been corrupted and is lost. Zalamon should be informed about this as soon as possible.', TALKTYPE_MONSTER_SAY)
	end
	return true
end
