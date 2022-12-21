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
