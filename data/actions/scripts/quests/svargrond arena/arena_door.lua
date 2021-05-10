local storages = {
	[26100] = PlayerStorageKeys.SvargrondArena.Greenhorn,
	[27100] = PlayerStorageKeys.SvargrondArena.Scrapper,
	[28100] = PlayerStorageKeys.SvargrondArena.Warlord
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	-- Cannot use opened door
	if item.itemid == 5133 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.SvargrondArena.Arena) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This door seems to be sealed against unwanted intruders.')
		return true
	end

	-- Doors to rewards
	local cStorage = storages[item.actionid]
	if cStorage then
		if player:getStorageValue(cStorage) ~= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'It\'s locked.')
			return true
		end

		item:transform(item.itemid + 1)
		player:teleportTo(toPosition, true)

	-- Arena entrance doors
	else
		if player:getStorageValue(PlayerStorageKeys.SvargrondArena.Pit) ~= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This door seems to be sealed against unwanted intruders.')
			return true
		end

		item:transform(item.itemid + 1)
		player:teleportTo(toPosition, true)
	end

	return true
end
