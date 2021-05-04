function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 18484 then
		return false
	end

	local extractedCount = player:getStorageValue(PlayerStorageKeys.BigfootBurden.ExtractedCount)
	if extractedCount == 7
			or player:getStorageValue(PlayerStorageKeys.BigfootBurden.MissionRaidersOfTheLostSpark) ~= 1 then
		return false
	end

	player:setStorageValue(PlayerStorageKeys.BigfootBurden.ExtractedCount, math.max(0, extractedCount) + 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You gathered a spark.')
	target:transform(18485)
	toPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
	return true
end
