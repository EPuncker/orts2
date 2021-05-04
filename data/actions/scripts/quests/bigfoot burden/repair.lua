function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target:isCreature() or not target:isMonster() then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.BigfootBurden.GolemCount) < 4 and player:getStorageValue(PlayerStorageKeys.BigfootBurden.MissionTinkersBell) == 1 and target:getName():lower() == 'damaged crystal golem' then
		player:setStorageValue(PlayerStorageKeys.BigfootBurden.GolemCount, player:getStorageValue(PlayerStorageKeys.BigfootBurden.GolemCount) + 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The golem has been returned to the gnomish workshop.')
		target:remove()
		toPosition:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end