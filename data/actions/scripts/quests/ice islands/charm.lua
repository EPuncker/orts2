function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 1354 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Questline) ~= 39 then
		return true
	end

	local obelisk1 = Position(32138, 31113, 14)
	local obelisk2 = Position(32119, 30992, 14)
	local obelisk3 = Position(32180, 31069, 14)
	local obelisk4 = Position(32210, 31027, 14)

	if toPosition.x == obelisk1.x and toPosition.y == obelisk1.y and toPosition.z == obelisk1.z then
		if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk01) < 5 then
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk01, 5)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission12, player:getStorageValue(PlayerStorageKeys.TheIceIslands.Mission12) + 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			player:say("You mark an obelisk with the frost charm.", TALKTYPE_MONSTER_SAY)
		end
	elseif toPosition.x == obelisk2.x and toPosition.y == obelisk2.y and toPosition.z == obelisk2.z then
		if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk02) < 5 then
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk02, 5)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission12, player:getStorageValue(PlayerStorageKeys.TheIceIslands.Mission12) + 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			player:say("You mark an obelisk with the frost charm.", TALKTYPE_MONSTER_SAY)
		end
	elseif toPosition.x == obelisk3.x and toPosition.y == obelisk3.y and toPosition.z == obelisk3.z then
		if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk03) < 5 then
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk03, 5)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission12, player:getStorageValue(PlayerStorageKeys.TheIceIslands.Mission12) + 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			player:say("You mark an obelisk with the frost charm.", TALKTYPE_MONSTER_SAY)
		end
	elseif toPosition.x == obelisk4.x and toPosition.y == obelisk4.y and toPosition.z == obelisk4.z then
		if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk04) < 5 then
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk04, 5)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission12, player:getStorageValue(PlayerStorageKeys.TheIceIslands.Mission12) + 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			player:say("You mark an obelisk with the frost charm.", TALKTYPE_MONSTER_SAY)
		end
	end
	return true
end