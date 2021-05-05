local bosses = {
	['deathstrike'] = {status = 2, storage = Storage.BigfootBurden.Warzone1Reward},
	['gnomevil'] = {status = 3, storage = Storage.BigfootBurden.Warzone2Reward},
	['abyssador'] = {status = 4, storage = Storage.BigfootBurden.Warzone3Reward},
}

function onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	local bossConfig = bosses[targetMonster:getName():lower()]
	if not bossConfig then
		return true
	end

	for pid, _ in pairs(targetMonster:getDamageMap()) do
		local attackerPlayer = Player(pid)
		if attackerPlayer then
			if attackerPlayer:getStorageValue(PlayerStorageKeys.BigfootBurden.WarzoneStatus) < bossConfig.status then
				attackerPlayer:setStorageValue(PlayerStorageKeys.BigfootBurden.WarzoneStatus, bossConfig.status)
			end

			attackerPlayer:setStorageValue(bossConfig.storage, 1)
		end
	end
end