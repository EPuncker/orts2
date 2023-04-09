local tutorialCockroach = CreatureEvent("TutorialCockroach")

function tutorialCockroach.onKill(creature, target)
	local monsterTarget = Monster(target)
	if not monsterTarget then
		return true
	end

	if monsterTarget:getName():lower() ~= 'cockroach' then
		return true
	end

	local player = creature:getPlayer()
	if player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.cockroachKillStorage) < 1 then
		player:sendTutorial(8)
		player:setStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.cockroachKillStorage, 1)

	elseif player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.cockroachKillStorage) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You can also automatically chase after selected creatures by clicking the \'chase opponent\' button in the Combat Controls menu.')
		player:setStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.cockroachKillStorage, 2)
		player:sendTutorial(18)
		player:sendTutorial(38)
	end
	return true
end

tutorialCockroach:register()

local tutorialBranch = Action()

function tutorialBranch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 8600 then
		return false
	end

	item:remove(1)
	toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Well done! You successfully used a branch on Zirella's cart. Talk to her and tell her you did it!")
	player:setStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.ZirellaNpcGreetStorage, 7)
	player:setStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.ZirellaQuestLog, 7)
	return true
end

tutorialBranch:id(8582)
tutorialBranch:register()

local tutorialcockroachDeadBody = Action()

function tutorialcockroachDeadBody.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local owner = item:getAttribute(ITEM_ATTRIBUTE_CORPSEOWNER)
	if owner ~= nil and Player(owner) and player.uid ~= owner then
		return
	end

	if player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.cockroachBodyMsgStorage) ~= 1 then
		player:sendTutorial(9)
		player:setStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.cockroachBodyMsgStorage, 1)
	end
end

tutorialcockroachDeadBody:id(8593)
tutorialcockroachDeadBody:register()

local function doTransformSmallSnakeHead(fromId, toId)
	local tile = Position(32034, 32272, 8):getTile()
	if tile then
		local thing = tile:getItemById(fromId)
		if thing then
			thing:transform(toId)
		end
	end
end

local tutorialSnakeHead = Action()

function tutorialSnakeHead.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		doTransformSmallSnakeHead(5058, 5057)
	else
		doTransformSmallSnakeHead(5057, 5058)
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

tutorialSnakeHead:uid(50081)
tutorialSnakeHead:register()

local tutorialLadderReqCockroachLegs = Action()

function tutorialLadderReqCockroachLegs.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.uid == 50083 then
		if player:getItemCount(8710) < 3 then
			player:sendTutorial(39)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You still need to kill at least 3 cockroaches and bring their legs to Santiago. Don't give up!")
			return true
		end

		fromPosition.y = fromPosition.y + 1
		fromPosition.z = fromPosition.z - 1
		player:teleportTo(fromPosition, false)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "If your torch is still lit when you leave the cellar, you can turn it off again to save its power for darker regions.")
		return true
	end

	fromPosition.y = fromPosition.y + 1
	fromPosition.z = fromPosition.z - 1
	player:teleportTo(fromPosition, false)
	return true
end

tutorialLadderReqCockroachLegs:id(8599)
tutorialLadderReqCockroachLegs:register()

local tutorialDeadTreeBranch = Action()

function tutorialDeadTreeBranch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local playerexhaust = Condition(CONDITION_EXHAUST_WEAPON)
	playerexhaust:setParameter(CONDITION_PARAM_TICKS, 5000)

	if player:getCondition(CONDITION_EXHAUST_WEAPON) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wait a few seconds until this tree can be used again.")
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.ZirellaNpcGreetStorage) > 5 and player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.ZirellaNpcGreetStorage) < 7 then
		player:addCondition(playerexhaust)
		player:sendTutorial(24)

		local branch = player:addItem(8582, 1)
		branch:decay()

		if player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.tutorialHintsStorage) < 15 then
			player:setStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.tutorialHintsStorage, 15)
		end
	end
	return true
end

tutorialDeadTreeBranch:id(8583)
tutorialDeadTreeBranch:register()

local tutorialZirellaDoor = Action()

function tutorialZirellaDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 6898 then
		if player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.ZirellaNpcGreetStorage) > 7 then
			item:transform(item.itemid + 1)
			player:teleportTo(toPosition, true)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
		end
	end
	return true
end

tutorialZirellaDoor:uid(50085)
tutorialZirellaDoor:register()

local levelBridger = MoveEvent()

function levelBridger.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getLevel() >= 2 then
		return true
	end

	local failPosition = Position(32092, 32177, 6)
	player:teleportTo(failPosition)
	failPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need to be at least Level 2 in order to pass.')
	return true
end

levelBridger:type("stepin")
levelBridger:aid(50240)
levelBridger:register()

local premiumBridger = MoveEvent()

function premiumBridger.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:isPremium() then
		return true
	end

	local failPosition = Position(32066, 32192, 7)
	failPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	player:teleportTo(failPosition)
	return true
end

premiumBridger:type("stepin")
premiumBridger:aid(50241)
premiumBridger:register()

local tutorialTiles = MoveEvent()

local config = {
	[50058] = {markPos = Position(32000, 32278, 7), markId = MAPMARK_REDEAST, markDesc = 'To the Village', tutorialId = 2, storageValue = 1},
	[50059] = {effPos = Position(32007, 32276, 7), text = 'To look at objects such as this sign, right-click on them and select \'Look\'. Sometimes you have to walk a bit closer to signs. Messages like this can be reviewed at a later time by using the \'Server Log\' window, located at the bottom of the screen.', storageValue = 2},
	[50060] = {markPos = Position(32023, 32273, 7), markId = MAPMARK_GREENNORTH, markDesc = 'Santiago\'s Hut', text = 'Now continue to the next mark on your automap to the east. You can point your mouse cursor on a mark to read its name.', storageValue = 3},
	[50061] = {tutorialId = 21, effPos = Position(32023, 32273, 7), text = 'To go up stairs or ramps like this one, simply walk on them.', storageValue = 4},
	[50062] = {markPos = Position(32034, 32275, 6), markId = MAPMARK_REDSOUTH, markDesc = 'Santiago\'s Hut', text = 'This is Santiago, a Non-Player-Character. You can chat with NPCs by typing \'Hi\' or \'Hello\'. Walk to Santiago and try it!', storageValue = 5},
	[50063] = {tutorialId = 22, storageValue = 6},
	[50064] = {tutorialId = 4, storageValue = 7},
	[50065] = {effPos = Position(32033, 32278, 8), text = 'You can\'t see any cockroaches here. \'Open\' this chest and see if you can find something to light the room better.', storageValue = 8},
	[50066] = {text = 'Maybe you shouldn\'t stay in this forest longer than necessary. Zirella is waiting for her firewood!', storageValue = 13},
	[50067] = {effPos = Position(32035, 32285, 8), text = 'Look at the metallic object on the floor - this is a sewer grate. Right-click on it and select \'Use\' to climb down.', storageValue = 10},
	[50068] = {tutorialId = 7, text = 'You smell stinky cockroaches around here. When you see one, walk to it and attack it by left-clicking it in your battle list!', storageValue = 11},
	[50069] = {tutorialId = 23, effPos = Position(32035, 32285, 9), text = 'Right-click on the lower right end of the ladder - anywhere in the red frame - and select \'Use\' to climb up.', storageValue = 12},
	[50075] = {text = 'Do you have trouble finding those dead trees? Here are some - just \'Use\' them to break a branch.', storageValue = 14, effPos = Position(32067, 32281, 7), effPos2 = Position(32073, 32276, 7)},
	[50078] = {text = 'This is a loose stone pile. Right-click your shovel, select \'Use with\' and then left-click on the stonepile to dig it open.', storageValue = 18, effPos = Position(32070, 32266, 7)},
	[50079] = {text = 'Caves like this one are common in Tibia. To climb out again, you need something which you can find in this chest.', storageValue = 20, effPos = Position(32067, 32264, 8)}
}

function tutorialTiles.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local targetTableAid = config[item.actionid]
	if not targetTableAid then
		if item.actionid == 50069 then
			if player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.cockroachLegsMsgStorage) < 1 then
				return
			end
		elseif item.actionid == 50076 then
			if player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.tutorialHintsStorage) == 15 then
				player:setStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.tutorialHintsStorage, 16)
				Position(32062, 32271, 7):sendMagicEffect(CONST_ME_TUTORIALARROW)
				Position(32062, 32271, 7):sendMagicEffect(CONST_ME_TUTORIALARROW)
				player:sendTutorial(24)
			end
		elseif item.actionid == 50077 then
			if player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.ZirellaNpcGreetStorage) == 8 and player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.tutorialHintsStorage) < 17 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This is Zirella\'s door. Right-click on the lower part of the door and select \'Use\' to open it.')
				player:setStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.tutorialHintsStorage, 17)
			end
			if player:getStorageValue(PlayerStorageKeys.QuestChests.TutorialShovel) == 1 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Good, now continue to the east to find a place to try out your shovel.')
				player:setStorageValue(PlayerStorageKeys.QuestChests.TutorialShovel, 2)
			end
		elseif item.actionid == 50081 then
			if player:getStorageValue(PlayerStorageKeys.QuestChests.TutorialRope) == 1 and player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.tutorialHintsStorage) < 21 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'To climb out of this cave right-click your rope, select \'Use with\' then left-click on the dark spot on the floor, the ropespot.')
				Position(32070, 32266, 8):sendMagicEffect(CONST_ME_TUTORIALARROW)
				Position(32070, 32266, 8):sendMagicEffect(CONST_ME_TUTORIALSQUARE)
				player:setStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.tutorialHintsStorage, 21)
			end
		end
		return
	end

	if item.actionid == 50078 then
		if player:getStorageValue(PlayerStorageKeys.QuestChests.TutorialShovel) < 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have not claimed your reward from Zirella house.')
			player:teleportTo(fromPosition, true)
			return
		end
	elseif item.actionid == 50069 then
		if player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.SantiagoNpcGreetStorage) < 6 then
			return true
		end
	end

	if player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.tutorialHintsStorage) < targetTableAid.storageValue then
		player:setStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.tutorialHintsStorage, targetTableAid.storageValue)

		if targetTableAid.tutorialId then
			player:sendTutorial(targetTableAid.tutorialId)
		end

		if item.actionid == 50075 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetTableAid.text)
		end

		if targetTableAid.text then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetTableAid.text)
		end

		if targetTableAid.effPos then
			targetTableAid.effPos:sendMagicEffect(CONST_ME_TUTORIALARROW)
			targetTableAid.effPos:sendMagicEffect(CONST_ME_TUTORIALSQUARE)
		end

		if targetTableAid.effPos2 then
			targetTableAid.effPos2:sendMagicEffect(CONST_ME_TUTORIALARROW)
			targetTableAid.effPos2:sendMagicEffect(CONST_ME_TUTORIALSQUARE)
		end

		if targetTableAid.markPos then
			player:addMapMark(targetTableAid.markPos, targetTableAid.markId, targetTableAid.markDesc)
		end
	end
	return true
end

tutorialTiles:type("stepin")
tutorialTiles:aid(50058, 50059, 50060, 50061, 50062, 50063, 50064, 50065, 50066, 50067, 50068, 50069, 50075, 50076, 50077, 50078, 50079, 50081)
tutorialTiles:register()

local tutorialStopTiles = MoveEvent()

local config = {
	[50070] = {storageKey = PlayerStorageKeys.RookgaardTutorialIsland.SantiagoNpcGreetStorage, storageValue = 12, text = 'You have no business in this part of the island anymore. Continue by solving Santiago\'s quest!', storageValue2 = 12, text2 = 'You have no business in this area of the island anymore. Talk to Santiago to learn how to continue.'},
	[50071] = {storageKey = PlayerStorageKeys.RookgaardTutorialIsland.SantiagoNpcGreetStorage, storageValue = 12, text = 'Santiago really needs help, maybe you should have a look. Talk to him by typing \'Hi\' or \'Hello\'.'},
	[50072] = {storageKey = PlayerStorageKeys.RookgaardTutorialIsland.SantiagoNpcGreetStorage, storageValue = 2, text = 'This is Santiago\'s room. Maybe you should talk to him before sniffing around in his house.'},
	[50073] = {storageKey = PlayerStorageKeys.RookgaardTutorialIsland.SantiagoNpcGreetStorage, storageValue = 5, text = 'This is Santiago\'s cellar. You have no business there yet.', storageValue2 = 6, text2 = 'This is Santiago\'s cellar - and you wouldn\'t want to go back to this nasty place.'},
	[50074] = {storageKey = PlayerStorageKeys.RookgaardTutorialIsland.SantiagoNpcGreetStorage, storageValue = 14, text = 'You don\'t have any business there anymore. Continue to the east!'},
	[50080] = {storageKey = PlayerStorageKeys.RookgaardTutorialIsland.ZirellaNpcGreetStorage, storageValue = 1, text = 'Zirella really needs help, go talk to her.', storageValue3 = 7, text3 = 'This is not the way to the forest. You should head southwest first.'},
	[50088] = {storageKey = PlayerStorageKeys.RookgaardTutorialIsland.tutorialHintsStorage, storageValue = 20, text = 'Before you head to the village, dig open that hole with your shovel and climb down. You will find something useful down there.'},
	[50089] = {storageKey = PlayerStorageKeys.RookgaardTutorialIsland.CarlosQuestLog, storageValue = 7, text = 'You are not ready to enter the village of Rookgaard yet. You should talk to Carlos some more.', storageValue2 = 7, text2 = 'You have no business anymore on the other side of Rookgaard.'}
}

local allowPass = {}

function tutorialStopTiles.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local targetTableAid = config[item.actionid]
	if not targetTableAid then
		if item.itemid == 8596 then
			local playerPos = player:getPosition()
			player:teleportTo(Position(playerPos.x + 1, playerPos.y, playerPos.z + 1), false)
		end
		return
	end

	local playerId = player.uid
	if item.actionid == 50070 then
		if player:getStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.tutorialHintsStorage) == 5 then
			return true
		end
	elseif item.actionid == 50071 then
		allowPass[playerId] = true
	elseif item.actionid == 50074 then
		if allowPass[playerId] then
			local playerPos = player:getPosition()
			player:teleportTo(Position(playerPos.x + 1, playerPos.y, playerPos.z), false)
			allowPass[playerId] = nil
			return true
		end
	end

	if player:getStorageValue(targetTableAid.storageKey) < targetTableAid.storageValue then
		player:teleportTo(fromPosition, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetTableAid.text)
		return
	end

	if targetTableAid.storageValue2 then
		if player:getStorageValue(targetTableAid.storageKey) > targetTableAid.storageValue2 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetTableAid.text2)
			player:teleportTo(fromPosition, true)
			return
		end
	end

	if targetTableAid.storageValue3 then
		if player:getStorageValue(targetTableAid.storageKey) < targetTableAid.storageValue3 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetTableAid.text3)
			player:teleportTo(fromPosition, true)
			return
		end
	end

	if item.actionid == 50089 then
		player:setTown(Town(6)) -- set rookgaard citizen
		player:setStorageValue(PlayerStorageKeys.RookgaardTutorialIsland.CarlosQuestLog, 8)
		player:sendTutorial(14)
		local playerPos = player:getPosition()
		player:teleportTo(Position(playerPos.x, playerPos.y - 1, playerPos.z), true)
	end

	if item.itemid == 8595 then
		local playerPos = player:getPosition()
		player:teleportTo(Position(playerPos.x, playerPos.y, playerPos.z + 1), false)
	elseif item.itemid == 8709 then
		local playerPos = player:getPosition()
		player:teleportTo(Position(playerPos.x - 1, playerPos.y, playerPos.z - 1), false)
	end
	return true
end

tutorialStopTiles:type("stepin")
tutorialStopTiles:aid(50070, 50071, 50072, 50073, 50074, 50080, 50088, 50089)
tutorialStopTiles:id(8596)
tutorialStopTiles:register()
