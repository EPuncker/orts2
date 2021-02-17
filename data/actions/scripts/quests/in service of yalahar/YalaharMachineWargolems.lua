local config = {
	[23700] = {
		storage = GlobalStorage.InServiceOfYalahar.WarGolemsMachine1,
		machines = {
			Position(32882, 31323, 10),
			Position(32882, 31320, 10),
			Position(32882, 31318, 10),
			Position(32882, 31316, 10)
		}
	},
	[23701] = {
		storage = GlobalStorage.InServiceOfYalahar.WarGolemsMachine2,
		machines = {
			Position(32869, 31322, 10),
			Position(32869, 31320, 10),
			Position(32869, 31318, 10),
			Position(32869, 31316, 10)
		}
	}
}

local function disableMachine(storage)
	Game.setStorageValue(storage, -1)
end

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local machineGroup = config[item.actionid]
	if not machineGroup then
		return true
	end

	if Game.getStorageValue(machineGroup.storage) == 1 then
		return true
	end

	if player:getItemCount(9690) < 4 then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You don\'t have enough gear wheels to activate the machine.')
		return true
	end

	Game.setStorageValue(machineGroup.storage, 1)
	addEvent(disableMachine, 60 * 60 * 1000, machineGroup.storage)
	player:removeItem(9690, 4)
	for i = 1, #machineGroup.machines do
		player:say('*CLICK*', TALKTYPE_MONSTER_YELL, false, player, machineGroup.machines[i])
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You insert all 4 gear wheels, them adjusting the teleporter to transport you to the deeper floor')
	return true
end
