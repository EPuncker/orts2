function onUse(player, item, fromPosition, target, toPosition, isHotkey)

	if player:getStorageValue(PlayerStorageKeys.thievesGuild.Mission06) == 2 then
		player:addItem(8766, 1)
		player:say('To buy some time you replace the fish with a piece of carrot.', TALKTYPE_MONSTER_SAY)
		player:setStorageValue(PlayerStorageKeys.thievesGuild.Mission06, 3)
	end
	return true
end
