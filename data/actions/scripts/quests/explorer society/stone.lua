function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.uid == 3015 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 54 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 55)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif target.uid == 3016 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 55 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 56)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end