local ectoplasmContainer = Action()

function ectoplasmContainer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 4206 then
		if player:getStorageValue(PlayerStorageKeys.TibiaTales.IntoTheBonePit) ~= 1 then
			return false
		end

		player:setStorageValue(PlayerStorageKeys.TibiaTales.IntoTheBonePit, 2)
		item:transform(4864)
		target:remove()
		toPosition:sendMagicEffect(CONST_ME_POFF)
	elseif target.itemid == 2913 then
		if player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 45 then
			player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 46)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			item:transform(4864)
			target:remove()
		end
	end
	return true
end

ectoplasmContainer:id(4863)
ectoplasmContainer:register()
