function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.BarbarianTest.Questline) == 2 and player:getStorageValue(PlayerStorageKeys.BarbarianTest.MeadTotalSips) <= 20 then
		if math.random(5) > 1 then
			player:say('The world seems to spin but you manage to stay on your feet.', TALKTYPE_MONSTER_SAY)
			player:setStorageValue(PlayerStorageKeys.BarbarianTest.MeadSuccessSips, player:getStorageValue(PlayerStorageKeys.BarbarianTest.MeadSuccessSips) + 1)
			if player:getStorageValue(PlayerStorageKeys.BarbarianTest.MeadSuccessSips) == 9 then -- 9 sips here cause local player at start
				player:say('10 sips in a row. Yeah!', TALKTYPE_MONSTER_SAY)
				player:setStorageValue(PlayerStorageKeys.BarbarianTest.Questline, 3)
				player:setStorageValue(PlayerStorageKeys.BarbarianTest.Mission01, 3) -- Questlog Barbarian Test Quest Barbarian Test 1: Barbarian Booze
				return true
			end
		else
			player:say('The mead was too strong. You passed out for a moment.', TALKTYPE_MONSTER_SAY)
			player:setStorageValue(PlayerStorageKeys.BarbarianTest.MeadSuccessSips, 0)
		end
		player:setStorageValue(PlayerStorageKeys.BarbarianTest.MeadTotalSips, player:getStorageValue(PlayerStorageKeys.BarbarianTest.MeadTotalSips) + 1)
	elseif player:getStorageValue(PlayerStorageKeys.BarbarianTest.MeadTotalSips) > 20 then
		player:say('Ask Sven for another round.', TALKTYPE_MONSTER_SAY)
		player:setStorageValue(PlayerStorageKeys.BarbarianTest.Questline, 1)
		player:setStorageValue(PlayerStorageKeys.BarbarianTest.Mission01, 1) -- Questlog Barbarian Test Quest Barbarian Test 1: Barbarian Booze
	elseif player:getStorageValue(PlayerStorageKeys.BarbarianTest.Questline) >= 3 then
		player:say('You already passed the test, no need to torture yourself anymore.', TALKTYPE_MONSTER_SAY)
	end
	return true
end
