local ghostShipQuest = Action()

function ghostShipQuest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.GhostShipQuest) == 1 then
		return false
	end

	player:setStorageValue(PlayerStorageKeys.GhostShipQuest, 1)
	player:addItem(2463, 1)
	return true
end

ghostShipQuest:aid(5556)
ghostShipQuest:register()
