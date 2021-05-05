function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.uid == 3018 then
		if player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 60 then
			player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 61)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
	end
	return true
end