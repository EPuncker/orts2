function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 4995 and target.uid == 3000 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 5 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 6)
		player:addItem(4848, 1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end