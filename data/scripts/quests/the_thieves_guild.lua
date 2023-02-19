local nomadKill = CreatureEvent("ThievesGuildNomad")

function nomadKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'nomad' then
		return true
	end

	local player = creature:getPlayer()
	if player:getStorageValue(PlayerStorageKeys.thievesGuild.Mission04) == 3 then
		player:setStorageValue(PlayerStorageKeys.thievesGuild.Mission04, 4)
	end

	return true
end

nomadKill:register()

local dwarfDisguiseKit = Action()

local condition = Condition(CONDITION_OUTFIT)
condition:setTicks(5 * 60 * 1000) -- should be 5 minutes
condition:setOutfit({lookType = 66}) -- dwarf geomancer looktype

function dwarfDisguiseKit.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	player:addCondition(condition)
	item:remove()
	return true
end

dwarfDisguiseKit:id(8693)
dwarfDisguiseKit:register()

local note = Action()

local function removeNote(position)
	local noteItem = Tile(position):getItemById(8700)
	if noteItem then
		noteItem:remove()
	end
end

function note.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 12509 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.thievesGuild.Mission08) == 1 then
		player:removeItem(8701, 1)
		local notePos = Position(32598, 32381, 10)
		Game.createItem(8700, 1, notePos)
		player:setStorageValue(PlayerStorageKeys.thievesGuild.Mission08, 2)
		addEvent(removeNote, 5 * 60 * 1000, notePos)
	end
	return true
end

note:id(8701)
note:register()

local climbingVine = Action()

local config = {
	[12501] = Position(32336, 31813, 6), -- to the room
	[12502] = Position(32337, 31815, 7) -- outside the room
}

function climbingVine.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.actionid]
	if not targetPosition then
		return true
	end

	player:teleportTo(targetPosition)
	return true
end

climbingVine:aid(12501, 12502)
climbingVine:register()

local fishnappingKey = Action()

function fishnappingKey.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 12505 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.thievesGuild.Mission06) == 2 then
		player:removeItem(8762, 1)
		player:say('In your haste you break the key while slipping in.', TALKTYPE_MONSTER_SAY)
		player:teleportTo(Position(32359, 32788, 6))
	end
	return true
end

fishnappingKey:id(8762)
fishnappingKey:register()

local fishnappingDoor = Action()

function fishnappingDoor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.thievesGuild.Mission06) == 3 then
		player:say('You slip through the door', TALKTYPE_MONSTER_SAY)
		player:teleportTo(Position(32359, 32786, 6))
	end
	return true
end

fishnappingDoor:aid(12505)
fishnappingDoor:register()
