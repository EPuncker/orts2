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

local ectoplasmContainer = Action()

function ectoplasmContainer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 4206 then
		if player:getStorageValue(PlayerStorageKeys.TibiaTales.IntoTheBonePit) ~= 1 then
			return false
		end

		player:setStorageValue(PlayerStorageKeys.TibiaTales.IntoTheBonePit, 2)
		item:transform(4864)
		target:remove()
		toPosition:sendMagicEffect(CONST_ME_POFF)
	elseif target.itemid == 2913 then
		if player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 45 then
			player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 46)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			item:transform(4864)
			target:remove()
		end
	end
	return true
end

ectoplasmContainer:id(4863)
ectoplasmContainer:register()
