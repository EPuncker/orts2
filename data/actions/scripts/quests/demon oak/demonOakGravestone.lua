function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.DemonOak.Done) == 2 then
		player:teleportTo(DEMON_OAK_REWARDROOM_POSITION)
		DEMON_OAK_REWARDROOM_POSITION:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
end