local function revertKeeperstorage()
	Game.setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03, 0)
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 12320 and target.actionid == 8026 then
		if Game.getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03) < 5 then
			Game.setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03, math.max(0, Game.getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03)) + 1)
			player:say("The plant twines and twiggles even more than before, it almost looks as it would scream great pain.", TALKTYPE_MONSTER_SAY)
		elseif Game.getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03) == 5 then
			Game.setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03, 6)
			toPosition:sendMagicEffect(CONST_ME_YELLOW_RINGS)
			Game.createMonster('the keeper', Position(33171, 31058, 11))
			Position(33171, 31058, 11):sendMagicEffect(CONST_ME_TELEPORT)
			addEvent(revertKeeperstorage, 60 * 1000)
		end
	elseif item.itemid == 12316 then
		if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Questline) == 7 then
			player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Questline, 8)
			player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03, 2) -- Questlog, Wrath of the Emperor "Mission 03: The Keeper"
			player:addItem(12323, 1)
		end
	end
	return true
end
