local versperothKill = CreatureEvent("BigfootBurdenVersperoth")

local teleportPosition = Position(33075, 31878, 12)

local function transformTeleport()
	local teleportItem = Tile(teleportPosition):getItemById(1387)
	if not teleportItem then
		return
	end

	teleportItem:transform(18463)
end

local function clearArena()
	local spectators = Game.getSpectators(Position(33088, 31911, 12), false, false, 12, 12, 12, 12)
	local exitPosition = Position(32993, 31912, 12)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(exitPosition)
			exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
			spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You were teleported out by the gnomish emergency device.')
		else
			spectator:remove()
		end
	end
end

function versperothKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'versperoth' then
		return true
	end

	Game.setStorageValue(GlobalStorageKeys.Versperoth.Battle, 2)
	addEvent(Game.setStorageValue, 30 * 60 * 1000, GlobalStorageKeys.Versperoth.Battle, 0)

	local holeItem = Tile(teleportPosition):getItemById(18462)
	if holeItem then
		holeItem:transform(1387)
	end
	Game.createMonster('abyssador', Position(33086, 31907, 12))

	addEvent(transformTeleport, 30 * 60 * 1000)
	addEvent(clearArena, 32 * 60 * 1000)
	return true
end

versperothKill:register()

local warzoneKill = CreatureEvent("BigfootBurdenWarzone")

local bosses = {
	['deathstrike'] = {status = 2, storage = PlayerStorageKeys.BigfootBurden.Warzone1Reward},
	['gnomevil'] = {status = 3, storage = PlayerStorageKeys.BigfootBurden.Warzone2Reward},
	['abyssador'] = {status = 4, storage = PlayerStorageKeys.BigfootBurden.Warzone3Reward},
}

function warzoneKill.onKill(creature, target)
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
	return true
end

warzoneKill:register()

local weeperKill = CreatureEvent("BigfootBurdenWeeper")

local positions = {
	Position(33097, 31976, 11),
	Position(33097, 31977, 11),
	Position(33097, 31978, 11),
	Position(33097, 31979, 11)
}

local barrierPositions = {
	Position(33098, 31976, 11),
	Position(33098, 31977, 11),
	Position(33098, 31978, 11),
	Position(33098, 31979, 11)
}

local function clearArena()
	local spectators = Game.getSpectators(Position(33114, 31956, 11), false, false, 10, 10, 13, 13)
	local exitPosition = Position(33011, 31937, 11)
	for i = 1, #spectators do
		local spectator = spectators[i]
		if spectator:isPlayer() then
			spectator:teleportTo(exitPosition)
			exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
			spectator:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You were teleported out by the gnomish emergency device.')
		else
			spectator:remove()
		end
	end
end

-- This script is unfinished after conversion, but I doubt that it was working as intended before
-- 'last' can never be true
function weeperKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'parasite' or Game.getStorageValue(GlobalStorageKeys.Weeper) >= 1 then
		return true
	end

	local targetPosition = targetMonster:getPosition()
	local barrier = false
	for i = 1, #positions do
		if targetPosition == positions[i] then
			barrier = true
			break
		end
	end

	if not barrier then
		return true
	end

	local last = false
	local tile, item
	for i = 1, #barrierPositions do
		tile = Tile(barrierPositions[i])
		if tile then
			item = tile:getItemById(18459)
			if item then
				item:transform(19460)
			end

			item = tile:getItemById(18460)
			if item then
				item:transform(19461)
			end
		end
	end

	if not last then
		return true
	end

	Game.setStorageValue(GlobalStorageKeys.Weeper, 1)
	addEvent(Game.setStorageValue, 30 * 60 * 1000, GlobalStorageKeys.Weeper, 0)
	Game.createMonster('gnomevil', Position(33114, 31953, 11))
	addEvent(clearArena, 32 * 60 * 1000)
	return true
end

weeperKill:register()

local wigglerKill = CreatureEvent("BigfootBurdenWiggler")

function wigglerKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'wiggler' then
		return true
	end

	local player = creature:getPlayer()
	local value = player:getStorageValue(PlayerStorageKeys.BigfootBurden.ExterminatedCount)
	if value < 10 and player:getStorageValue(PlayerStorageKeys.BigfootBurden.MissionExterminators) == 1 then
		player:setStorageValue(PlayerStorageKeys.BigfootBurden.ExterminatedCount, value + 1)
	end
	return true
end

wigglerKill:register()
