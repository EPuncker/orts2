function onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	local target
	if param == "" then
		target = player:getTarget()
		if not target then
			player:sendCancelMessage("Unlocks all mounts for a certain player. Usage: /mounts <player name>")
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

	target:addAllMounts()

	player:sendTextMessage(MESSAGE_INFO_DESCR, "All mounts unlocked for " .. target:getName())
	target:sendTextMessage(MESSAGE_INFO_DESCR, "[Server] All mounts unlocked.")
	return false
end
