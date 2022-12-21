local questArea = {
	Position(32706, 32345, 7),
	Position(32725, 32357, 7)
}

local sounds = {
	"Release me and you will be rewarded greatefully!",
	"What is this? Demon Legs lying here? Someone might have lost them!",
	"I'm trapped, come here and free me fast!!",
	"I can bring your beloved back from the dead, just release me!",
	"What a nice shiny golden armor. Come to me and you can have it!",
	"Find a way in here and release me! Pleeeease hurry!",
	"You can have my demon set, if you help me get out of here!"
}

local demonOakVoices = GlobalEvent("DemonOakVoices")

function demonOakVoices.onThink(interval, lastExecution)
	local spectators, spectator = Game.getSpectators(DEMON_OAK_POSITION, false, true, 0, 15, 0, 15)
	for i = 1, #spectators do
		spectator = spectators[i]
		if spectator:getPosition():isInRange(questArea[1], questArea[2]) then
			return true
		end

		spectator:say(sounds[math.random(#sounds)], TALKTYPE_MONSTER_YELL, false, 0, DEMON_OAK_POSITION)
	end
	return true
end

demonOakVoices:interval(15000)
demonOakVoices:register()

local hallowedAxe = Action()

local config = {
	demonOakIds = {8288, 8289, 8290, 8291},
	sounds = {
		'MY ROOTS ARE SHARP AS A SCYTHE! FEEL IT?!?',
		'CURSE YOU!',
		'RISE, MINIONS, RISE FROM THE DEAD!!!!',
		'AHHHH! YOUR BLOOD MAKES ME STRONG!',
		'GET THE BONES, HELLHOUND! GET THEM!!',
		'GET THERE WHERE I CAN REACH YOU!!!',
		'ETERNAL PAIN AWAITS YOU! NICE REWARD, HUH?!?!',
		'YOU ARE GOING TO PAY FOR EACH HIT WITH DECADES OF TORTURE!!',
		'ARGG! TORTURE IT!! KILL IT SLOWLY MY MINION!!'
	},

	bonebeastChance = 90,
	bonebeastCount = 4,
	waves = 10,
	questArea = {
		fromPosition = Position(32706, 32345, 7),
		toPosition = Position(32725, 32357, 7)
	},

	summonPositions = {
		Position(32714, 32348, 7),
		Position(32712, 32349, 7),
		Position(32711, 32351, 7),
		Position(32713, 32354, 7),
		Position(32716, 32354, 7),
		Position(32719, 32354, 7),
		Position(32721, 32351, 7),
		Position(32719, 32348, 7)
	},

	summons = {
		[8288] = {
			[5] = {'Braindeath', 'Braindeath', 'Braindeath', 'Bonebeast'},
			[10] = {'Betrayed Wraith', 'Betrayed Wraith'}
		},

		[8289] = {
			[5] = {'Lich', 'Lich', 'Lich'},
			[10] = {'Dark Torturer', 'Blightwalker'}
		},

		[8290] = {
			[5] = {'Banshee', 'Banshee', 'Banshee'},
			[10] = {'Grim Reaper'}
		},

		[8291] = {
			[5] = {'Giant Spider', 'Giant Spider', 'Lich'},
			[10] = {'Undead Dragon', 'Hand of Cursed Fate'}
		}
	},

	storages = {
		[8288] = PlayerStorageKeys.DemonOak.AxeBlowsBird,
		[8289] = PlayerStorageKeys.DemonOak.AxeBlowsLeft,
		[8290] = PlayerStorageKeys.DemonOak.AxeBlowsRight,
		[8291] = PlayerStorageKeys.DemonOak.AxeBlowsFace
	}
}

local function getRandomSummonPosition()
	return config.summonPositions[math.random(#config.summonPositions)]
end

function hallowedAxe.onUse(player, item, fromPosition, target, toPosition, isHotkey)
if not table.contains(config.demonOakIds, target.itemid) then
		return true
	end

	local totalProgress = 0
	for k, v in pairs(config.storages) do
		totalProgress = totalProgress + math.max(0, player:getStorageValue(v))
	end

	local spectators, hasMonsters = Game.getSpectators(DEMON_OAK_POSITION, false, false, 9, 9, 6, 6), false
	for i = 1, #spectators do
		if spectators[i]:isMonster() then
			hasMonsters = true
			break
		end
	end

	local isDefeated = totalProgress == (#config.demonOakIds * (config.waves + 1))
	if (config.killAllBeforeCut or isDefeated)
			and hasMonsters then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You need to kill all monsters first.')
		return true
	end

	if isDefeated then
		player:teleportTo(DEMON_OAK_KICK_POSITION)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Tell Oldrak about your great victory against the demon oak.')
		player:setStorageValue(PlayerStorageKeys.DemonOak.Done, 1)
		player:setStorageValue(PlayerStorageKeys.DemonOak.Progress, 3)
		return true
	end

	local cStorage = config.storages[target.itemid]
	local progress = math.max(player:getStorageValue(cStorage), 1)
	if progress >= config.waves + 1 then
		toPosition:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	local isLastCut = totalProgress == (#config.demonOakIds * (config.waves + 1) - 1)
	local summons = config.summons[target.itemid]
	if summons and summons[progress] then
		-- Summon a single demon on the last hit
		if isLastCut then
			Game.createMonster('Demon', getRandomSummonPosition(), false, true)

		-- Summon normal monsters otherwise
		else
			for i = 1, #summons[progress] do
				Game.createMonster(summons[progress][i], getRandomSummonPosition(), false, true)
			end
		end

	-- if it is not the 5th or 10th there is only a chance to summon bonebeasts
	elseif math.random(100) >= config.bonebeastChance then
		for i = 1, config.bonebeastCount do
			Game.createMonster('Bonebeast', getRandomSummonPosition(), false, true)
		end
	end

	player:say(isLastCut and 'HOW IS THAT POSSIBLE?!? MY MASTER WILL CRUSH YOU!! AHRRGGG!' or config.sounds[math.random(#config.sounds)], TALKTYPE_MONSTER_YELL, false, player, DEMON_OAK_POSITION)
	toPosition:sendMagicEffect(CONST_ME_DRAWBLOOD)
	player:setStorageValue(cStorage, progress + 1)
	player:say('-krrrrak-', TALKTYPE_MONSTER_YELL, false, player, toPosition)
	doTargetCombat(0, player, COMBAT_EARTHDAMAGE, -170, -210, CONST_ME_BIGPLANTS)
	return true
end

hallowedAxe:id(8293)
hallowedAxe:register()

local oakChest = Action()

local chests = {
	[9008] = {itemid = 2495, count = 1},
	[9009] = {itemid = 8905, count = 1},
	[9010] = {itemid = 16111, count = 1},
	[9011] = {itemid = 16112, count = 1}
}

function oakChest.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if chests[item.uid] then
		if player:getStorageValue(PlayerStorageKeys.DemonOak.Done) ~= 2 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'It\'s empty.')
			return true
		end

		local chest = chests[item.uid]
		local itemType = ItemType(chest.itemid)
		if itemType then
			local article = itemType:getArticle()
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found ' .. (#article > 0 and article .. ' ' or '') .. itemType:getName() .. '.')
		end

		player:addItem(chest.itemid, chest.count)
		player:setStorageValue(PlayerStorageKeys.DemonOak.Done, 3)
	end
	return true
end

oakChest:uid(9008, 9009, 9010, 90011)
oakChest:register()

local oakGravestone = Action()

function oakGravestone.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.DemonOak.Done) == 2 then
		player:teleportTo(DEMON_OAK_REWARDROOM_POSITION)
		DEMON_OAK_REWARDROOM_POSITION:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	return true
end

oakGravestone:uid(9007)
oakGravestone:register()
