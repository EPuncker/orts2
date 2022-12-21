local musicSheet = Action()

local config = {
	[6087] = {storage = PlayerStorageKeys.OutfitQuest.Hunter.MusicSheet01, text = 'first'},
	[6088] = {storage = PlayerStorageKeys.OutfitQuest.Hunter.MusicSheet02, text = 'second'},
	[6089] = {storage = PlayerStorageKeys.OutfitQuest.Hunter.MusicSheet03, text = 'third'},
	[6090] = {storage = PlayerStorageKeys.OutfitQuest.Hunter.MusicSheet04, text = 'fourth'}
}

function musicSheet.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.itemid]
	if not useItem then
		return true
	end

	local cStorage = useItem.storage
	if player:getStorageValue(cStorage) ~= 1 then
		player:setStorageValue(cStorage, 1)
		player:sendTextMessage(MESSAGE_STATUS_WARNING, 'You have learned the ' .. useItem.text .. ' part of a hymn.')
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		item:remove(1)
	else
		player:sendTextMessage(MESSAGE_STATUS_WARNING, 'You already know the ' .. useItem.text .. ' verse of the hymn.')
	end
	return true
end

musicSheet:id(6087, 6088, 6089, 6090)
musicSheet:register()

local allHymnPianoTeleport = Action()

function allHymnPianoTeleport.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 33216 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.OutfitQuest.Hunter.MusicSheet01) == 1 and player:getStorageValue(PlayerStorageKeys.OutfitQuest.Hunter.MusicSheet02) == 1 and player:getStorageValue(PlayerStorageKeys.OutfitQuest.Hunter.MusicSheet03) == 1 and player:getStorageValue(PlayerStorageKeys.OutfitQuest.Hunter.MusicSheet04) == 1 then
		local portpos = Position(32402, 32794, 9)
		player:teleportTo(portpos, false)
		portpos:sendMagicEffect(CONST_ME_TELEPORT)
		toPosition:sendMagicEffect(CONST_ME_SOUND_YELLOW)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have not learned all the verses of the hymn")
		toPosition:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

allHymnPianoTeleport:aid(33216)
allHymnPianoTeleport:register()
