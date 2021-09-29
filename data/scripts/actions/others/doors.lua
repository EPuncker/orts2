local positionOffsets = {
	Position(1, 0, 0), -- east
	Position(0, 1, 0), -- south
	Position(-1, 0, 0), -- west
	Position(0, -1, 0) -- north
}

--[[
When closing a door with a creature in it findPushPosition will find the most appropriate
adjacent position following a prioritization order.
The function returns the position of the first tile that fulfills all the checks in a round.
The function loops trough east -> south -> west -> north on each following line in that order.
In round 1 it checks if there's an unhindered walkable tile without any creature.
In round 2 it checks if there's a tile with a creature.
In round 3 it checks if there's a tile blocked by a movable tile-blocking item.
In round 4 it checks if there's a tile blocked by a magic wall or wild growth.
]]
local function findPushPosition(creature, round)
	local pos = creature:getPosition()
	for _, offset in ipairs(positionOffsets) do
		local offsetPosition = pos + offset
		local tile = Tile(offsetPosition)
		if tile then
			local creatureCount = tile:getCreatureCount()
			if round == 1 then
				if tile:queryAdd(creature) == RETURNVALUE_NOERROR and creatureCount == 0 then
					if not tile:hasFlag(TILESTATE_PROTECTIONZONE) or (tile:hasFlag(TILESTATE_PROTECTIONZONE) and creature:canAccessPz()) then
						return offsetPosition
					end
				end
			elseif round == 2 then
				if creatureCount > 0 then
					if not tile:hasFlag(TILESTATE_PROTECTIONZONE) or (tile:hasFlag(TILESTATE_PROTECTIONZONE) and creature:canAccessPz()) then
						return offsetPosition
					end
				end
			elseif round == 3 then
				local topItem = tile:getTopDownItem()
				if topItem then
					if topItem:getType():isMovable() then
						return offsetPosition
					end
				end
			else
				if tile:getItemById(ITEM_MAGICWALL) or tile:getItemById(ITEM_WILDGROWTH) then
					return offsetPosition
				end
			end
		end
	end
	if round < 4 then
		return findPushPosition(creature, round + 1)
	end
end

local door = Action()

function door.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemId = item:getId()
	if table.contains(questDoors, itemId) then
		if player:getStorageValue(item.actionid) ~= -1 then
			item:transform(itemId + 1)
			player:teleportTo(toPosition, true)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
		end
		return true
	elseif table.contains(levelDoors, itemId) then
		if item.actionid > 0 and player:getLevel() >= item.actionid - actionIds.levelDoor then
			item:transform(itemId + 1)
			player:teleportTo(toPosition, true)
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only the worthy may pass.")
		end
		return true
	elseif table.contains(keys, itemId) then
		if target.actionid > 0 then
			if item.actionid == target.actionid and doors[target.itemid] then
				target:transform(doors[target.itemid])
				return true
			end
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "The key does not match.")
			return true
		end
		return false
	end

	if table.contains(horizontalOpenDoors, itemId) or table.contains(verticalOpenDoors, itemId) then
		local creaturePositionTable = {}
		local doorCreatures = Tile(toPosition):getCreatures()
		if doorCreatures and #doorCreatures > 0 then
			for _, doorCreature in pairs(doorCreatures) do
				local pushPosition = findPushPosition(doorCreature, 1)
				if not pushPosition then
					player:sendCancelMessage(RETURNVALUE_NOTENOUGHROOM)
					return true
				end
				table.insert(creaturePositionTable, {creature = doorCreature, position = pushPosition})
			end
			for _, tableCreature in ipairs(creaturePositionTable) do
				tableCreature.creature:teleportTo(tableCreature.position, true)
			end
		end

		if not(table.contains(openQuestDoors, itemId)) and not(table.contains(openLevelDoors, itemId)) then
			item:transform(itemId - 1)
		end
		return true
	end

	if doors[itemId] then
		if item.actionid == 0 then
			item:transform(doors[itemId])
		else
			player:sendTextMessage(MESSAGE_INFO_DESCR, "It is locked.")
		end
		return true
	end
	return false
end

local doorsSet = {} -- unique value set for door ids
for _, d in ipairs(keys) do if doorsSet[d] == nil then doorsSet[d] = true end end
for d, _ in pairs(openDoors) do if doorsSet[d] == nil then doorsSet[d] = true end end
for d, _ in pairs(closedDoors) do if doorsSet[d] == nil then doorsSet[d] = true end end
for d, _ in pairs(lockedDoors) do if doorsSet[d] == nil then doorsSet[d] = true end end
for d, _ in pairs(openExtraDoors) do if doorsSet[d] == nil then doorsSet[d] = true end end
for d, _ in pairs(closedExtraDoors) do if doorsSet[d] == nil then doorsSet[d] = true end end
for d, _ in pairs(openHouseDoors) do if doorsSet[d] == nil then doorsSet[d] = true end end
for d, _ in pairs(closedHouseDoors) do if doorsSet[d] == nil then doorsSet[d] = true end end
-- for d, _ in pairs(openQuestDoors) do if doorsSet[d] == nil then doorsSet[d] = true end end -- disabled in globa.lua
for d, _ in pairs(closedQuestDoors) do if doorsSet[d] == nil then doorsSet[d] = true end end
-- for d, _ in pairs(openLevelDoors) do if doorsSet[d] == nil then doorsSet[d] = true end end -- disabled in globa.lua
for d, _ in pairs(closedLevelDoors) do if doorsSet[d] == nil then doorsSet[d] = true end end
for i, _ in pairs(doorsSet) do
	door:id(i)
end
doorsSet = nil
door:register()
