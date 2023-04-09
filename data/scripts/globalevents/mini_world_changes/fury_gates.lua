local furyGates = GlobalEvent("furyGates")

function furyGates.onStartup(interval)
	Game.setStorageValue(GlobalStorageKeys.FuryGates, math.random(6))
end

furyGates:register()
