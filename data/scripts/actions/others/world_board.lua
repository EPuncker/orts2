local worldBoard = Action()

local communicates = {
	[1] = {
		globalStorage = GlobalStorageKeys.WorldBoard.Yasir,
		communicate = "Oriental ships sighted! A trader for exotic creature products may currently be visiting Carlin, Ankrahmun or Liberty Bay."
	},
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
