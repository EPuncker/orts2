local botanist = Action()

function botanist.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 4138 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 16 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 17)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4870)
		target:remove()
	elseif target.itemid == 4149 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 19 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 20)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4871)
		target:remove()
	elseif target.itemid == 4242 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 24 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 25)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		item:transform(4872)
		target:remove()
	elseif target.itemid == 5659 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 24 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 25)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_RED)
		item:transform(5937)
	end
	return true
end

botanist:id(4869)
botanist:register()

local butterfly = Action()

local config = {
	[8] = {newValue = 9, transformId = 4866},
	[11] = {newValue = 12, transformId = 4867},
	[14] = {newValue = 15, transformId = 4868}
}

function butterfly.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 4313 then
		return false
	end

	local storage = config[player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine)]
	if not storage then
		return true
	end

	player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, storage.newValue)
	toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	item:transform(PlayerStorageKeys.transformId)
	target:remove()
	return true
end

butterfly:id(4865)
butterfly:register()

local dragon = Action()

function dragon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 57 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 58)
		Game.createItem(7314, 1, player:getPosition())
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

dragon:uid(3017)
dragon:register()

local icicle = Action()

function icicle.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid == 4995 and target.uid == 3000 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 5 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 6)
		player:addItem(4848, 1)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

icicle:id(4856)
icicle:register()

local resonance = Action()

function resonance.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.uid == 3018 then
		if player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 60 then
			player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 61)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
	end
	return true
end

resonance:id(7281)
resonance:register()

local stone = Action()

function stone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.uid == 3015 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 54 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 55)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif target.uid == 3016 and player:getStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine) == 55 then
		player:setStorageValue(PlayerStorageKeys.ExplorerSociety.QuestLine, 56)
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

stone:id(7242)
stone:register()
