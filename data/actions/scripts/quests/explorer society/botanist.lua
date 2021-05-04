function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 4138 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 16 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 17)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4870)
		target:remove()
	elseif target.itemid == 4149 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 19 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 20)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4871)
		target:remove()
	elseif target.itemid == 4242 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 24 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 25)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4872)
		target:remove()
	elseif target.itemid == 5659 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 24 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 25)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
		item:transform(5937)
	end
	return true
end