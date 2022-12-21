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
