local cToneStorages = {
	PlayerStorageKeys.BigfootBurden.MelodyTone1,
	PlayerStorageKeys.BigfootBurden.MelodyTone2,
	PlayerStorageKeys.BigfootBurden.MelodyTone3,
	PlayerStorageKeys.BigfootBurden.MelodyTone4,
	PlayerStorageKeys.BigfootBurden.MelodyTone5,
	PlayerStorageKeys.BigfootBurden.MelodyTone6,
	PlayerStorageKeys.BigfootBurden.MelodyTone7
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine) == 12 then
		local value = player:getStorageValue(PlayerStorageKeys.BigfootBurden.MelodyStatus)
		if player:getStorageValue(cToneStorages[value]) == item.uid then
			player:setStorageValue(PlayerStorageKeys.BigfootBurden.MelodyStatus, value + 1)
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			if value + 1 == 8 then
				player:setStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine, 13)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found your melody!")
			end
		else
			player:setStorageValue(PlayerStorageKeys.BigfootBurden.MelodyStatus, 1)
			toPosition:sendMagicEffect(CONST_ME_SOUND_RED)
		end
	end
	return true
end
