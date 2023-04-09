local ultimateBoozeBeerBottle = Action()

function ultimateBoozeBeerBottle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 8176 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.TibiaTales.ultimateBoozeQuest) == 1 then
		player:setStorageValue(PlayerStorageKeys.TibiaTales.ultimateBoozeQuest, 2)
	end

	player:removeItem(7496, 1)
	player:addItem(7495, 1)
	player:say("GULP, GULP, GULP", TALKTYPE_MONSTER_SAY, false, 0, toPosition)
	toPosition:sendMagicEffect(CONST_ME_SOUND_YELLOW)
	return true
end

ultimateBoozeBeerBottle:id(7496)
ultimateBoozeBeerBottle:register()

local exterminatorFlask = Action()

function exterminatorFlask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4207 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.TibiaTales.TheExterminator) ~= 1 then
		return false
	end

	player:setStorageValue(PlayerStorageKeys.TibiaTales.TheExterminator, 2)
	item:transform(2006, 0)
	toPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
	return true
end

exterminatorFlask:id(8205)
exterminatorFlask:register()
