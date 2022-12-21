local flask = Action()

local config = {
	[1496] = {text = 'This mission stinks ... and now you do as well!', condition = true, transformId = 7477},
	[6065] = {text = 'You carefully gather the quara ink', transformId = 7489},
	[20514] = {text = 'You carefully gather the stalker blood.', transformId = 7488}
}

local poisonField = Condition(CONDITION_OUTFIT)
poisonField:setTicks(8000)
poisonField:setOutfit({lookTypeEx = 1496})


function flask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItem = config[target.itemid]
	if not targetItem then
		return false
	end

	if targetItem.condition then
		player:addCondition(poisonField)
	end

	player:say(targetItem.text, TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_HITBYPOISON)
	item:transform(targetItem.transformId)
	return true
end

flask:id(7478)
flask:register()

local crate = Action()

function crate.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 7481 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.WhatAFoolishQuest.Questline) ~= 8 then
		return false
	end

	player:getPosition():sendMagicEffect(CONST_ME_SOUND_GREEN)
	player:say('Your innocent whistle will fool them all...', TALKTYPE_MONSTER_SAY)
	toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
	item:transform(item.itemid + 1)
	return true
end

crate:id(7482)
crate:register()

local cushion = Action()

function cushion.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4203 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.WhatAFoolishQuest.Questline) ~= 17 or player:getStorageValue(PlayerStorageKeys.WhatAFoolishQuest.WhoopeeCushion) == 1 then
		return false
	end

	player:setStorageValue(PlayerStorageKeys.WhatAFoolishQuest.WhoopeeCushion, 1)
	player:say('*chuckles maniacally*', TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	player:say('Woooosh!', TALKTYPE_MONSTER_SAY, false, player, toPosition)
	item:remove()
	return true
end

cushion:id(7485)
cushion:register()

local catbasket = Action()

local effectPositions = {
	Position(32312, 31745, 9),
	Position(32313, 31745, 9),
	Position(32314, 31746, 9),
	Position(32315, 31746, 9),
	Position(32316, 31746, 9),
	Position(32317, 31745, 9)
}

local function removeKitty(monsterId)
	local monster = Monster(monsterId)
	if monster then
		monster:remove()
	end
end

function catbasket.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.WhatAFoolishQuest.Questline) ~= 19 or player:getStorageValue(PlayerStorageKeys.WhatAFoolishQuest.CatBasket) == 1 then
		return false
	end

	player:setStorageValue(PlayerStorageKeys.WhatAFoolishQuest.CatBasket, 1)
	player:say('The queen\'s cat is not amused!', TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_DRAWBLOOD)
	player:say('Fchhhhh', TALKTYPE_MONSTER_SAY, false, player, effectPositions[1])

	for i = 1, #effectPositions do
		effectPositions[i]:sendMagicEffect(CONST_ME_POFF)
	end

	Game.createItem(7487, 1, toPosition)
	toPosition:sendMagicEffect(CONST_ME_POFF)
	local monster = Game.createMonster('Kitty', Position(toPosition.x, toPosition.y + 1, toPosition.z))
	addEvent(removeKitty, 10000, monster.uid)
	return true
end

catbasket:id(7486)
catbasket:register()

local contract = Action()

function contract.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 7492 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.WhatAFoolishQuest.Contract) ~= 1 then
		return false
	end

	player:say('You sign the contract', TALKTYPE_MONSTER_SAY)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	item:remove()
	target:transform(7491)
	return true
end

contract:id(7490)
contract:register()

local worncloth = Action()

function worncloth.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4204 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.WhatAFoolishQuest.Questline) ~= 34 or player:getStorageValue(PlayerStorageKeys.WhatAFoolishQuest.OldWornCloth) == 1 then
		return false
	end

	player:setStorageValue(PlayerStorageKeys.WhatAFoolishQuest.OldWornCloth, 1)
	player:say('Amazing! That was quite fast!', TALKTYPE_MONSTER_SAY)
	toPosition:sendMagicEffect(CONST_ME_BLOCKHIT)
	item:transform(7501)
	return true
end

worncloth:id(7500)
worncloth:register()

local disguise = Action()

local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(10000)
condition:setOutfit({lookType = 65})

function disguise.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:addCondition(condition)
	player:say('You are now disguised as a mummy for 10 seconds. Hurry up and scare the caliph!', TALKTYPE_MONSTER_SAY)
	return true
end

disguise:id(7502)
disguise:register()

local watch = Action()

local targetDestination = {
	Position(32659, 31853, 13),
	Position(32646, 31903, 3)
}

function watch.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.WhatAFoolishQuest.Questline) ~= 11 then
		return false
	end

	local playerPos = player:getPosition()
	if not table.contains(targetDestination, playerPos) then
		return false
	end

	local destination = playerPos == targetDestination[2] and targetDestination[1] or targetDestination[2]
	if destination.z == 6 then
		item:remove()
	end

	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	player:say('You are travelling in time', TALKTYPE_MONSTER_SAY)
	return true
end

watch:id(8187)
watch:register()
