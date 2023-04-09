local azerusKill = CreatureEvent("ServiceOfYalaharAzerus")

local teleportToPosition = Position(32780, 31168, 14)

local function removeTeleport(position)
	local teleportItem = Tile(position):getItemById(1387)
	if teleportItem then
		teleportItem:remove()
		position:sendMagicEffect(CONST_ME_POFF)
	end
end

function azerusKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster or targetMonster:getName():lower() ~= 'azerus' then
		return true
	end

	local position = targetMonster:getPosition()
	position:sendMagicEffect(CONST_ME_TELEPORT)
	local item = Game.createItem(1387, 1, position)
	if item:isTeleport() then
		item:setDestination(teleportToPosition)
	end
	targetMonster:say('Azerus ran into teleporter! It will disappear in 2 minutes. Enter it!', TALKTYPE_MONSTER_SAY, 0, 0, position)

	--remove portal after 2 min
	addEvent(removeTeleport, 2 * 60 * 1000, position)

	--clean arena of monsters
	local spectators, spectator = Game.getSpectators(Position(32783, 31166, 10), false, false, 10, 10, 10, 10)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() then
			spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
			spectator:remove()
		end
	end
	return true
end

azerusKill:register()

local diseasedTrioKill = CreatureEvent("ServiceOfYalaharDiseasedTrio")

local diseasedTrio = {
	['diseased bill'] = PlayerStorageKeys.InServiceofYalahar.DiseasedBill,
	['diseased dan'] = PlayerStorageKeys.InServiceofYalahar.DiseasedDan,
	['diseased fred'] = PlayerStorageKeys.InServiceofYalahar.DiseasedFred
}

function diseasedTrioKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	local bossStorage = diseasedTrio[targetMonster:getName():lower()]
	if not bossStorage then
		return true
	end

	local player = creature:getPlayer()
	if player:getStorageValue(bossStorage) < 1 then
		player:setStorageValue(bossStorage, 1)
		player:say('You slayed ' .. targetMonster:getName() .. '.', TALKTYPE_MONSTER_SAY)
	end

	if (player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.DiseasedDan) == 1
		and player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.DiseasedBill) == 1
		and player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.DiseasedFred) == 1
		and player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.AlchemistFormula) ~= 1) then
		player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.AlchemistFormula, 0)
	end
	return true
end

diseasedTrioKill:register()

local quaraLeadersKill = CreatureEvent("ServiceOfYalaharQuaraLeaders")

local quaraLeaders = {
	['inky'] = PlayerStorageKeys.InServiceofYalahar.QuaraInky,
	['sharptooth'] = PlayerStorageKeys.InServiceofYalahar.QuaraSharptooth,
	['splasher'] = PlayerStorageKeys.InServiceofYalahar.QuaraSplasher
}

function quaraLeadersKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	local bossStorage = quaraLeaders[targetMonster:getName():lower()]
	if not bossStorage then
		return true
	end

	local player = creature:getPlayer()
	if player:getStorageValue(bossStorage) < 1 then
		player:setStorageValue(bossStorage, 1)
		player:say('You slayed ' .. targetMonster:getName() .. '.', TALKTYPE_MONSTER_SAY)
		player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.QuaraState, 2)
		player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline, 41) -- StorageValue for Questlog 'Mission 07: A Fishy Mission'
		player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Mission07, 4)
	end
	return true
end

quaraLeadersKill:register()

local charm = Action()

function charm.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid == 100 and target.itemid == 471 then
		if player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline) == 36 then
			player:removeItem(9737, 1)
			Game.createItem(9738, 1, toPosition)
			toPosition:sendMagicEffect(CONST_ME_CARNIPHILA)
			local monster
			for i = 1, 2 do
				monster = Game.createMonster('Tormented Ghost', player:getPosition())
				if monster then
					monster:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				end
			end
		end
	end
	return true
end

charm:id(9737)
charm:register()

local formula = Action()

function formula.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({1786, 1787, 1788, 1789, 1790, 1791, 1792, 1793, 9911}, target.itemid) then
		return false
	end

	item:remove(1)
	toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:say("You burned the alchemist formula.", TALKTYPE_MONSTER_SAY)
	return true
end

formula:id(9733)
formula:register()

local ghost = Action()

local config = {
	[9738] = 9739,
	[9739] = 9740,
	[9740] = 9773,
	[9773] = 9742
}

function ghost.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local transformId = config[target.itemid]
	if not transformId then
		return true
	end

	for i = 1, 2 do
		Game.createMonster('Tormented Ghost', fromPosition)
	end

	local charmItem = Tile(Position(32776, 31062, 7)):getItemById(target.itemid)
	if charmItem then
		charmItem:transform(transformId)
	end

	toPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
	item:remove()
	player:say('The ghost charm is charging.', TALKTYPE_MONSTER_SAY)

	if target.itemid == 9773 then
		player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline, 37)
		player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Mission06, 3) -- StorageValue for Questlog "Mission 06: Frightening Fuel"
		player:removeItem(9737, 1)
	end
	return true
end

ghost:id(9741)
ghost:register()

local lastFight = Action()

local waves = {
	Position(32779, 31166, 10),
	Position(32787, 31166, 10),
	Position(32782, 31162, 10),
	Position(32784, 31162, 10),
	Position(32782, 31170, 10),
	Position(32784, 31170, 10)
}

local creatureNames = {
	[1] = 'rift worm',
	[2] = 'rift scythe',
	[3] = 'rift brood',
	[4] = 'war golem'
}

local effectPositions = {
	Position(32779, 31161, 10),
	Position(32787, 31171, 10)
}

local function doClearAreaAzerus()
	if Game.getStorageValue(GlobalStorageKeys.InServiceOfYalahar.LastFight) == 1 then
		local spectators, spectator = Game.getSpectators(Position(32783, 31166, 10), false, false, 10, 10, 10, 10)
		for i = 1, #spectators do
			spectator = spectators[i]
			if spectator:isMonster() then
				spectator:getPosition():sendMagicEffect(CONST_ME_POFF)
				spectator:remove()
			end
		end
		Game.setStorageValue(GlobalStorageKeys.InServiceOfYalahar.LastFight, 0)
	end
	return true
end

local function doChangeAzerus()
	local spectators, spectator = Game.getSpectators(Position(32783, 31166, 10), false, false, 10, 10, 10, 10)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:isMonster() and spectator:getName():lower() == "azerus" then
			spectator:say("No! I am losing my energy!", TALKTYPE_MONSTER_SAY)
			Game.createMonster("Azerus", spectator:getPosition())
			spectator:remove()
			return true
		end
	end
	return false
end

local function summonMonster(name, position)
	Game.createMonster(name, position)
	position:sendMagicEffect(CONST_ME_TELEPORT)
end

function lastFight.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Game.getStorageValue(GlobalStorageKeys.InServiceOfYalahar.LastFight) == 1 then
		player:say('You have to wait some time before this globe charges.', TALKTYPE_MONSTER_SAY)
		return true
	end

	local amountOfPlayers = 3
	local spectators = Game.getSpectators(Position(32783, 31166, 10), false, true, 10, 10, 10, 10)
	if #spectators < amountOfPlayers then
		for i = 1, #spectators do
			spectators[i]:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need atleast " .. amountOfPlayers .. " players inside the quest room.")
		end
		return true
	end

	Game.setStorageValue(GlobalStorageKeys.InServiceOfYalahar.LastFight, 1)
	addEvent(Game.createMonster, 18 * 1000, "Immune Azerus", Position(32783, 31167, 10))

	local azeruswavemonster
	for i = 1, #creatureNames do
		azeruswavemonster = creatureNames[i]
		for k = 1, #waves do
			addEvent(summonMonster, (i - 1) * 60 * 1000, azeruswavemonster, waves[k])
		end
	end

	for i = 1, #effectPositions do
		effectPositions[i]:sendMagicEffect(CONST_ME_HOLYAREA)
	end

	addEvent(doChangeAzerus, 4 * 20 * 1000)
	addEvent(doClearAreaAzerus, 5 * 60 * 1000)
	return true
end

lastFight:uid(3086)
lastFight:register()

local matrix = Action()

function matrix.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if table.contains({7915, 7916}, target.itemid) and target.actionid == 100 then
		if table.contains({9743, 9744}, item.itemid) and player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.MatrixState) < 1 then
			player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.MatrixState, 1)
			item:remove(1)
			toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
			player:say("The machine was activated.", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline, 46)
			player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Mission08, 3) -- StorageValue for Questlog "Mission 08: Dangerous Machinations"
		end
	end
	return true
end

matrix:id(9743, 9744)
matrix:register()

local mechanism = Action()

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

function mechanism.onUse(player, item, fromPosition, target, toPosition, isHotkey)
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

mechanism:uid(3091, 3092, 3093, 3094, 3095, 3096, 3097, 3098, 3099, 3100, 9235, 9236)
mechanism:register()

local mrWestDoor = Action()

function mrWestDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if(item.uid == 3081) then
		if(player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline) >= 24) then
			if(item.itemid == 5288) then
				player:teleportTo(toPosition, true)
				item:transform(5289)
				player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.MrWestDoor, 1)
			end
		end
	elseif(item.uid == 3082) then
		if(player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline) >= 24) then
			if(item.itemid == 6261) then
				player:teleportTo(toPosition, true)
				item:transform(6262)
				player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.MrWestDoor, 2)
			end
		end
	end
	return true
end

mrWestDoor:uid(3081, 3082)
mrWestDoor:register()

local reward = Action()

function reward.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if(item.uid == 3088) then
		if(player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline) == 53) then
			player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline, 54)
			player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Mission10, 5) -- StorageValue for Questlog "Mission 10: The Final Battle"
			player:addItem(9776, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a yalahari armor.")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
		end
	elseif(item.uid == 3089) then
		if(player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline) == 53) then
			player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline, 54)
			player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Mission10, 5) -- StorageValue for Questlog "Mission 10: The Final Battle"
			player:addItem(9778, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a yalahari mask.")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
		end
	elseif(item.uid == 3090) then
		if(player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline) == 53) then
			player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline, 54)
			player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Mission10, 5) -- StorageValue for Questlog "Mission 10: The Final Battle"
			player:addItem(9777, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a yalahari leg piece.")
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
		end
	end
	return true
end

reward:uid(3088)
reward:register()

local morikSummon = Action()

function morikSummon.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if(item.uid == 9031) then
		if(player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline) == 31 and player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.MorikSummon) < 1) then
			local ret = Game.createMonster("Morik the Gladiator", fromPosition)
			ret:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.MorikSummon, 1)
		end
	end
	return true
end

morikSummon:uid(9031)
morikSummon:register()

local yalaharMachineWargolems = Action()

local config = {
	[23700] = {
		storage = GlobalStorageKeys.InServiceOfYalahar.WarGolemsMachine1,
		machines = {
			Position(32882, 31323, 10),
			Position(32882, 31320, 10),
			Position(32882, 31318, 10),
			Position(32882, 31316, 10)
		}
	},
	[23701] = {
		storage = GlobalStorageKeys.InServiceOfYalahar.WarGolemsMachine2,
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


function yalaharMachineWargolems.onUse(player, item, fromPosition, target, toPosition, isHotkey)
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

yalaharMachineWargolems:aid(23700, 23701)
yalaharMachineWargolems:register()

local lastFightTeleports = MoveEvent()

function lastFightTeleports.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.uid == 7809 then
		if player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline) == 51 then
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(Position(32783, 31174, 10))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:say('The apparatus in the centre looks odd! You should inspect it.', TALKTYPE_MONSTER_SAY)
		else
			player:teleportTo(fromPosition)
		end
	elseif item.uid == 7810 then
		if Game.getStorageValue(GlobalStorageKeys.InServiceOfYalahar.LastFight) ~= 1 then
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(Position(32784, 31178, 9))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:teleportTo(fromPosition)
		end
	end
	return true
end

lastFightTeleports:type("stepin")
lastFightTeleports:uid(7809, 7810)
lastFightTeleports:register()

local morik = MoveEvent()

function morik.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline) == 51 then -- StorageValue for Questlog 'Mission 10: The Final Battle'
		player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Mission10, 3)
		player:setStorageValue(PlayerStorageKeys.InServiceofYalahar.Questline, 52)
		player:say('It seems by defeating Azerus you have stopped this army from entering your world! Better leave this ghastly place forever.', TALKTYPE_MONSTER_SAY)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
	return true
end

morik:type("stepin")
morik:uid(3087)
morik:register()

local yalaharMachineWargolems = MoveEvent()

local config = {
	[23698] = {storage = GlobalStorageKeys.InServiceOfYalahar.WarGolemsMachine2, destination = Position(32869, 31312, 11)},
	[23699] = {storage = GlobalStorageKeys.InServiceOfYalahar.WarGolemsMachine1, destination = Position(32881, 31312, 11)},
	[23702] = {destination = Position(32876, 31321, 10)},
	[23703] = {destination = Position(32875, 31321, 10)}
}

function yalaharMachineWargolems.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local machine = config[item.actionid]
	if not machine then
		return true
	end

	if machine.storage and Game.getStorageValue(machine.storage) ~= 1 then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, 'The machines are not activated.')
		player:teleportTo(fromPosition)
		fromPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	player:teleportTo(machine.destination)
	position:sendMagicEffect(CONST_ME_ENERGYHIT)
	machine.destination:sendMagicEffect(CONST_ME_ENERGYHIT)
	return true
end

yalaharMachineWargolems:type("stepin")
yalaharMachineWargolems:aid(23698, 23699, 23702, 23703)
yalaharMachineWargolems:register()
