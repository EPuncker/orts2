local package = Action()

function package.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 101 and target.itemid == 2334 then
		if player:getStorageValue(PlayerStorageKeys.postman.Mission09) == 2 then
			player:setStorageValue(PlayerStorageKeys.postman.Mission09, 3)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
			item:transform(1993)
		end
	end
	return true
end

package:id(2330)
package:register()

local present = Action()

function present.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:remove(1)
	toPosition:sendMagicEffect(CONST_ME_POFF)
	player:say("You open the present.", TALKTYPE_MONSTER_SAY)
	return true
end

present:id(2331)
present:register()

local postHorn = Action()

function postHorn.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.postman.Mission08) == 1 then
		player:setStorageValue(PlayerStorageKeys.postman.Mission08, 2)
		player:addItem(2332, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found Waldo's posthorn.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The dead human is empty.')
	end
	return true
end

postHorn:uid(3118)
postHorn:register()
