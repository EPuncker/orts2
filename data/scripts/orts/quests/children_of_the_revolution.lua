local zeeKillingFieldzzChest = Action()

function zeeKillingFieldzzChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline) == 9 then
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline, 10)
		player:addItem(10760, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a flask of poison.")
	elseif player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.StrangeSymbols) == 2 then
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.StrangeSymbols, 3)
		player:addItem(11106, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a flask of extra greasy oil.")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
	end
	return true
end

zeeKillingFieldzzChest:uid(3164)
zeeKillingFieldzzChest:register()

local zeeKillingFieldzzPoisonWater = Action()

function zeeKillingFieldzzPoisonWater.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 8012 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline) == 10 then
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline, 11)
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission03, 2) --Questlog, Children of the Revolution "Mission 3: Zee Killing Fieldzz"
		item:remove()
		player:say("The rice has been poisoned. This will weaken the Emperor's army significantly. Return and tell Zalamon about your success.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

zeeKillingFieldzzPoisonWater:id(10760)
zeeKillingFieldzzPoisonWater:register()

local zeeWayofZztonezzLevers = Action()

local leverChange = {
	[1] = {1, 3, 2, 4},
	[2] = {2, 1, 3, 4},
	[3] = {2, 3, 1, 4},
	[4] = {3, 2, 4, 1},
	[5] = {4, 2, 1, 3}
}

local position = {
	[1] = {
		Position(33355, 31126, 7),
		Position(33356, 31126, 7),
		Position(33357, 31126, 7),
		Position(33358, 31126, 7)
	},
	[2] = {
		Position(33352, 31126, 5),
		Position(33353, 31126, 5),
		Position(33354, 31126, 5),
		Position(33355, 31126, 5)
	}
}

function zeeWayofZztonezzLevers.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 8013 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline) ~= 14 then
		player:say("The lever does not budge.", TALKTYPE_MONSTER_SAY)
		return true
	end

	local lever, tmp, ground = toPosition.y - 31122, {}
	for i = 1, #position[1] do
		ground = Tile(position[1][i]):getGround()
		if ground then
			tmp[i] = ground.itemid
		end
	end

	for i = 1, #position[2] do
		ground = Tile(position[2][i]):getGround()
		if ground then
			ground:transform(tmp[leverChange[lever][i]])
			ground:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	end

	local groundIds, pass = {10856, 10853, 10855, 10850}, 0
	for i = 1, #position[2] do
		ground = Tile(position[2][i]):getGround()
		if ground and ground.itemid == groundIds[i] then
			pass = pass + 1
		end
	end

	if pass ~= 4 then
		return true
	end

	player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline, 17)
	player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission04, 5) --Questlog, Children of the Revolution "Mission 4: Zze Way of Zztonezz"
	player:say("After a cracking noise a deep humming suddenly starts from somewhere below.", TALKTYPE_MONSTER_SAY)

	target:transform(target.itemid == 10044 and 10045 or 10044)
	return true
end

zeeWayofZztonezzLevers:aid(8013)
zeeWayofZztonezzLevers:register()

local zeeWayofZztonezzGreaseOil = Action()

function zeeWayofZztonezzGreaseOil.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 8013 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline) == 13 then
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Questline, 14)
		player:setStorageValue(PlayerStorageKeys.ChildrenoftheRevolution.Mission04, 4) --Questlog, Children of the Revolution "Mission 4: Zze Way of Zztonezz"
		item:remove()
		player:say("Due to being extra greasy, the leavers can now be moved.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

zeeWayofZztonezzGreaseOil:id(11106)
zeeWayofZztonezzGreaseOil:register()

local zalamonDoor = Action()

function zalamonDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.TheNewFrontier.Mission08) >= 2 and player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission11) < 2 then
		if item.itemid == 10791 then
			player:teleportTo(toPosition, true)
			item:transform(item.itemid + 1)
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
	end
	return true
end

zalamonDoor:uid(3170)
zalamonDoor:register()
