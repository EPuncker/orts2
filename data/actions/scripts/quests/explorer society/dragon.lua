function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 57 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 58)
		Game.createItem(7314, 1, player:getPosition())
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end