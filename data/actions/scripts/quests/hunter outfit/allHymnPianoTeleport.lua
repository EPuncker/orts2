local portpos = Position(32402, 32794, 9)

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 33216 then
		return false
	end

	if player:getStorageValue(Storage.OutfitQuest.Hunter.MusicSheet01) == 1 and player:getStorageValue(Storage.OutfitQuest.Hunter.MusicSheet02) == 1 and player:getStorageValue(Storage.OutfitQuest.Hunter.MusicSheet03) == 1 and player:getStorageValue(Storage.OutfitQuest.Hunter.MusicSheet04) == 1 then
		player:teleportTo(portpos, false)
		portpos:sendMagicEffect(CONST_ME_TELEPORT)
		toPosition:sendMagicEffect(CONST_ME_SOUND_YELLOW)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have not learned all the verses of the hymn")
		toPosition:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end