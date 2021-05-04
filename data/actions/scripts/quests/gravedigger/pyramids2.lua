function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({4663, 4664, 4665, 4666, 4667}, target.actionid) then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission61) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission62) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission62, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<screeeech> <squeak> <squeaaaaal>')
	elseif player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission62) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission63) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission63, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<screeeech> <squeak> <squeaaaaal>')
	elseif player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission63) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission64) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission64, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<screeeech> <squeak> <squeaaaaal>')
	elseif player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission64) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission65) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission65, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<screeeech> <squeak> <squeaaaaal>')
	elseif player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission65) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission66) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission66, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<screeeech> <squeak> <squeaaaaal>')
	end
	return true
end