local cilliaSpawn = GlobalEvent("cilliaSpawn")

function cilliaSpawn.onStartup()
	if os.date("%A") == "Sunday" then
		Game.createNpc("Cillia", Position(32392, 32197, 8), false, true)
	end

	return true
end

cilliaSpawn:register()
