function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if math.random(100) == 1 then
		item:transform(2094)
		player:addAchievement("Oops")
	else
		item:getPosition():sendMagicEffect(CONST_ME_SOUND_YELLOW)
	end
	return true
end
