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
