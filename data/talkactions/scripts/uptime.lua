function onSay(player, words, param)
	local uptime = getWorldUpTime()

	local hours = math.floor(uptime / 3600)
	local minutes = math.floor((uptime - (3600 * hours)) / 60)
	player:sendTextMessage(MESSAGE_INFO_DESCR, "Uptime: " .. hours .. " hours and " .. minutes .. " minutes.")
	return false
end
