local kills = CreatureEvent("KillingInTheNameOfKills")

function kills.onKill(creature, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end

	local targetName, startedTasks, taskId = target:getName():lower(), player:getStartedTasks()
	for i = 1, #startedTasks do
		taskId = startedTasks[i]
		if table.contains(tasks[taskId].creatures, targetName) then
			local killAmount = player:getStorageValue(KILLSSTORAGE_BASE + taskId)
			if killAmount < tasks[taskId].killsRequired then
				player:setStorageValue(KILLSSTORAGE_BASE + taskId, killAmount + 1)
			end
		end
	end
	return true
end

kills:register()

local teleportBosses = MoveEvent()

local bosses = {
	[3230] = {
		bossName = "the snapper",
		storage = 35000,
		playerPosition = Position(32610, 32723, 8),
		bossPosition = Position(32617, 32732, 8),
		centerPosition = Position(32613, 32727, 8),
		rangeX = 5,
		rangeY = 5,
		flamePosition = Position(32612, 32733, 8)
	},

	[3231] = {
		bossName = "hide",
		storage = 35001,
		playerPosition = Position(32815, 32703, 8),
		bossPosition = Position(32816, 32712, 8),
		centerPosition = Position(32816, 32707, 8),
		rangeX = 6,
		rangeY = 5,
		flamePosition = Position(32810, 32704, 8)
	},

	[3232] = {
		bossName = "deathbine",
		storage = 35002,
		playerPosition = Position(32715, 32736, 8),
		bossPosition = Position(32714, 32713, 8),
		centerPosition = Position(32716, 32724, 8),
		rangeX = 9,
		rangeY = 13,
		flamePosition = Position(32726, 32727, 8)
	},

	[3233] = {
		bossName = "the bloodtusk",
		storage = 35003,
		playerPosition = Position(32102, 31124, 2),
		bossPosition = Position(32102, 31134, 2),
		centerPosition = Position(32101, 31129, 2),
		rangeX = 5,
		rangeY = 6,
		flamePosition = Position(32093, 31130, 2)
	},

	[3234] = {
		bossName = "shardhead",
		storage = 35004,
		playerPosition = Position(32150, 31137, 3),
		bossPosition = Position(32159, 31132, 3),
		centerPosition = Position(32155, 31136, 3),
		rangeX = 5,
		rangeY = 7,
		flamePosition = Position(32149, 31137, 3)
	},

	[3235] = {
		bossName = "esmeralda",
		storage = 35005,
		playerPosition = Position(32759, 31252, 9),
		bossPosition = Position(32759, 31258, 9),
		centerPosition = Position(32759, 31254, 9),
		rangeX = 4,
		rangeY = 4,
		flamePosition = Position(32758, 31248, 9)
	},

	[3236] = {
		bossName = "fleshcrawler",
		storage = 35006,
		playerPosition = Position(33100, 32785, 11),
		bossPosition = Position(33121, 32797, 11),
		centerPosition = Position(33112, 32789, 11),
		rangeX = 15,
		rangeY = 13,
		flamePosition = Position(33106, 32775, 11)
	},

	[3237] = {
		bossName = "ribstride",
		storage = 35007,
		playerPosition = Position(33012, 32813, 13),
		bossPosition = Position(33013, 32801, 13),
		centerPosition = Position(33012, 32805, 13),
		rangeX = 10,
		rangeY = 9,
		flamePosition = Position(33018, 32814, 13)
	},

	[3238] = {
		bossName = "bloodweb",
		storage = 35008,
		playerPosition = Position(32019, 31037, 8),
		bossPosition = Position(32032, 31033, 8),
		centerPosition = Position(32023, 31033, 8),
		rangeX = 11,
		rangeY = 11,
		flamePosition = Position(32010, 31031, 8)
	},

	[3239] = {
		bossName = "thul",
		storage = 35009,
		playerPosition = Position(32078, 32780, 13),
		bossPosition = Position(32088, 32780, 13),
		centerPosition = Position(32083, 32781, 13),
		rangeX = 6,
		rangeY = 6,
		flamePosition = Position(32086, 32776, 13)
	},

	[3240] = {
		bossName = "the old widow",
		storage = 35010,
		playerPosition = Position(32805, 32280, 8),
		bossPosition = Position(32797, 32281, 8),
		centerPosition = Position(32801, 32276, 8),
		rangeX = 5,
		rangeY = 5,
		flamePosition = Position(32808, 32283, 8)
	},

	[3241] = {
		bossName = "hemming",
		storage = 35011,
		playerPosition = Position(32999, 31452, 8),
		bossPosition = Position(33013, 31441, 8),
		centerPosition = Position(33006, 31445, 8),
		rangeX = 9,
		rangeY = 7,
		flamePosition = Position(33005, 31437, 8)
	},

	[3242] = {
		bossName = "tormentor",
		storage = 35012,
		playerPosition = Position(32043, 31258, 11),
		bossPosition = Position(32058, 31267, 11),
		centerPosition = Position(32051, 31264, 11),
		rangeX = 11,
		rangeY = 14,
		flamePosition = Position(32051, 31249, 11)
	},

	[3243] = {
		bossName = "flameborn",
		storage = 35013,
		playerPosition = Position(32940, 31064, 8),
		bossPosition = Position(32947, 31058, 8),
		centerPosition = Position(32944, 31060, 8),
		rangeX = 11,
		rangeY = 10,
		flamePosition = Position(32818, 31026, 7)
	},

	[3244] = {
		bossName = "fazzrah",
		storage = 35014,
		playerPosition = Position(32990, 31171, 7),
		bossPosition = Position(33005, 31174, 7),
		centerPosition = Position(33003, 31177, 7),
		rangeX = 14,
		rangeY = 6,
		flamePosition = Position(33007, 31171, 7)
	},

	[3245] = {
		bossName = "tromphonyte",
		storage = 35015,
		playerPosition = Position(33111, 31184, 8),
		bossPosition = Position(33120, 31195, 8),
		centerPosition = Position(33113, 31188, 8),
		rangeX = 11,
		rangeY = 18,
		flamePosition = Position(33109, 31168, 8)
	},

	[3246] = {
		bossName = "sulphur scuttler",
		storage = 35016,
		playerPosition = Position(33269, 31046, 9),
		bossPosition = Position(33274, 31037, 9),
		centerPosition = Position(33088, 31012, 8),
		rangeX = 11,
		rangeY = 11,
		flamePosition = Position(0, 0, 0)
	},

	[3247] = {
		bossName = "bruise payne",
		storage = 35017,
		playerPosition = Position(33237, 31006, 2),
		bossPosition = Position(33266, 31016, 2),
		centerPosition = Position(33251, 31016, 2),
		rangeX = 22,
		rangeY = 11,
		flamePosition = Position(33260, 31003, 2)
	},

	[3248] = {
		bossName = "the many",
		storage = 35018,
		playerPosition = Position(32921, 32893, 8),
		bossPosition = Position(32926, 32903, 8),
		centerPosition = Position(32921, 32898, 8),
		rangeX = 5,
		rangeY = 6,
		flamePosition = Position(32921, 32890, 8)
	},

	[3249] = {
		bossName = "the noxious spawn",
		storage = 35019,
		playerPosition = Position(32842, 32667, 11),
		bossPosition = Position(32843, 32675, 11),
		centerPosition = Position(32843, 32670, 11),
		rangeX = 5,
		rangeY = 5,
		flamePosition = Position(0, 0, 0)
	},

	[3250] = {
		bossName = "gorgo",
		storage = 35020,
		playerPosition = Position(32759, 32447, 11),
		bossPosition = Position(32763, 32435, 11),
		centerPosition = Position(32759, 32440, 11),
		rangeX = 9,
		rangeY = 10,
		flamePosition = Position(32768, 32440, 11)
	},

	[3251] = {
		bossName = "stonecracker",
		storage = 35021,
		playerPosition = Position(33259, 31694, 15),
		bossPosition = Position(33257, 31705, 15),
		centerPosition = Position(33259, 31670, 15),
		rangeX = 5,
		rangeY = 7,
		flamePosition = Position(33259, 31689, 15)
	},

	[3252] = {
		bossName = "leviathan",
		storage = 35022,
		playerPosition = Position(31915, 31071, 10),
		bossPosition = Position(31903, 31072, 10),
		centerPosition = Position(31909, 31072, 10),
		rangeX = 8,
		rangeY = 7,
		flamePosition = Position(31918, 31071, 10)
	},

	[3253] = {
		bossName = "kerberos",
		storage = 35023,
		playerPosition = Position(32048, 32581, 15),
		bossPosition = Position(32032, 32565, 15),
		centerPosition = Position(32041, 32569, 15),
		rangeX = 11,
		rangeY = 13,
		flamePosition = Position(32030, 32555, 15)
	},

	[3254] = {
		bossName = "ethershreck",
		storage = 35024,
		playerPosition = Position(33089, 31021, 8),
		bossPosition = Position(33085, 31004, 8),
		centerPosition = Position(33088, 31012, 8),
		rangeX = 11,
		rangeY = 11,
		flamePosition = Position(33076, 31007, 8)
	},

	[3255] = {
		bossName = "paiz the pauperizer",
		storage = 35025,
		playerPosition = Position(33069, 31110, 1),
		bossPosition = Position(33082, 31105, 1),
		centerPosition = Position(33076, 31110, 1),
		rangeX = 8,
		rangeY = 6,
		flamePosition = Position(33076, 31110, 1)
	},

	[3256] = {
		bossName = "bretzecutioner",
		storage = 35026,
		playerPosition = Position(31973, 31184, 10),
		bossPosition = Position(31979, 31176, 10),
		centerPosition = Position(31973, 31177, 10),
		rangeX = 15,
		rangeY = 10,
		flamePosition = Position(31973, 31166, 10)
	},

	[3257] = {
		bossName = "zanakeph",
		storage = 35027,
		playerPosition = Position(33077, 31040, 12),
		bossPosition = Position(33082, 31056, 12),
		centerPosition = Position(33077, 31050, 12),
		rangeX = 13,
		rangeY = 10,
		flamePosition = Position(33070, 31039, 12)
	},

	[3258] = {
		bossName = "demodras",
		storage = PlayerStorageKeys.KillingInTheNameOf.DemodrasTeleport,
		playerPosition = Position(32748, 32287, 10),
		bossPosition = Position(32747, 32294, 10),
		centerPosition = Position(32887, 32583, 4),
		rangeX = 6,
		rangeY = 5,
		flamePosition = Position(33076, 31029, 12)
	},

	[3259] = {
		bossName = "tiquandas revenge",
		storage = PlayerStorageKeys.KillingInTheNameOf.TiquandasRevengeTeleport,
		playerPosition = Position(32888, 32580, 4),
		bossPosition = Position(32888, 32586, 4),
		centerPosition = Position(32748, 32293, 10),
		rangeX = 8,
		rangeY = 7,
		flamePosition = Position(33076, 31029, 11)
	},

	[17521] = {
		bossName = "necropharus",
		storage = 17521,
		playerPosition = Position(33028, 32426, 12),
		bossPosition = Position(33026, 32422, 12),
		centerPosition = Position(33028, 32424, 12),
		rangeX = 6,
		rangeY = 5,
		flamePosition = Position(33070, 31035, 12)
	},

	[17522] = {
		bossName = "the horned fox",
		storage = 17522,
		playerPosition = Position(32458, 31994, 9),
		bossPosition = Position(32458, 32005, 9),
		centerPosition = Position(32450, 31400, 9),
		rangeX = 5,
		rangeY = 8,
		flamePosition = Position(33070, 31029, 12)
	}
}

local function roomIsOccupied(centerPosition, rangeX, rangeY)
	local spectators = Game.getSpectators(centerPosition, false, true, rangeX, rangeX, rangeY, rangeY)
	if #spectators ~= 0 then
		return true
	end

	return false
end

function clearBossRoom(playerId, bossId, centerPosition, rangeX, rangeY, exitPosition)
	local spectators, spectator = Game.getSpectators(centerPosition, false, false, rangeX, rangeX, rangeY, rangeY)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isPlayer() and spectator.uid == playerId then
			spectator:teleportTo(exitPosition)
			exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end

		if spectator:isMonster() and spectator.uid == bossId then
			spectator:remove()
		end
	end
end

function teleportBosses.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local boss = bosses[item.uid]
	if not boss then
		return true
	end

	if player:getStorageValue(boss.storage) ~= 1 or roomIsOccupied(boss.centerPosition, boss.rangeX, boss.rangeY) then
		player:teleportTo(fromPosition)
		return true
	end

	player:setStorageValue(boss.storage, 0)
	player:teleportTo(boss.playerPosition)
	boss.playerPosition:sendMagicEffect(CONST_ME_TELEPORT)

	local monster = Game.createMonster(boss.bossName, boss.bossPosition)
	if not monster then
		return true
	end

	addEvent(clearBossRoom, 60 * 10 * 1000, player.uid, monster.uid, boss.centerPosition, boss.rangeX, boss.rangeY, fromPosition)
	player:say('You have ten minutes to kill and loot this boss. Otherwise you will lose that chance and will be kicked out.', TALKTYPE_MONSTER_SAY)
	return true
end

teleportBosses:type("stepin")

for index, value in pairs(bosses) do
	teleportBosses:uid(index)
end

teleportBosses:register()
