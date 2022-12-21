local raids = {
	["Monday"] = {
		["08:00"] = {raidName = "RatsThais"},
		["15:00"] = {raidName = "Arachir the Ancient One"}
	},
	["Wednesday"] = {
		["12:00"] = {raidName = "OrcsThais"}
	},
	["31/10"] = {
		["16:00"] = {raidName = "Halloween Hare"}
	}
}

local spawnMonsters = GlobalEvent("spawnMonsters")

function spawnMonsters.onThink(interval, lastExecution, thinkInterval)
	local day, date = os.date("%A"), getRealDate()
	local raidDays = {}
	if raids[day] then
		raidDays[#raidDays + 1] = raids[day]
	end

	if raids[date] then
		raidDays[#raidDays + 1] = raids[date]
	end

	if #raidDays == 0 then
		return true
	end

	for i = 1, #raidDays do
		local settings = raidDays[i][getRealTime()]
		if settings and not settings.alreadyExecuted then
			Game.startRaid(settings.raidName)
			settings.alreadyExecuted = true
		end
	end

	return true
end

spawnMonsters:interval(10000)
spawnMonsters:register()
