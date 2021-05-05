function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local repairedCount = player:getStorageValue(PlayerStorageKeys.BigfootBurden.RepairedCrystalCount)
	if repairedCount == 5 or player:getStorageValue(PlayerStorageKeys.BigfootBurden.MissionCrystalKeeper) ~= 1 then
		return false
	end

	if target.itemid == 18307 then
		player:setStorageValue(PlayerStorageKeys.BigfootBurden.RepairedCrystalCount, repairedCount + 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have repaired a damaged crystal.')
		target:transform(18311)
		toPosition:sendMagicEffect(CONST_ME_ENERGYAREA)
	elseif table.contains({18308, 18309, 18310, 18311}, target.itemid) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This is not the crystal you\'re looking for!')
	end
	return true
end
