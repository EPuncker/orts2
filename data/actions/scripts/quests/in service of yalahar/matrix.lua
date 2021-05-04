function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains({7915, 7916}, target.itemid) and target.actionid == 100 then
		if table.contains({9743, 9744}, item.itemid) and player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.MatrixState) < 1 then
			player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.MatrixState, 1)
			item:remove(1)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:say("The machine was activated.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline, 46)
			player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Mission08, 3) -- StorageValue for Questlog "Mission 08: Dangerous Machinations"
		end
	end
	return true
end
