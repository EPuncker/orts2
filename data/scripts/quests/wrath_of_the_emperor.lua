local positions = {
	Position(33385, 31139, 8),
	Position(33385, 31134, 8),
	Position(33385, 31126, 8),
	Position(33385, 31119, 8),
	Position(33385, 31118, 8),
	Position(33380, 31085, 8),
	Position(33380, 31093, 8)
}

local spyHoles = GlobalEvent("5000")

function spyHoles.onThink(interval, lastExecution)
	if math.random(100) < 50 then
		return true
	end

	local item
	for i = 1, #positions do
		item = Tile(positions[i]):getThing(1)
		if item and table.contains({12213, 12214}, item.itemid) then
			item:transform(item.itemid == 12213 and 12214 or 12213)
		end
	end

	return true
end

spyHoles:interval(15000)
spyHoles:register()

local lizardMagistratus = CreatureEvent("WotELizardMagistratus")

function lizardMagistratus.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'lizard magistratus' then
		return true
	end

	local player = creature:getPlayer()
	local storage = player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission06)
	if storage >= 0 and storage < 4 then
		player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission06, math.max(1, storage) + 1)
	end
	return true
end

lizardMagistratus:register()

local lizardNoble = CreatureEvent("WotELizardNoble")

function lizardNoble.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'lizard noble' then
		return true
	end

	local player = creature:getPlayer()
	local storage = player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission07)
	if storage >= 0 and storage < 6 then
		player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission07, math.max(1, storage) + 1)
	end
	return true
end

lizardNoble:register()

local keeper = CreatureEvent("WotEKeeper")

function keeper.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() == 'the keeper' then
		Game.setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03, 0)
	end
	return true
end

keeper:register()

local bosses = CreatureEvent("WotEBosses")

local bossesKill = {
	['fury of the emperor'] = {position = Position(33048, 31085, 15), storage = GlobalStorageKeys.WrathOfTheEmperor.Bosses.Fury},
	['wrath of the emperor'] = {position = Position(33094, 31087, 15), storage = GlobalStorageKeys.WrathOfTheEmperor.Bosses.Wrath},
	['scorn of the emperor'] = {position = Position(33095, 31110, 15), storage = GlobalStorageKeys.WrathOfTheEmperor.Bosses.Scorn},
	['spite of the emperor'] = {position = Position(33048, 31111, 15), storage = GlobalStorageKeys.WrathOfTheEmperor.Bosses.Spite},
}

function bosses.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	local bossConfig = bossesKill[targetMonster:getName():lower()]
	if not bossConfig then
		return true
	end

	Game.setStorageValue(bossConfig.storage, 0)
	local tile = Tile(bossConfig.position)
	if tile then
		local thing = tile:getItemById(11753)
		if thing then
			thing:transform(12383)
		end
	end
	return true
end

bosses:register()

local zalamon = CreatureEvent("WotEZalamon")

local bossForms = {
	['snake god essence'] = {
		text = 'IT\'S NOT THAT EASY MORTALS! FEEL THE POWER OF THE GOD!',
		newForm = 'snake thing'
	},

	['snake thing'] = {
		text = 'NOOO! NOW YOU HERETICS WILL FACE MY GODLY WRATH!',
		newForm = 'lizard abomination'
	},

	['lizard abomination'] = {
		text = 'YOU ... WILL ... PAY WITH ETERNITY ... OF AGONY!',
		newForm = 'mutated zalamon'
	}
}

function zalamon.onKill(creature, target)
local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() == 'mutated zalamon' then
		Game.setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission11, -1)
		return true
	end

	local bossConfig = bossForms[targetMonster:getName():lower()]
	if not bossConfig then
		return true
	end

	Game.createMonster(bossConfig.newForm, targetMonster:getPosition(), false, true)
	player:say(bossConfig.text, TALKTYPE_MONSTER_SAY)
	return true
end

zalamon:register()

local crate = Action()

local condition = Condition(CONDITION_OUTFIT)
condition:setOutfit({lookTypeEx = 12496})
condition:setTicks(-1)

function crate.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.CrateStatus) ~= 1 and player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Questline) == 2 then
		player:addCondition(condition)
		player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.CrateStatus, 1)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

crate:id(12284)
crate:register()

local lights = Action()

local function transformLamp(position, itemId, transformId)
	local lampItem = Tile(position):getItemById(itemId)
	if lampItem then
		lampItem:transform(transformId)
	end
end

function lights.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if(item.uid == 3171) then
		if Game.getStorageValue(GlobalStorageKeys.WrathOfTheEmperor.Light01) ~= 1 then
			Game.setStorageValue(GlobalStorageKeys.WrathOfTheEmperor.Light01, 1)
			addEvent(Game.setStorageValue, 20 * 1000, GlobalStorageKeys.WrathOfTheEmperor.Light01, 0)
			local pos = {
				Position(33369, 31075, 8),
				Position(33372, 31075, 8)
			}

			for i = 1, #pos do
				transformLamp(pos[i], 11447, 11446)
				addEvent(transformLamp, 20 * 1000, pos[i], 11446, 11447)
			end
		end
	elseif(item.uid == 3172) then
		if Game.getStorageValue(GlobalStorageKeys.WrathOfTheEmperor.Light02) ~= 1 then
			Game.setStorageValue(GlobalStorageKeys.WrathOfTheEmperor.Light02, 1)
			addEvent(Game.setStorageValue, 20 * 1000, GlobalStorageKeys.WrathOfTheEmperor.Light02, 0)
			local pos = Position(33360, 31079, 8)
			transformLamp(pos, 11449, 11463)
			addEvent(transformLamp, 20 * 1000, pos, 11463, 11449)
		end
	elseif(item.uid == 3173) then
		if Game.getStorageValue(GlobalStorageKeys.WrathOfTheEmperor.Light03) ~= 1 then
			Game.setStorageValue(GlobalStorageKeys.WrathOfTheEmperor.Light03, 1)
			addEvent(Game.setStorageValue, 20 * 1000, GlobalStorageKeys.WrathOfTheEmperor.Light03, 0)
			local pos = Position(33346, 31074, 8)
			transformLamp(pos, 11449, 11463)
			addEvent(transformLamp, 20 * 1000, pos, 11463, 11449)
		end
	elseif(item.uid == 3174) then
		if Game.getStorageValue(GlobalStorageKeys.WrathOfTheEmperor.Light04) ~= 1 then
			Game.setStorageValue(GlobalStorageKeys.WrathOfTheEmperor.Light04, 1)
			addEvent(Game.setStorageValue, 20 * 1000, GlobalStorageKeys.WrathOfTheEmperor.Light04, 0)

			local wallItem, pos
			for i = 1, 4 do
				pos = Position(33355, 31067 + i, 9)
				wallItem = Tile(pos):getItemById(9264)
				if wallItem then
					wallItem:remove()
					addEvent(Game.createItem, 20 * 1000, 9264, 1, pos)
				end
			end
		end
	end
	return true
end

lights:uid(3171, 3172, 3173, 3174)
lights:register()

local firstContactRepairTeleport = Action()

function firstContactRepairTeleport.onUse(player, item, fromPosition, target, toPosition, isHotkey)

	return true
end

firstContactRepairTeleport:id(12285, 12289, 12290, 12297, 12300, 12303)
firstContactRepairTeleport:register()

local theKeeper = Action()

local function revertKeeperstorage()
	Game.setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03, 0)
end

function theKeeper.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 12320 and target.actionid == 8026 then
		if Game.getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03) < 5 then
			Game.setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03, math.max(0, Game.getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03)) + 1)
			player:say("The plant twines and twiggles even more than before, it almost looks as it would scream great pain.", TALKTYPE_MONSTER_SAY)
		elseif Game.getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03) == 5 then
			Game.setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03, 6)
			toPosition:sendMagicEffect(CONST_ME_YELLOW_RINGS)
			Game.createMonster('the keeper', Position(33171, 31058, 11))
			Position(33171, 31058, 11):sendMagicEffect(CONST_ME_TELEPORT)
			addEvent(revertKeeperstorage, 60 * 1000)
		end
	elseif item.itemid == 12316 then
		if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Questline) == 7 then
			player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Questline, 8)
			player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission03, 2) -- Questlog, Wrath of the Emperor "Mission 03: The Keeper"
			player:addItem(12323, 1)
		end
	end
	return true
end

theKeeper:id(12316, 12320)
theKeeper:register()

local sacramentoftheSnakeSceptre = Action()

function sacramentoftheSnakeSceptre.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getItemCount(12324) >= 1 and player:getItemCount(12325) >= 1 and player:getItemCount(12326) >= 1 and player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Questline) == 10 then
		player:removeItem(12324, 1)
		player:removeItem(12325, 1)
		player:removeItem(12326, 1)
		player:addItem(12327, 1)
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Questline, 11)
		player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission04, 2) --Questlog, Wrath of the Emperor "Mission 04: Sacrament of the Snake"
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

sacramentoftheSnakeSceptre:uid(12354)
sacramentoftheSnakeSceptre:register()

local uninvitedGuestsLever = Action()

local config = {
	[3184] = Position(33082, 31110, 2),
	[3185] = Position(33078, 31080, 13)
}

function uninvitedGuestsLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.uid]
	if not targetPosition then
		return true
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)

	toPosition.y = toPosition.y + 1
	local creature = Tile(toPosition):getTopCreature()
	if not creature or not creature:isPlayer() then
		return true
	end

	if item.itemid ~= 1945 then
		return true
	end

	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	creature:teleportTo(targetPosition)
	targetPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

uninvitedGuestsLever:uid(3184, 3185)
uninvitedGuestsLever:register()

local theSleepingDragonMixture = Action()

function theSleepingDragonMixture.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.InterdimensionalPotion) == 1 then
		return true
	end

	player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.InterdimensionalPotion, 1)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

	item:remove()
	return true
end

theSleepingDragonMixture:id(12328)
theSleepingDragonMixture:register()

local messageofFreedomSceptre = Action()

local boss = {
	[3193] = "fury of the emperor",
	[3194] = "wrath of the emperor",
	[3195] = "scorn of the emperor",
	[3196] = "spite of the emperor",
}

function messageofFreedomSceptre.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if boss[target.uid] and target.itemid == 12383 then
		target:transform(11753)
		Game.createMonster(boss[target.uid], {x = toPosition.x + 4, y = toPosition.y, z = toPosition.z})
		Game.setStorageValue(target.uid - 4, 1)
	elseif target.itemid == 12317 then
		if toPosition.x > 33034 and toPosition.x < 33071 and
			toPosition.y > 31079 and toPosition.y < 31102 then
			if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.BossStatus) == 1 then
				player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.BossStatus, 2)
				player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission10, 3) --Questlog, Wrath of the Emperor "Mission 10: A Message of Freedom"
				player:say("The sceptre is almost torn from your hand as you banish the presence of the emperor.", TALKTYPE_MONSTER_SAY)
			end
		elseif toPosition.x > 33080 and toPosition.x < 33111 and
			toPosition.y > 31079 and toPosition.y < 31100 then
			if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.BossStatus) == 2 then
				player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.BossStatus, 3)
				player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission10, 4) --Questlog, Wrath of the Emperor "Mission 10: A Message of Freedom"
				player:say("The sceptre is almost torn from your hand as you banish the presence of the emperor.", TALKTYPE_MONSTER_SAY)
			end
		elseif toPosition.x > 33078 and toPosition.x < 33112 and
			toPosition.y > 31106 and toPosition.y < 31127 then
			if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.BossStatus) == 3 then
				player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.BossStatus, 4)
				player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission10, 5) --Questlog, Wrath of the Emperor "Mission 10: A Message of Freedom"
				player:say("The sceptre is almost torn from your hand as you banish the presence of the emperor.", TALKTYPE_MONSTER_SAY)
			end
		elseif toPosition.x > 33035 and toPosition.x < 33069 and
			toPosition.y > 31107 and toPosition.y < 31127 then
			if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.BossStatus) == 4 then
				player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.BossStatus, 5)
				player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission10, 6) --Questlog, Wrath of the Emperor "Mission 10: A Message of Freedom"
				player:say("The sceptre is almost torn from your hand as you banish the presence of the emperor.", TALKTYPE_MONSTER_SAY)
				local destination = Position(33072, 31151, 15)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:teleportTo(destination)
				destination:sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
	elseif target.itemid == 12385 then
		if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Questline) == 31 then
			player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Questline, 32)
			player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission11, 2) --Questlog, Wrath of the Emperor "Mission 11: Payback Time"
		end
			player:say("NOOOoooooooo...!", TALKTYPE_MONSTER_SAY, false, player, toPosition)
			player:say("This should have dealt the deathblow to the snake things' ambitions.", TALKTYPE_MONSTER_SAY)
	end
	return true
end

messageofFreedomSceptre:id(12318)
messageofFreedomSceptre:register()

local paybackTimeLever = Action()

local config = {
	firstboss = "snake god essence",
	bossPosition = Position(33365, 31407, 10),
	trap = "plaguethrower",
	trapPositions = {
		Position(33355, 31403, 10),
		Position(33364, 31403, 10),
		Position(33355, 31410, 10),
		Position(33364, 31410, 10)
	},

	startAreaPosition = Position(33357, 31404, 9),
	arenaPosition = Position(33359, 31406, 10)
}

function paybackTimeLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if Game.getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission11) == 1 then
		player:sendTextMessage(MESSAGE_STATUS_SMALL, 'The arena is already in use.')
		return true
	end

	Game.setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission11, 1)

	local monsters = Game.getSpectators(config.arenaPosition, false, false, 10, 10, 10, 10)
	local spectator
	for i = 1, #monsters do
		spectator = monsters[i]
		if spectator:isMonster() then
			spectator:remove()
		end
	end

	local spectators = Game.getSpectators(config.startAreaPosition, false, true, 0, 5, 0, 5)
	for i = 1, #spectators do
		spectator = spectators[i]
		spectator:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		spectator:teleportTo(config.arenaPosition)
		config.arenaPosition:sendMagicEffect(CONST_ME_TELEPORT)
	end

	for i = 1, #config.trapPositions do
		Game.createMonster(config.trap, config.trapPositions[i])
	end

	Game.createMonster(config.firstboss, config.bossPosition)
	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

paybackTimeLever:uid(3198)
paybackTimeLever:register()

local justRewards = Action()

function justRewards.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission12) == 0 then
		player:addOutfit(366, 0)
		player:addOutfit(367, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found some clothes in wardrobe")
		player:setStorageValue(PlayerStorageKeys.WrathoftheEmperor.Mission12, 1) --Questlog, Wrath of the Emperor "Mission 12: Just Rewards"
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The wardrobe is empty.")
	end
	return true
end

justRewards:uid(3200)
justRewards:register()
