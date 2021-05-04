function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local mast = Position(32360, 31365, 7)
	if target.itemid == 3323 and item.itemid == 7243 then
		if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Questline) == 6 then
			toPosition:sendMagicEffect(CONST_ME_GROUNDSHAKER)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission03, 2) -- Questlog The Ice Islands Quest, Nibelor 2: Ecological Terrorism
			player:say("You fill the jug with ants.", TALKTYPE_MONSTER_SAY)
			item:transform(7244)
		end
	elseif target.itemid == 4942 and item.itemid == 7244 and toPosition.x == mast.x and toPosition.y == mast.y and toPosition.z == mast.z then
		if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Questline) == 6 then
			toPosition:sendMagicEffect(CONST_ME_GROUNDSHAKER)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Questline, 7)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission03, 3) -- Questlog The Ice Islands Quest, Nibelor 2: Ecological Terrorism
			player:say("You released ants on the hill.", TALKTYPE_MONSTER_SAY)
			item:transform(7243)
		end
	end
	return true
end
