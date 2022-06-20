local spheres = {
	[8300] = {VOCATION_PALADIN, VOCATION_ROYAL_PALADIN},
	[8304] = {VOCATION_SORCERER, VOCATION_MASTER_SORCERER},
	[8305] = {VOCATION_DRUID, VOCATION_ELDER_DRUID},
	[8306] = {VOCATION_KNIGHT, VOCATION_ELITE_KNIGHT}
}

local globalTable = {
	[VOCATION_SORCERER] = 10005,
	[VOCATION_DRUID] = 10006,
	[VOCATION_PALADIN] = 10007,
	[VOCATION_KNIGHT] = 10008
}

function onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({7917, 7918, 7913, 7914}, target.itemid) then
		return false
	end

	if not toPosition:isInRange(Position(33238, 31806, 12), Position(33297, 31865, 12)) then
		return false
	end

	if not table.contains(spheres[item.itemid], player:getVocation():getId()) then
		return false
	end

	if table.contains({7917, 7918}, target.itemid) then
		player:say('Turn off the machine first.', TALKTYPE_MONSTER_SAY)
		return true
	end

	toPosition:sendMagicEffect(CONST_ME_PURPLEENERGY)
	Game.setStorageValue(globalTable[player:getVocation():getBase():getId()], 1)
	item:remove(1)
	return true
end
