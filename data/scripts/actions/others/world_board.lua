local worldBoard = Action()

local communicates = {
	[1] = {
		globalStorage = GlobalStorageKeys.WorldBoard.Yasir,
		communicate = "Oriental ships sighted! A trader for exotic creature products may currently be visiting Carlin, Ankrahmun or Liberty Bay."
	},

	[2] = {
		globalStorage = GlobalStorageKeys.WorldBoard.NightmareIsle.ankrahmunNorthEast,
		communicate = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. Avoid the Ankhramun tar pits!."
	},

	[3] = {
		globalStorage = GlobalStorageKeys.WorldBoard.NightmareIsle.darashiaNorth,
		communicate = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. Avoid the northernmost coast!"
	},

	[4] = {
		globalStorage = GlobalStorageKeys.WorldBoard.NightmareIsle.darashiaNorthWest,
		communicate = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. Avoid the river near Drefia!"
	}
}

function worldBoard.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for index, value in pairs(communicates) do
		if Game.getStorageValue(value.globalStorage) > 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, value.communicate)
		end
	end
	return true
end

worldBoard:id(21570)
worldBoard:register()
