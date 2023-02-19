local config = {
	{displayName = "North of Ankrahmun", mapName = "ankrahmun-north", storage = GlobalStorageKeys.WorldBoard.NightmareIsle.ankrahmunNorthEast},
	{displayName = "North of Darashia", mapName = "darashia-north", storage = GlobalStorageKeys.WorldBoard.NightmareIsle.darashiaNorth},
	{displayName = "West of Darashia", mapName = "darashia-west", storage = GlobalStorageKeys.WorldBoard.NightmareIsle.darashiaNorthWest}
}

local nightmareIsle = GlobalEvent("Nightmare Isle")

function nightmareIsle.onStartup()
	for i = 1, #config do
		local table = config[i]
		Game.setStorageValue(table.storage, 0)
	end

	local randomMap = config[math.random(#config)]
	Game.loadMap("data/world/mini_world_changes/nightmare_isles/" .. randomMap.mapName .. ".otbm")
	Game.setStorageValue(randomMap.storage, 1)
	print(">> Nightmare Isle is active in " .. randomMap.displayName)
	return true
end

nightmareIsle:register()
