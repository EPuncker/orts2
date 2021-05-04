function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4224 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.SeaOfLightQuest.Questline) ~= 7 then
		return false
	end

	player:setStorageValue(PlayerStorageKeys.SeaOfLightQuest.Questline, 8)
	player:setStorageValue(PlayerStorageKeys.SeaOfLightQuest.Mission3, 2)
	local destination = Position(32017, 31730, 8)
	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	item:remove()
	return true
end
