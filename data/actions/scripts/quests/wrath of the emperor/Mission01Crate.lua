local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({lookTypeEx = 12496})
condition:setTicks(-1)

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.CrateStatus) ~= 1 and player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Questline) == 2 then
		player:addCondition(condition)
		player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.CrateStatus, 1)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end
