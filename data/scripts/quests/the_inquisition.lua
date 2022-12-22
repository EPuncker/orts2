local inquisitionQuestBosses = CreatureEvent("InquisitionBosses")

local bosses = {
	['ushuriel'] = 200,
	['zugurosh'] = 201,
	['madareth'] = 202,
	['latrivan'] = 203,
	['golgordan'] = 203,
	['annihilon'] = 204,
	['hellgorak'] = 205
}

function inquisitionQuestBosses.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	local targetName = targetMonster:getName():lower()
	local bossStorage = bosses[targetName]
	if not bossStorage then
		return true
	end

	local newValue = 2
	if targetName == 'latrivan' or targetName == 'golgordan' then
		if Game.getStorageValue(bossStorage) == nil then
			Game.setStorageValue(bossStorage, 0)
		end

		newValue = math.max(0, Game.getStorageValue(bossStorage)) + 1
	end

	Game.setStorageValue(bossStorage, newValue)

	if newValue == 2 then
		player:say('You now have 3 minutes to exit this room through the teleporter. It will bring you to the next room.', TALKTYPE_MONSTER_SAY)
		addEvent(Game.setStorageValue, 3 * 60 * 1000, bossStorage, 0)
	end
	return true
end

inquisitionQuestBosses:register()

local inquisitionQuestUngreez = CreatureEvent("InquisitionUngreez")

function inquisitionQuestUngreez.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'ungreez' then
		return true
	end

	local player = creature:getPlayer()
	if player:getStorageValue(PlayerStorageKeys.TheInquisition.Questline) == 18 then -- The Inquisition Questlog- 'Mission 6: The Demon Ungreez'
		player:setStorageValue(PlayerStorageKeys.TheInquisition.Mission06, 2)
		player:setStorageValue(PlayerStorageKeys.TheInquisition.Questline, 19)
	end
	return true
end

inquisitionQuestUngreez:register()

local rewardChest = Action()

local rewards = {
	[1300] = 8890,
	[1301] = 8918,
	[1302] = 8881,
	[1303] = 8888,
	[1304] = 8851,
	[1305] = 8924,
	[1306] = 8928,
	[1307] = 8930,
	[1308] = 8854
}

function rewardChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.TheInquisition.Reward) < 1 then
		player:setStorageValue(PlayerStorageKeys.TheInquisition.Reward, 1)
		player:setStorageValue(PlayerStorageKeys.TheInquisition.Questline, 25)
		player:setStorageValue(PlayerStorageKeys.TheInquisition.Mission07, 5) -- The Inquisition Questlog- "Mission 7: The Shadow Nexus"
		player:addItem(rewards[item.uid], 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found " .. ItemType(rewards[item.uid]):getName() .. ".")
		player:addAchievement('Master of the Nexus')
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The chest is empty.")
	end
	return true
end

rewardChest:uid(1300, 1301, 1302, 1303, 1304, 1305, 1306, 1307, 1308)
rewardChest:register()

local ungreez = Action()

function ungreez.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 5114 then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.TheInquisition.Questline) == 18 then
		player:teleportTo(toPosition, true)
		item:transform(5115)
	end
	return true
end

ungreez:aid(1004)
ungreez:register()

local vampireHunt = Action()

local altars = {
	Position(32777, 31982, 9),
	Position(32779, 31977, 9),
	Position(32781, 31982, 9)
}

function vampireHunt.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.TheInquisition.Questline) == 8 then
		player:setStorageValue(PlayerStorageKeys.TheInquisition.Questline, 9)
		player:setStorageValue(PlayerStorageKeys.TheInquisition.Mission03, 4) -- The Inquisition Questlog- "Mission 3: Vampire Hunt"
		local k = {}
		for i = 1, #altars do
			local tmp = Tile(altars[i]):getItemById(2199)
			if not tmp then
				Game.createMonster("The Count", toPosition)
				return true
			else
				k[#k + 1] = tmp
			end
		end

		for i = 1, #k do
			k[i]:remove()
		end

		Game.createMonster("The Weakened Count", toPosition)
	end
	return true
end

vampireHunt:aid(2002)
vampireHunt:register()

local brotherLever = Action()

local config = {
	[9017] = {
		wallPositions = {
			Position(33226, 31721, 11),
			Position(33227, 31721, 11),
			Position(33228, 31721, 11),
			Position(33229, 31721, 11),
			Position(33230, 31721, 11),
			Position(33231, 31721, 11),
			Position(33232, 31721, 11),
			Position(33233, 31721, 11),
			Position(33234, 31721, 11),
			Position(33235, 31721, 11),
			Position(33236, 31721, 11),
			Position(33237, 31721, 11),
			Position(33238, 31721, 11)
		},
		wallDown = 1524,
		wallUp = 1050
	},
	[9018] = {
		wallPositions = {
			Position(33223, 31724, 11),
			Position(33223, 31725, 11),
			Position(33223, 31726, 11),
			Position(33223, 31727, 11),
			Position(33223, 31728, 11),
			Position(33223, 31729, 11),
			Position(33223, 31730, 11),
			Position(33223, 31731, 11),
			Position(33223, 31732, 11)
		},
		wallDown = 1526,
		wallUp = 1049
	},
	[9019] = {
		wallPositions = {
			Position(33226, 31735, 11),
			Position(33227, 31735, 11),
			Position(33228, 31735, 11),
			Position(33229, 31735, 11),
			Position(33230, 31735, 11),
			Position(33231, 31735, 11),
			Position(33232, 31735, 11),
			Position(33233, 31735, 11),
			Position(33234, 31735, 11),
			Position(33235, 31735, 11),
			Position(33236, 31735, 11),
			Position(33237, 31735, 11),
			Position(33238, 31735, 11)
		},
		wallDown = 1524,
		wallUp = 1050
	},
	[9020] = {
		wallPositions = {
			Position(33241, 31724, 11),
			Position(33241, 31725, 11),
			Position(33241, 31726, 11),
			Position(33241, 31727, 11),
			Position(33241, 31728, 11),
			Position(33241, 31729, 11),
			Position(33241, 31730, 11),
			Position(33241, 31731, 11),
			Position(33241, 31732, 11)
		},
		wallDown = 1526,
		wallUp = 1049
	}
}

function brotherLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetLever = config[item.uid]
	if not targetLever then
		return true
	end

	local tile, thing
	for i = 1, #targetLever.wallPositions do
		tile = Tile(targetLever.wallPositions[i])
		if tile then
			thing = tile:getItemById(item.itemid == 1945 and targetLever.wallDown or targetLever.wallUp)
			if thing then
				thing:transform(item.itemid == 1945 and targetLever.wallUp or targetLever.wallDown)
			end
		end
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

brotherLever:uid(9017, 9018, 9019, 9020)
brotherLever:register()

local rewardDoor = Action()

function rewardDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.uid == 9021 then
		if player:getStorageValue(PlayerStorageKeys.TheInquisition.Questline) == 23 then
			return player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You forgot to ask henricus for outfit.")
		end

		if player:getStorageValue(PlayerStorageKeys.TheInquisition.Questline) >= 24 then
			if item.itemid == 5105 then
				player:teleportTo(toPosition, true)
				item:transform(item.itemid + 1)
			end
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
		end
	end
	return true
end

rewardDoor:uid(9021)
rewardDoor:register()

local entrace = MoveEvent()

local throneStorages = {
	PlayerStorageKeys.PitsOfInferno.ThroneInfernatil,
	PlayerStorageKeys.PitsOfInferno.ThroneTafariel,
	PlayerStorageKeys.PitsOfInferno.ThroneVerminor,
	PlayerStorageKeys.PitsOfInferno.ThroneApocalypse,
	PlayerStorageKeys.PitsOfInferno.ThroneBazir,
	PlayerStorageKeys.PitsOfInferno.ThroneAshfalor,
	PlayerStorageKeys.PitsOfInferno.ThronePumin
}

local function hasTouchedOneThrone(player)
	for i = 1, #throneStorages do
		if player:getStorageValue(throneStorages[i]) == 1 then
			return true
		end
	end
	return false
end

function entrace.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if not hasTouchedOneThrone(player) or player:getLevel() < 100 or player:getStorageValue(PlayerStorageKeys.TheInquisition.Questline) < 20 then
		player:teleportTo(fromPosition)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local destination = Position(33168, 31683, 15)
	player:teleportTo(destination)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

entrace:type("stepin")
entrace:uid(9014)
entrace:register()

local destroyPies = MoveEvent()

function rewardRoomText.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player or player:getStorageValue(PlayerStorageKeys.TheInquisition.RewardRoomText) == 1 then
		return true
	end

	player:setStorageValue(PlayerStorageKeys.TheInquisition.RewardRoomText, 1)
	player:say('You can choose exactly one of these chets. Choose wisely!', TALKTYPE_MONSTER_SAY, false, player)
	return true
end

rewardRoomText:type("stepin")
rewardRoomText:aid(4003)
rewardRoomText:register()

local teleportMain = MoveEvent()

local teleports = {
	[2150] = {text = 'Entering Ushuriel\'s ward.', newPos = Position(33158, 31728, 11), storage = 0, alwaysSetStorage = true}, -- to ushuriel ward
	[2151] = {text = 'Entering the Crystal Caves.', bossStorage = 200, newPos = Position(33069, 31782, 13), storage = 1}, -- from ushuriel ward
	[2152] = {text = 'Escaping back to the Retreat.', newPos = Position(33165, 31709, 14)}, -- from crystal caves
	[2153] = {text = 'Entering the Crystal Caves.', newPos = Position(33069, 31782, 13), storage = 1}, -- to crystal caves
	[2154] = {text = 'Entering the Sunken Caves.', newPos = Position(33169, 31755, 13)}, -- to sunken caves
	[2155] = {text = 'Entering the Mirror Maze of Madness.', newPos = Position(33065, 31772, 10)}, -- from sunken caves
	[2156] = {text = 'Entering Zugurosh\'s ward.', newPos = Position(33124, 31692, 11)}, -- to zugurosh ward
	[2157] = {text = 'Entering the Blood Halls.', bossStorage = 201, newPos = Position(33372, 31613, 14), storage = 2}, -- from zugurosh ward
	[2158] = {text = 'Escaping back to the Retreat.', newPos = Position(33165, 31709, 14)}, -- from blood halls
	[2159] = {text = 'Entering the Blood Halls.', newPos = Position(33372, 31613, 14), storage = 2}, -- to blood halls
	[2160] = {text = 'Entering the Foundry.', newPos = Position(33356, 31589, 11)}, -- to foundry
	[2161] = {text = 'Entering Madareth\'s ward.', newPos = Position(33197, 31767, 11)}, -- to madareth ward
	[2162] = {text = 'Entering the Vats.', bossStorage = 202, newPos = Position(33153, 31782, 12), storage = 3}, -- from madareth ward
	[2163] = {text = 'Escaping back to the Retreat.', newPos = Position(33165, 31709, 14)}, -- from vats
	[2164] = {text = 'Entering the Vats.', newPos = Position(33153, 31782, 12), storage = 3}, -- to vats
	[2165] = {text = 'Entering the Battlefield.', newPos = Position(33250, 31632, 13)}, -- to battlefield
	[2166] = {text = 'Entering the Vats.', newPos = Position(33233, 31758, 12)}, -- from battlefield
	[2167] = {text = 'Entering the Demon Forge.', newPos = Position(33232, 31733, 11)}, -- to brothers ward
	[2168] = {text = 'Entering the Arcanum.', bossStorage = 203, newPos = Position(33038, 31753, 15), storage = 4}, -- from demon forge
	[2169] = {text = 'Escaping back to the Retreat.', newPos = Position(33165, 31709, 14)}, -- from arcanum
	[2170] = {text = 'Entering the Arcanum.', newPos = Position(33038, 31753, 15), storage = 4}, -- to arcanum
	[2171] = {text = 'Entering the Soul Wells.', newPos = Position(33093, 31575, 11)}, -- to soul wells
	[2172] = {text = 'Entering the Arcanum.', newPos = Position(33186, 31759, 15)}, -- from soul wells
	[2173] = {text = 'Entering the Annihilon\'s ward.', newPos = Position(33197, 31703, 11)}, -- to annihilon ward
	[2174] = {text = 'Entering the Hive.', bossStorage = 204, newPos = Position(33199, 31686, 12), storage = 5}, -- from annihilon ward
	[2175] = {text = 'Escaping back to the Retreat.', newPos = Position(33165, 31709, 14)}, -- from hive
	[2176] = {text = 'Entering the Hive.', newPos = Position(33199, 31686, 12), storage = 5}, -- to hive
	[2177] = {text = 'Entering the Hellgorak\'s ward.', newPos = Position(33104, 31734, 11)}, -- to hellgorak ward
	[2178] = {text = 'Entering the Shadow Nexus. Abandon all Hope.', bossStorage = 205, newPos = Position(33110, 31682, 12), storage = 6}, -- from hellgorak ward
	[2179] = {text = 'Escaping back to the Retreat.', newPos = Position(33165, 31709, 14)}, -- from shadow nexus
	[2180] = {text = 'Entering the Blood Halls.', newPos = Position(33357, 31589, 12)} -- from foundry to blood halls
}

function teleportMain.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = teleports[item.uid]
	if teleport.alwaysSetStorage and player:getStorageValue(PlayerStorageKeys.TheInquisition.EnterTeleport) < teleport.storage then
		player:setStorageValue(PlayerStorageKeys.TheInquisition.EnterTeleport, teleport.storage)
	end

	if teleport.bossStorage then
		if Game.getStorageValue(teleport.bossStorage) == 2 then
			if player:getStorageValue(PlayerStorageKeys.TheInquisition.EnterTeleport) < teleport.storage then
				player:setStorageValue(PlayerStorageKeys.TheInquisition.EnterTeleport, teleport.storage)
			end
		else
			player:teleportTo(Position(33165, 31709, 14))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:say('Escaping back to the Retreat.', TALKTYPE_MONSTER_SAY)
			return true
		end
	elseif teleport.storage and player:getStorageValue(PlayerStorageKeys.TheInquisition.EnterTeleport) < teleport.storage then
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:say('You don\'t have enough energy to enter this portal', TALKTYPE_MONSTER_SAY)
		return true
	end

	player:teleportTo(teleport.newPos)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:say(teleport.text, TALKTYPE_MONSTER_SAY)
	return true
end

teleportMain:type("stepin")

for index, value in pairs(teleports) do
	teleportMain:uid(index)
end

teleportMain:register()
