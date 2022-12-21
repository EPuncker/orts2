local rake = Action()

function rake.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 12322 then -- Wrath of the Emperor Mission 02
		player:addItem(12285, 1)
		player:say("You dig out a handful of ordinary clay.", TALKTYPE_MONSTER_SAY)
	elseif target.itemid == 6094 then -- The Shattered Isles Parrot ring
		if player:getStorageValue(PlayerStorageKeys.TheShatteredIsles.TheGovernorDaughter) == 1 then
			toPosition:sendMagicEffect(CONST_ME_POFF)
			Game.createItem(6093, 1, Position(32422, 32770, 1))
			player:say("You have found a ring.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(PlayerStorageKeys.TheShatteredIsles.TheGovernorDaughter, 2)
		end
	end
	return true
end

rake:id(2549)
rake:register()
