local blackKnightKill = CreatureEvent("SecretServiceBlackKnight")

function blackKnightKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'black knight' then
		return true
	end

	local player = creature:getPlayer()
	if player:getStorageValue(PlayerStorageKeys.secretService.AVINMission04) == 1 then
		player:setStorageValue(PlayerStorageKeys.secretService.AVINMission04, 2)
	end

	return true
end

blackKnightKill:register()

local amazonDisguiseKit = Action()

local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(20 * 1000) -- should be approximately 20 seconds
condition:setOutfit({lookType = 137, lookHead = 113, lookBody = 120, lookLegs = 114, lookFeet = 132}) -- amazon looktype

function amazonDisguiseKit.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:addCondition(condition)
	player:say('You disguise yourself as a beautiful amazon!', TALKTYPE_MONSTER_SAY)
	item:remove()
	return true
end

amazonDisguiseKit:id(7700)
amazonDisguiseKit:register()

local ring = Action()

function ring.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 12563 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.secretService.TBIMission05) == 1 then
		player:setStorageValue(PlayerStorageKeys.secretService.TBIMission05, 2)
		item:remove()
		player:say('You have placed the false evidence!', TALKTYPE_MONSTER_SAY)
	end
	return true
end

ring:id(7697)
ring:register()

local tools = Action()

local config = {
	[7960] = 10515, -- TBI
	[7961] = 10513, -- CGB
	[7962] = 10511 -- AVIN
}

function tools.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local useItem = config[item.itemid]
	if not useItem then
		return true
	end

	player:addItem(useItem)
	player:say('You\'ve found a useful little tool for secret agents in the parcel.', TALKTYPE_MONSTER_SAY)

	item:remove()
	return true
end

tools:id(7960, 7961, 7962)
tools:register()

local rustBugs = Action()

function rustBugs.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.uid ~= 12579 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.secretService.CGBMission03) == 1 then
		player:setStorageValue(PlayerStorageKeys.secretService.CGBMission03, 2)
		item:remove()
		Game.createItem(8016, 1, Position(32909, 32112, 7))
		player:say('The bugs are at work!', TALKTYPE_MONSTER_SAY)
	end
	return true
end

rustBugs:id(7698)
rustBugs:register()

local lever = Action()

local monsters = {
	{monster = 'dwarf henchman', monsterPos = Position(32570, 31858, 14)},
	{monster = 'dwarf henchman', monsterPos = Position(32573, 31861, 14)},
	{monster = 'dwarf henchman', monsterPos = Position(32562, 31860, 14)},
	{monster = 'dwarf henchman', monsterPos = Position(32564, 31856, 14)},
	{monster = 'dwarf henchman', monsterPos = Position(32580, 31860, 14)},
	{monster = 'dwarf henchman', monsterPos = Position(32574, 31850, 14)},
	{monster = 'dwarf henchman', monsterPos = Position(32574, 31870, 14)},
	{monster = 'dwarf henchman', monsterPos = Position(32576, 31856, 14)},
	{monster = 'dwarf henchman', monsterPos = Position(32562, 31858, 14)},
	{monster = 'dwarf henchman', monsterPos = Position(32584, 31868, 14)},
	{monster = 'stone golem', monsterPos = Position(32570, 31861, 14)},
	{monster = 'stone golem', monsterPos = Position(32579, 31868, 14)},
	{monster = 'stone golem', monsterPos = Position(32569, 31852, 14)},
	{monster = 'stone golem', monsterPos = Position(32584, 31866, 14)},
	{monster = 'stone golem', monsterPos = Position(32572, 31851, 14)},
	{monster = 'mechanical fighter', monsterPos = Position(32573, 31858, 14)},
	{monster = 'mechanical fighter', monsterPos = Position(32570, 31868, 14)},
	{monster = 'mechanical fighter', monsterPos = Position(32579, 31852, 14)},
	{monster = 'mad technomancer', monsterPos = Position(32571, 31859, 14)}
}

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid == 1945 then
		for i = 1, #monsters do
			Game.createMonster(monsters[i].monster, monsters[i].monsterPos)
		end
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)
	return true
end

lever:aid(12574)
lever:register()

local amazons = MoveEvent()

function amazons.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.secretService.AVINMission03) == 1 then
		player:setStorageValue(PlayerStorageKeys.secretService.AVINMission03, 2)
		Game.createMonster('amazon', Position(32326, 31803, 8))
		Game.createMonster('amazon', Position(32330, 31803, 8))
	end
	return true
end

amazons:type("stepin")
amazons:aid(12583, 12584)
amazons:register()

local pirates = MoveEvent()

function pirates.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.secretService.TBIMission03) == 1 then
		player:setStorageValue(PlayerStorageKeys.secretService.TBIMission03, 2)
		Game.createMonster('pirate buccaneer', Position(32641, 32733, 7))
		Game.createMonster('pirate buccaneer', Position(32642, 32733, 7))
	end
	return true
end

pirates:type("stepin")
pirates:aid(12571)
pirates:register()
