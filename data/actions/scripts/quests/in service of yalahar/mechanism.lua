local mechanisms = {
	[3091] = {pos = Position(32744, 31161, 5), value = 21}, -- Alchemist
	[3092] = {pos = Position(32744, 31164, 5), value = 21},
	[3093] = {pos = Position(32833, 31269, 5), value = 24}, -- Trade
	[3094] = {pos = Position(32833, 31266, 5), value = 24},
	[3095] = {pos = Position(32729, 31200, 5), value = 29}, -- Arena
	[3096] = {pos = Position(32734, 31200, 5), value = 29},
	[3097] = {pos = Position(32776, 31141, 5), value = 35}, -- Cemetery
	[3098] = {pos = Position(32776, 31145, 5), value = 35},
	[3099] = {pos = Position(32874, 31202, 5), value = 41}, -- Sunken
	[3100] = {pos = Position(32869, 31202, 5), value = 41},
	[3101] = {pos = Position(32856, 31251, 5), value = 45}, -- Factory
	[3102] = {pos = Position(32854, 31248, 5), value = 45}
}

local mechanisms2 = {
	[9235] = {pos = Position(32773, 31116, 7)},
	[9236] = {pos = Position(32780, 31115, 7)}
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if(mechanisms[item.uid]) then
		if(player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline) >= mechanisms[item.uid].value) then
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(mechanisms[item.uid].pos)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The gate mechanism won't move. You probably have to find a way around until you figure out how to operate the gate.")
		end
	elseif(mechanisms2[item.uid]) then
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(mechanisms2[item.uid].pos)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end
