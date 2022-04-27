function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	local target
	if param == "" then
		target = player:getTarget()
		if not target then
			player:sendCancelMessage("Gives players the ability to wear all addons. Usage: /addons <player name>")
			return false
		end
	else
		target = Player(param)
	end

	if not target then
		player:sendCancelMessage("Target not online.")
		return false
	end

	if target:getAccountType() > player:getAccountType() then
		player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Cannot perform action.")
		return false
	end

	target:addAddonToAllOutfits(3)

	player:sendTextMessage(MESSAGE_INFO_DESCR, "All addons unlocked for " .. target:getName())
	target:sendTextMessage(MESSAGE_INFO_DESCR, "[Server] All addons unlocked.")
	return false
end
