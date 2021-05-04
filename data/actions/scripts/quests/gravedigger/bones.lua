function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4633 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission17) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission19) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission19, 1)
		player:addItem(21406, 1)
		item:remove()
	end
	return true
end