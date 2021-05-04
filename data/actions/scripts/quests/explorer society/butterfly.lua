local config = {
	[8] = {newValue = 9, transformId = 4866},
	[11] = {newValue = 12, transformId = 4867},
	[14] = {newValue = 15, transformId = 4868}
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
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