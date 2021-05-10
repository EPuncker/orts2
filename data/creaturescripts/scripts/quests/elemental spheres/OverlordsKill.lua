local overlords = {
	['energy overlord'] = {cStorage = PlayerStorageKeys.ElementalSphere.BossStorage, cGlobalStorage = GlobalStorageKeys.ElementalSphere.KnightBoss},
	['fire overlord'] = {cStorage = PlayerStorageKeys.ElementalSphere.BossStorage, cGlobalStorage = GlobalStorageKeys.ElementalSphere.SorcererBoss},
	['ice overlord'] = {cStorage = PlayerStorageKeys.ElementalSphere.BossStorage, cGlobalStorage = GlobalStorageKeys.ElementalSphere.PaladinBoss},
	['earth overlord'] = {cStorage = PlayerStorageKeys.ElementalSphere.BossStorage, cGlobalStorage = GlobalStorageKeys.ElementalSphere.DruidBoss},
	['lord of the elements'] = {}
}

function onKill(creature, target)
	if not target:isMonster() then
		return true
	end

	local bossName = target:getName()
	local bossConfig = overlords[bossName:lower()]
	if not bossConfig then
		return true
	end

	if bossConfig.cGlobalStorage then
		Game.setStorageValue(bossConfig.cGlobalStorage, 0)
	end

	if bossConfig.cStorage and creature:getStorageValue(bossConfig.cStorage) < 1 then
		creature:setStorageValue(bossConfig.cStorage, 1)
	end

	creature:say('You slayed ' .. bossName .. '.', TALKTYPE_MONSTER_SAY)
	return true
end
