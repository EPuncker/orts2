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

local warzoneRewards = Action()

local config = {
	[9172] = {items = {{18402}, {18414, 12}, {18396}, {18500}, {2160, 5}, {18423, 2}}, storage = PlayerStorageKeys.QuestChests.WarzoneReward1, containerId = 18394},
	[9173] = {items = {{18402}, {18415, 7}, {18396}, {18504}, {2160, 3}, {18423, 2}}, storage = PlayerStorageKeys.QuestChests.WarzoneReward2, containerId = 18393},
	[9174] = {items = {{18402}, {18413, 10}, {18396}, {18508}, {2160, 4}, {18423, 2}}, storage = PlayerStorageKeys.QuestChests.WarzoneReward3, containerId = 18394}
}

function warzoneRewards.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.uid]
	if not useItem then
		return true
	end

	local player, cStorage = player, useItem.storage
	if player:getStorageValue(cStorage) > os.time() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'It is empty.')
		return true
	end

	local container = player:addItem(useItem.containerId)
	if not container then
		return true
	end

	for i = 1, #useItem.items do
		container:addItem(useItem.items[i][1], useItem.items[i][2] or 1)
	end

	player:setStorageValue(cStorage, os.time() + 20 * 60 * 60)
	local itemType = ItemType(container.itemid)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found ' .. itemType:getArticle() .. ' ' .. itemType:getName() .. '.')
	return true
end

warzoneRewards:aid(9172, 9173, 9174)
warzoneRewards:register()

local music = Action()

local cToneStorages = {
	PlayerStorageKeys.BigfootBurden.MelodyTone1,
	PlayerStorageKeys.BigfootBurden.MelodyTone2,
	PlayerStorageKeys.BigfootBurden.MelodyTone3,
	PlayerStorageKeys.BigfootBurden.MelodyTone4,
	PlayerStorageKeys.BigfootBurden.MelodyTone5,
	PlayerStorageKeys.BigfootBurden.MelodyTone6,
	PlayerStorageKeys.BigfootBurden.MelodyTone7
}

function music.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine) == 12 then
		local value = player:getStorageValue(PlayerStorageKeys.BigfootBurden.MelodyStatus)
		if player:getStorageValue(cToneStorages[value]) == item.uid then
			player:setStorageValue(PlayerStorageKeys.BigfootBurden.MelodyStatus, value + 1)
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			if value + 1 == 8 then
				player:setStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine, 13)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found your melody!")
			end
		else
			player:setStorageValue(PlayerStorageKeys.BigfootBurden.MelodyStatus, 1)
			toPosition:sendMagicEffect(CONST_ME_SOUND_RED)
		end
	end
	return true
end

music:uid(3124, 3125, 3126, 3127)
music:register()

local warzones = Action()

local creatureNames, crystalPosition = { 'humongous fungus', 'hideous fungus' }, Position(33104, 31908, 10)

local function summonMonster(name, position)
	Game.createMonster(name, position)
	position:sendMagicEffect(CONST_ME_TELEPORT)
end

local function chargingText(cid, text, position)
	local player = Player(cid)
	player:say(text, TALKTYPE_MONSTER_SAY, false, player, position)
end

local function revertTeleport(position)
	local teleportItem = Tile(position):getItemById(1387)
	if teleportItem then
		teleportItem:transform(17999)
	end
end

local function clearArea(fromPosition, toPosition, bossName, exitPosition)
	for x = fromPosition.x, toPosition.x do
		for y = fromPosition.y, toPosition.y do
			for z = fromPosition.z, toPosition.z do
				local creature = Tile(Position(x, y, z)):getTopCreature()
				if creature then
					if creature:isPlayer() then
						creature:teleportTo(exitPosition)
						exitPosition:sendMagicEffect(CONST_ME_TELEPORT)
						creature:say('You were teleported out by the gnomish emergency device.', TALKTYPE_MONSTER_SAY)
					end

					if creature:isMonster() and creature:getName():lower() == bossName:lower() then
						creature:remove()
					end
				end
			end
		end
	end
end

function warzones.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Game.getStorageValue(GlobalStorageKeys.Warzones) == 1 then
		return false
	end

	Game.setStorageValue(GlobalStorageKeys.Warzones, 1)
	addEvent(Game.setStorageValue, 32 * 60 * 1000, GlobalStorageKeys.Warzones, 0)

	local pos
	for i = 1, 6 do
		for k = 1, 10 do
			pos = Position(math.random(33091, 33101), math.random(31899, 31916), 10)
			addEvent(summonMonster, (i - 1) * 20000, creatureNames[math.random(#creatureNames)], pos)
		end

		addEvent(chargingText, (i - 1) * 20000, player.uid, 'The crystals are charging.', toPosition)
	end

	local crystalItem = Tile(crystalPosition):getItemById(17999)
	if crystalItem then
		crystalItem:transform(1387)
		addEvent(revertTeleport, 6 * 20 * 1000, crystalPosition)
	end

	addEvent(summonMonster, 6 * 20 * 1000, 'deathstrike', Position(33100, 31955, 10))
	addEvent(clearArea, 32 * 60 * 1000, Position(33089, 31946, 10), Position(33124, 31983, 10), 'deathstrike', Position(33002, 31918, 10))
	return true
end

warzones:uid(3143)
warzones:register()

local bossRewards = Action()

local rewards = {
	[3148] = {
		storage = PlayerStorageKeys.BigfootBurden.Warzone1Reward,
		bossName = 'Deathstrike',
		items = {
			{rand = true, itemId = {18396, 18501, 18502, 18503}},
			{itemId = 18402, count = 750},
			{itemId = 18396},
			{itemId = 2160, count = 3},
			{itemId = 18415, count = 7},
			{itemId = 18423, count = 2}
		},
		achievement = {'Final Strike', 'Death on Strike'}
	},

	[3149] = {
		storage = PlayerStorageKeys.BigfootBurden.Warzone2Reward,
		bossName = 'Gnomevil',
		items = {
			{rand = true, itemId = {18505, 18506, 18507}},
			{itemId = 18407, count = 750},
			{itemId = 18396},
			{itemId = 2160, count = 4},
			{itemId = 18413, count = 10},
			{itemId = 18423, count = 2}
		},
		miniatureHouse = true,
		achievement = {'Gnomebane\'s Bane', 'Fall of the Fallen'}
	},

	[3150] = {
		storage = PlayerStorageKeys.BigfootBurden.Warzone3Reward,
		bossName = 'Abyssador',
		items = {
			{rand = true, itemId = {18497, 18498, 18499}},
			{itemId = 18408},
			{itemId = 18396},
			{itemId = 2160, count = 5},
			{itemId = 18414, count = 12},
			{itemId = 18423, count = 2}
		},
		achievement = {'Death from Below', 'Diplomatic Immunity'}
	}
}

function bossRewards.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.uid == 3147 then
		if player:getStorageValue(PlayerStorageKeys.BigfootBurden.WarzoneStatus) == 4 then
			player:setStorageValue(PlayerStorageKeys.BigfootBurden.WarzoneStatus, 5)
			player:addItem(2137, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found some golden fruits.')
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The chest is empty.')
		end
	elseif item.uid > 3147 and item.uid < 3151 then
		local reward = rewards[item.uid]
		if not reward then
			return true
		end

		if player:getStorageValue(reward.storage) ~= 1 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, reward.bossName .. ' defends his belongings and will not let you open his chest.')
			return true
		end

		local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
		if backpack and backpack:getEmptySlots(false) < 5
				or player:getFreeCapacity() < 100 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Please make sure that you have at least 5 free inventory slots and that you can carry on additional 100 oz.')
			return true
		end

		for i = 1, #reward.items do
			local items = reward.items[i]
			if items.rand then
				if math.random(10) == 1 then
					player:addItem(items.itemId[math.random(#items.itemId)], 1)
				end
			else
				player:addItem(items.itemId, items.count or 1)
			end
		end

		if reward.miniatureHouse then
			if math.random(25) == 1 then
				player:addItem(16619, 1)
			end
		end

		player:setStorageValue(reward.storage, 0)
		player:addAchievement(reward.achievement[1])
		player:addAchievementProgress(reward.achievement[2], 50)
	end
	return true
end

bossRewards:uid(3147, 3148, 3149, 3150)
bossRewards:register()

local extractor = Action()

function extractor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 18484 then
		return false
	end

	local extractedCount = player:getStorageValue(PlayerStorageKeys.BigfootBurden.ExtractedCount)
	if extractedCount == 7 or player:getStorageValue(PlayerStorageKeys.BigfootBurden.MissionRaidersOfTheLostSpark) ~= 1 then
		return false
	end

	player:setStorageValue(PlayerStorageKeys.BigfootBurden.ExtractedCount, math.max(0, extractedCount) + 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You gathered a spark.')
	target:transform(18485)
	toPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
	return true
end

extractor:id(18213)
extractor:register()

local crystal = Action()

function crystal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local repairedCount = player:getStorageValue(PlayerStorageKeys.BigfootBurden.RepairedCrystalCount)
	if repairedCount == 5 or player:getStorageValue(PlayerStorageKeys.BigfootBurden.MissionCrystalKeeper) ~= 1 then
		return false
	end

	if target.itemid == 18307 then
		player:setStorageValue(PlayerStorageKeys.BigfootBurden.RepairedCrystalCount, repairedCount + 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have repaired a damaged crystal.')
		target:transform(18311)
		toPosition:sendMagicEffect(CONST_ME_ENERGYAREA)
	elseif table.contains({18308, 18309, 18310, 18311}, target.itemid) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This is not the crystal you\'re looking for!')
	end
	return true
end

crystal:id(18219)
crystal:register()

local mushroom = Action()

function mushroom.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local spore = Game.createItem(math.random(18221, 18224), 1, toPosition)
	if spore then
		spore:decay()
	end
	return true
end

mushroom:id(18220)
mushroom:register()

local shooting = Action()

function shooting.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local playerPos = player:getPosition()
	if player:getStorageValue(PlayerStorageKeys.BigfootBurden.Shooting) < 6 then
		local pos = Position(playerPos.x, playerPos.y - 5, 10)
		local tile = Tile(pos)
		if tile:getItemById(18226) then
			player:setStorageValue(PlayerStorageKeys.BigfootBurden.Shooting, player:getStorageValue(PlayerStorageKeys.BigfootBurden.Shooting) + 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Hit!")
			tile:getItemById(18226):remove()
			pos:sendMagicEffect(CONST_ME_FIREATTACK)
			for i = 2, 4 do
				Position(playerPos.x, playerPos.y - i, 10):sendMagicEffect(CONST_ME_TELEPORT)
			end
		elseif tile:getItemById(18227) then
			player:setStorageValue(PlayerStorageKeys.BigfootBurden.Shooting, player:getStorageValue(PlayerStorageKeys.BigfootBurden.Shooting) < 1 and 0 or player:getStorageValue(PlayerStorageKeys.BigfootBurden.Shooting) - 1)
			tile:getItemById(18227):remove()
			pos:sendMagicEffect(CONST_ME_FIREATTACK)
			for i = 2, 4 do
				Position(playerPos.x, playerPos.y - i, 10):sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
	end
	return true
end

shooting:id(18225)
shooting:register()

local matchmaker = Action()

local function revertCrystal(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end

function matchmaker.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 18321 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.BigfootBurden.MatchmakerStatus) == 1 or player:getStorageValue(PlayerStorageKeys.BigfootBurden.MissionMatchmaker) ~= 1 then
		return false
	end

	target:transform(18320)
	addEvent(revertCrystal, 40000, toPosition, 18320, 18321)

	if math.random(5) ~= 5 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'This is not the crystal you\'re looking for!')
		return true
	end

	player:setStorageValue(PlayerStorageKeys.BigfootBurden.MatchmakerStatus, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Congratulations! The crystals seem to have fallen in love and your mission is done!')
	return true
end

matchmaker:id(18312)
matchmaker:register()

local package = Action()

function package.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(item.itemid - 1)
	return true
end

package:id(18313)
package:register()

local spores = Action()

local config = {
	[18328] = 18221,
	[18329] = 18222,
	[18330] = 18223,
	[18331] = 18224
}

function spores.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local spores = config[item.itemid]
	if not spores then
		return true
	end

	local sporeCount = player:getStorageValue(PlayerStorageKeys.BigfootBurden.SporeCount)
	if sporeCount == 4 or player:getStorageValue(PlayerStorageKeys.BigfootBurden.MissionSporeGathering) ~= 1 then
		return false
	end

	if target.itemid ~= spores then
		player:setStorageValue(PlayerStorageKeys.BigfootBurden.SporeCount, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have gathered the wrong spores. You ruined your collection.')
		item:transform(18328)
		toPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	player:setStorageValue(PlayerStorageKeys.BigfootBurden.SporeCount, sporeCount + 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have gathered the correct spores.')
	item:transform(item.itemid + 1)
	toPosition:sendMagicEffect(CONST_ME_GREEN_RINGS)
	return true
end

spores:id(18328, 18329, 18330, 18331)
spores:register()

local stone = Action()

function stone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.BigfootBurden.GrindstoneStatus) == 1 or player:getStorageValue(PlayerStorageKeys.BigfootBurden.MissionGrindstoneHunt) ~= 1 then
		return false
	end

	toPosition:sendMagicEffect(CONST_ME_HITBYFIRE)
	item:transform(18335)

	if math.random(15) ~= 15 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You had no luck this time.')
		return true
	end

	player:setStorageValue(PlayerStorageKeys.BigfootBurden.GrindstoneStatus, 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Your skill allowed you to grab a whetstone before the stone sinks into lava.')
	player:addItem(18337, 1)
	return true
end

stone:id(18336)
stone:register()

local pig = Action()

function pig.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 18341 then
		return false
	end

	local mushroomCount = player:getStorageValue(PlayerStorageKeys.BigfootBurden.MushroomCount)
	if mushroomCount == 3 or player:getStorageValue(PlayerStorageKeys.BigfootBurden.MissionMushroomDigger) ~= 1 then
		return false
	end

	player:setStorageValue(PlayerStorageKeys.BigfootBurden.MushroomCount, mushroomCount + 1)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The little pig happily eats the truffles.')
	target:transform(18340)
	toPosition:sendMagicEffect(CONST_ME_GROUNDSHAKER)
	return true
end

pig:id(18339)
pig:register()

local repair = Action()

function repair.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not target:isCreature() or not target:isMonster() then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.BigfootBurden.GolemCount) < 4 and player:getStorageValue(PlayerStorageKeys.BigfootBurden.MissionTinkersBell) == 1 and target:getName():lower() == 'damaged crystal golem' then
		player:setStorageValue(PlayerStorageKeys.BigfootBurden.GolemCount, player:getStorageValue(PlayerStorageKeys.BigfootBurden.GolemCount) + 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The golem has been returned to the gnomish workshop.')
		target:remove()
		toPosition:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

repair:id(18343)
repair:register()

local endurance = MoveEvent()

local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 2000)
condition:setFormula(-0.9, 0, -0.9, 0)

function endurance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 7816 then
		local chance = math.random(5)
		if chance == 1 then
			player:teleportTo(fromPosition)
		elseif chance == 2 then
			position.y = position.y + 1
			player:teleportTo(position, true)
			player:setDirection(DIRECTION_SOUTH)
		elseif chance == 3 then
			player:addCondition(condition)
		end

	elseif item.actionid == 7817 then
		player:setStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine, 11)
		player:teleportTo(Position(32760, 31811, 10))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You passed endurance test.')

	elseif item.actionid == 7818 then
		if player:getStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine) == 10 then
			player:teleportTo(Position(32759, 31811, 11))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:teleportTo(fromPosition)
		end
	end
	return true
end

endurance:type("stepin")
endurance:aid(7816, 7817, 7818)
endurance:register()

local gctsTeleports = MoveEvent()

local destination = {
	[4121] = {position = Position(32801, 31766, 9), storageValue = 1, needCrystal = true},
	[3220] = {position = Position(32627, 31863, 11), storageValue = 1, needCrystal = true},
	[3128] = {position = Position(33000, 31870, 13), storageValue = 14},
	[3129] = {position = Position(32795, 31762, 10), storageValue = 14},
	[3130] = {position = Position(32864, 31844, 11), storageValue = 15},
	[3131] = {position = Position(32803, 31746, 10), storageValue = 15},
	[3132] = {position = Position(32986, 31862, 9), storageValue = 15}, -- Gnomebase Alpha
	[3133] = {position = Position(32796, 31781, 10), storageValue = 15}, -- City
	[3134] = {position = Position(32959, 31953, 9), storageValue = 16}, -- Golems
	[3135] = {position = Position(33001, 31915, 9), storageValue = 16}, -- Gnomebase Alpha
	[3136] = {position = Position(32904, 31894, 13), storageValue = 16},
	[3137] = {position = Position(32979, 31907, 9), storageValue = 16},
	[35669] = {position = Position(32986, 31864, 9), storageValue = 1}, -- leave warzone 3
	[3215] = {position = Position(32369, 32241, 7), storageValue = 1, needCrystal = true},
	[3216] = {position = Position(32212, 31133, 7), storageValue = 1, needCrystal = true},
	[3217] = {position = Position(32317, 32825, 7), storageValue = 1, needCrystal = true},
	[3218] = {position = Position(33213, 32454, 1), storageValue = 1, needCrystal = true},
	[3219] = {position = Position(33217, 31814, 8), storageValue = 1, needCrystal = true}
}

function gctsTeleports.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local teleportCrystal = destination[item.actionid]
	if not teleportCrystal then
		return
	end

	if player:getStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine) >= teleportCrystal.storageValue then
		if not teleportCrystal.needCrystal or player:removeItem(18457, 1) then
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:teleportTo(teleportCrystal.position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		else
			player:teleportTo(fromPosition)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need a teleport crystal to use this device.')
		end
		return true
	end

	-- There is no destination with storageValue == 2, should this check for storage?
	if teleportCrystal.storageValue == 2 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have no idea on how to use this device. Xelvar in Kazordoon might tell you more about it.')
	else
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Sorry, you don\'t have access to use this teleport!')
	end
	return true
end

gctsTeleports:type("stepin")

for index, value in pairs(destination) do
	gctsTeleports:uid(index)
end

gctsTeleports:register()

local shooting = MoveEvent()

local function doCreateDummy(cid, position)
	local player = Player(cid)
	if not player then
		return true
	end

	local tile = Tile(position)
	if tile then
		local thing = tile:getTopVisibleThing()
		if thing and table.contains({18226, 18227}, thing.itemid) then
			thing:remove()
		end
	end

	if player:getStorageValue(PlayerStorageKeys.BigfootBurden.Shooting) >= 5 then
		player:setStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine, 9)
		return
	end

	position:sendMagicEffect(CONST_ME_POFF)
	Game.createItem(math.random(18226, 18227), 1, position)
	addEvent(doCreateDummy, 2 * 1000, cid, position)
end

function shooting.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine) ~= 8 then
		player:teleportTo(fromPosition)
		return true
	end

	local playerPosition = player:getPosition()
	player:setStorageValue(PlayerStorageKeys.BigfootBurden.Shooting, 0)
	position:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	doCreateDummy(player.uid, Position(playerPosition.x, playerPosition.y - 5, 10))
	return true
end

shooting:type("stepin")
shooting:aid(8030)
shooting:register()

local truffles = MoveEvent()

function truffles.onStepIn(creature, item, position, fromPosition)
	if creature:getName():lower() ~= 'mushroom sniffer' then
		return true
	end

	local moldFloor = Tile(position):getItemById(18340)
	if moldFloor.actionid == 100 then
		return true
	end

	if math.random(3) < 3 then
		moldFloor:transform(18218)
		moldFloor:decay()
		position:sendMagicEffect(CONST_ME_POFF)
	else
		moldFloor:transform(18341)
		moldFloor:decay()
		position:sendMagicEffect(CONST_ME_GROUNDSHAKER)
	end
	return true
end

truffles:type("stepin")
truffles:id(18340)
truffles:register()

local warzone = MoveEvent()

local bosses = {
	[3144] = {position = Position(33099, 31950, 10), name = 'deathstrike'},
	[3145] = {position = Position(33103, 31951, 11), name = 'gnomevil'},
	[3146] = {position = Position(33081, 31902, 12), name = 'abyssador', checkItemId = 18463},
}

function warzone.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local boss = bosses[item.uid]
	if boss.checkItemId then
		if Tile(position):getItemById(boss.checkItemId) then
			return true
		end
	end

	player:teleportTo(boss.position)
	boss.position:sendMagicEffect(CONST_ME_TELEPORT)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have half an hour to heroically defeat ' .. boss.name .. '. Otherwise you\'ll be teleported out by the gnomish emergency device.')
	return true
end

warzone:type("stepin")
warzone:aid(3144, 3146)
warzone:register()

local warzoneTeleports = MoveEvent()

local destinations = {
	[3140] = {teleportPosition = Position(32996, 31922, 10), storage = 955, value = 1},
	[3141] = {teleportPosition = Position(33011, 31943, 11), storage = 956, value = 2},
	[3142] = {teleportPosition = Position(32989, 31909, 12), storage = 957, value = 3},
}

function warzoneTeleports.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local destination = destinations[item.uid]
	if not destination then
		return true
	end

	if player:getStorageValue(destination.storage) ~= destination.value then
		player:teleportTo(fromPosition)
		return true
	end

	player:teleportTo(destination.teleportPosition)
	destination.teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

warzoneTeleports:type("stepin")
warzoneTeleports:aid(3140, 3141, 3142)
warzoneTeleports:register()

local xRay = MoveEvent()

local messages = {
	'Gnomedix: So let the examination begin! Now don\'t move. Don\'t be afraid. The good doctor gnome won\'t hurt you - hopefully!',
	'Gnomedix: Now! Now! Don\'t panic! It\'s all over soon!',
	'Gnomedix: Let me try a bigger chisel!',
	'Gnomedix: We\'re almost don... holy gnome! What\'s THIS???',
	'Gnomedix: I need a drill! Gnomenursey, quick!',
	'Gnomedix: Hold still now! This might tickle a little..',
	'Gnomedix: Take this, you evil ... whatever you are!',
	'Gnomedix: I got it! Yikes! What was that? Uhm, well ... you passed the ear examination. Talk to Gnomaticus for your next test.'
}

local function sendTextMessages(cid, text, position)
	local player = Player(cid)
	if not player then
		return true
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, text)
	position:sendMagicEffect(CONST_ME_STUN)
end

local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(2000)
condition:setOutfit({lookType = 33}) -- skeleton looktype

function xRay.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.uid == 3122 then
		if player:getStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine) == 4 then
			player:addCondition(condition)
			player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
			player:setStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine, 5)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have been succesfully g-rayed. Now let Doctor Gnomedix inspect your ears!')
			player:say('*Rrrrrrrrrrr...*', TALKTYPE_MONSTER_SAY)
		elseif player:getStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine) < 4 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The x-ray is not ready.')
			player:teleportTo(fromPosition, true)
		end
	elseif item.uid == 3123 then
		if player:getStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine) ~= 6 then
			return true
		end

		for i = 1, #messages do
			addEvent(sendTextMessages, (i - 1) * 2000, player.uid, messages[i], player:getPosition())
		end

		player:setStorageValue(PlayerStorageKeys.BigfootBurden.QuestLine, 7)
		position.y = position.y + 1
		addEvent(Game.createMonster, 14 * 1000, 'Strange Slime', position)
	end
	return true
end

xRay:type("stepin")
xRay:uid(3122, 3123)
xRay:register()

local versperothSpawn = MoveEvent()

local versperothPosition = Position(33075, 31878, 12)

local function removeMinion(mid)
	local monster = Monster(mid)
	if monster then
		monster:getPosition():sendMagicEffect(CONST_ME_POFF)
		monster:remove()
	end
end

local function executeVersperothBattle(mid)
	if Game.getStorageValue(GlobalStorageKeys.Versperoth.Battle) ~= 1 then
		return
	end

	if mid then
		local monster = Monster(mid)
		if not monster then
			return
		end

		Game.setStorageValue(GlobalStorageKeys.Versperoth.Health, monster:getMaxHealth() - monster:getHealth())
		monster:remove()
		versperothPosition:sendMagicEffect(CONST_ME_POFF)

		local position, minionMonster
		for i = 1, math.random(8, 10) do
			position = Position(math.random(33066, 33086), math.random(31870, 31887), 12)
			minionMonster = Game.createMonster('Minion of Versperoth', position)
			position:sendMagicEffect(CONST_ME_TELEPORT)
			if minionMonster then
				addEvent(removeMinion, 20 * 1000, minionMonster.uid)
			end
		end
		addEvent(executeVersperothBattle, 10 * 1000)
		return
	end

	local monster = Game.createMonster('Versperoth', versperothPosition, false, true)
	if monster then
		versperothPosition:sendMagicEffect(CONST_ME_GROUNDSHAKER)
		monster:addHealth(-Game.getStorageValue(GlobalStorageKeys.Versperoth.Health))

		addEvent(executeVersperothBattle, 20 * 1000, monster.uid)
	end
end

function versperothSpawn.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if false and Game.getStorageValue(GlobalStorageKeys.Versperoth.Battle) >= 1 then
		return true
	end

	player:teleportTo(Position(33072, 31877, 12))
	Game.setStorageValue(GlobalStorageKeys.Versperoth.Battle, 1)
	Game.setStorageValue(GlobalStorageKeys.Versperoth.Health, 0)
	executeVersperothBattle()
	item:transform(18462)
	return true
end

versperothSpawn:type("stepin")
versperothSpawn:id(18463)
versperothSpawn:register()
