function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.InterdimensionalPotion) == 1 then
		return true
	end

	player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.InterdimensionalPotion, 1)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

	item:remove()
	return true
end
