local cStorages = {
	[2090] = PlayerStorageKeys.PitsOfInferno.ThroneInfernatil,
	[2091] = PlayerStorageKeys.PitsOfInferno.ThroneTafariel,
	[2092] = PlayerStorageKeys.PitsOfInferno.ThroneVerminor,
	[2093] = PlayerStorageKeys.PitsOfInferno.ThroneApocalypse,
	[2094] = PlayerStorageKeys.PitsOfInferno.ThroneBazir,
	[2095] = PlayerStorageKeys.PitsOfInferno.ThroneAshfalor,
	[2096] = PlayerStorageKeys.PitsOfInferno.ThronePumin
}

function onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() then
		return true
	end

	if creature:getStorageValue(cStorages[item.uid]) ~= 1 then
		creature:teleportTo(fromPosition)
		creature:say('You\'ve not absorbed energy from this throne.', TALKTYPE_MONSTER_SAY)
	end
	return true
end
