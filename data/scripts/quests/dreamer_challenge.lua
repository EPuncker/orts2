local documentsLever = Action()

local config = {
	[3041] = {position = Position(32836, 32221, 14), itemId = 7844},
	[3042] = {position = Position(32837, 32229, 14), itemId = 7846},
	[3043] = {position = Position(32833, 32225, 14), itemId = 7845},
	[3045] = {position = Position(32784, 32222, 14), itemId = 7844},
	[3046] = {position = Position(32785, 32230, 14), itemId = 7846},
	[3047] = {position = Position(32781, 32226, 14), itemId = 7845}
}

local function revertLever(position)
	local leverItem = Tile(position):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end
end

function documentsLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local altar = config[item.uid]
	if not altar then
		return true
	end

	if item.itemid ~= 1945 then
		return true
	end

	local diamondItem = Tile(altar.position):getItemById(2145)
	if diamondItem then
		diamondItem:remove(1)
		altar.position:sendMagicEffect(CONST_ME_TELEPORT)
		Game.createItem(altar.itemId, 1, altar.position)
		item:transform(1946)
		addEvent(revertLever, 4 * 1000, toPosition)
	end
	return true
end

documentsLever:uid(3041, 3042, 3043, 3045, 3046, 3047)
documentsLever:register()

local documents = Action()

local config = {
	[7844] = {
		[1] = {female = 269, male = 268, msg = 'nightmare'},
		[2] = {female = 279, male = 278, msg = 'brotherhood'}
	},

	[7845] = {
		[1] = {female = 269, male = 268, addon = 1, msg = 'first nightmare'},
		[2] = {female = 279, male = 278, addon = 1, msg = 'first brotherhood'},
		storageValue = 2
	},

	[7846] = {
		[1] = {female = 269, male = 268, addon = 2, msg = 'second nightmare'},
		[2] = {female = 279, male = 278, addon = 2, msg = 'second brotherhood'},
		storageValue = 3
	}
}

function documents.onUse(player, item, fromPosition, target, toPosition, isHotkey)
local useItem = config[item.itemid]
	if not useItem then
		return true
	end

	local choice = useItem[1]
	if player:getStorageValue(PlayerStorageKeys.OutfitQuest.BrotherhoodOutfit) > player:getStorageValue(PlayerStorageKeys.OutfitQuest.NightmareOutfit) then
		choice = useItem[2]
	end

	if choice.addon then
		if player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and choice.female or choice.male) then
			if not player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and choice.female or choice.male, choice.addon) then
				if player:getStorageValue(PlayerStorageKeys.OutfitQuest.NightmareOutfit) >= useItem.storageValue or player:getStorageValue(PlayerStorageKeys.OutfitQuest.BrotherhoodOutfit) >= useItem.storageValue then
					player:addOutfitAddon(choice.female, choice.addon)
					player:addOutfitAddon(choice.male, choice.addon)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have received the ' .. choice.msg .. ' addon!')
					player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
					item:remove(1)
				else
					return false
				end
			else
				player:sendCancelMessage('You have already obtained this addon!')
			end
		else
			return false
		end
	else
		if not player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and choice.female or choice.male) then
			if player:getStorageValue(PlayerStorageKeys.OutfitQuest.NightmareOutfit) >= 1 or player:getStorageValue(PlayerStorageKeys.OutfitQuest.BrotherhoodOutfit) >= 1 then
				player:addOutfit(choice.female)
				player:addOutfit(choice.male)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have received the ' .. choice.msg .. ' outfit!')
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
				item:remove(1)
			else
				return false
			end
		else
			player:sendCancelMessage('You have already obtained this outfit!')
		end
	end
	return true
end

documents:id(7844, 7845, 7846)
documents:register()

local stoneTeleport = Action()

local config = {
	[1945] = {
		sacrifices = {
			{position = Position(32878, 32270, 14), itemId = 2016},
			{position = Position(32881, 32267, 14), itemId = 2168},
			{position = Position(32881, 32273, 14), itemId = 6300},
			{position = Position(32884, 32270, 14), itemId = 1487}
		},

		wells = {
			{position = Position(32874, 32263, 14), itemId = 3729, transformId = 3733},
			{position = Position(32875, 32263, 14), itemId = 3730, transformId = 3734},
			{position = Position(32874, 32264, 14), itemId = 3731, transformId = 3735},
			{position = Position(32875, 32264, 14), itemId = 3732, transformId = 3736}
		}
	},

	[1946] = {
		wells = {
			{position = Position(32874, 32263, 14), itemId = 3733, transformId = 3729},
			{position = Position(32875, 32263, 14), itemId = 3734, transformId = 3730},
			{position = Position(32874, 32264, 14), itemId = 3735, transformId = 3731},
			{position = Position(32875, 32264, 14), itemId = 3736, transformId = 3732}
		}
	}
}

function stoneTeleport.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local lever = config[item.itemid]
	if not lever then
		return true
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)

	local wellItem
	for i = 1, #lever.wells do
		wellItem = Tile(lever.wells[i].position):getItemById(lever.wells[i].itemId)
		if wellItem then
			wellItem:transform(well.transformId)
		end
	end

	if lever.sacrifices then
		local sacrificeItems, sacrificeItem = true
		for i = 1, #lever.sacrifices do
			sacrificeItem = Tile(lever.sacrifices[i].position):getItemById(lever.sacrifices[i].itemId)
			if not sacrificeItem then
				sacrificeItems = false
				break
			end
		end

		if not sacrificeItems then
			return true
		end

		local stonePosition = Position(32881, 32270, 14)
		local stoneItem = Tile(stonePosition):getItemById(1355)
		if stoneItem then
			stoneItem:remove()
		end

		local teleportExists = Tile(stonePosition):getItemById(1387)
		if not teleportExists then
			local newItem = Game.createItem(1387, 1, stonePosition)
			if newItem then
				newItem:setActionId(9031)
			end
		end
	end
	return true
end

stoneTeleport:uid(2004)
stoneTeleport:register()

local ticTac = Action()

function ticTac.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(item.itemid == 1945 and 1946 or 1945)

	if item.itemid ~= 1945 then
		return true
	end

	local ticTacPosition = Position(32838, 32264, 14)
	Game.createItem(2638, 1, ticTacPosition)
	Game.createItem(2639, 1, ticTacPosition)
	ticTacPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
	return true
end

ticTac:uid(2272)
ticTac:register()

local ticTacTeleport = Action()

local config = {
	{position = Position(32845, 32264, 14), itemId = 2639},
	{position = Position(32843, 32266, 14), itemId = 2639},
	{position = Position(32843, 32268, 14), itemId = 2639},
	{position = Position(32845, 32268, 14), itemId = 2639},
	{position = Position(32844, 32267, 14), itemId = 2639},
	{position = Position(32840, 32269, 14), itemId = 2639},
	{position = Position(32841, 32269, 14), itemId = 2638},
	{position = Position(32840, 32268, 14), itemId = 2638},
	{position = Position(32842, 32267, 14), itemId = 2638}
}

function ticTacTeleport.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	item:transform(item.itemid == 1945 and 1946 or 1945)

	iterateArea(
		function(position)
			local pillar = Tile(position):getItemById(1515)
			if pillar then
				pillar:remove()
			else
				Game.createItem(1515, 1, position)
			end
		end,
		Position(32835, 32285, 14),
		Position(32838, 32285, 14)
	)

	local tokens, ticTacToeItem = true
	for i = 1, #config do
		ticTacToeItem = Tile(config[i].position):getItemById(config[i].itemId)
		if not ticTacToeItem then
			tokens = false
			break
		end
	end

	if not tokens then
		return true
	end

	local position = Position(32836, 32288, 14)
	if item.itemid == 1945 then
		local crack = Tile(position):getItemById(6299)
		if crack then
			crack:remove()

			local teleport = Game.createItem(1387, 1, position)
			if teleport then
				teleport:setActionId(9032)
			end
		end
	else
		local teleport = Tile(position):getItemById(1387)
		if teleport then
			teleport:remove()
			Game.createItem(6299, 1, position)
		end
	end
	return true
end

ticTacTeleport:aid(8033)
ticTacTeleport:register()

local walls = Action()

local config = {
	[2246] = {
		[1] = {pos = Position(32763, 32292, 14), id = 1026},
		[2] = {pos = Position(32762, 32292, 14), id = 1026},
		[3] = {pos = Position(32761, 32292, 14), id = 1026}
	},

	[2247] = {
		[1] = {pos = Position(32760, 32289, 14), id = 1025},
		[2] = {pos = Position(32760, 32290, 14), id = 1025},
		[3] = {pos = Position(32760, 32291, 14), id = 1025},
		[4] = {pos = Position(32760, 32292, 14), id = 1030}
	},

	[2248] = {
		[1] = {pos = Position(32764, 32292, 14), id = 1029},
		[2] = {pos = Position(32764, 32291, 14), id = 1025},
		[3] = {pos = Position(32764, 32290, 14), id = 1025},
		[4] = {pos = Position(32764, 32289, 14), id = 1025}
	},

	[2249] = {
		[1] = {pos = Position(32760, 32288, 14), id = 1027},
		[2] = {pos = Position(32761, 32288, 14), id = 1026},
		[3] = {pos = Position(32762, 32288, 14), id = 1026},
		[4] = {pos = Position(32763, 32288, 14), id = 1026},
		[5] = {pos = Position(32764, 32288, 14), id = 1028}
	}
}

local function revertLever(position)
	local leverItem = Tile(position):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end
end

function walls.onUse(player, item, fromPosition, target, toPosition, isHotkey)
local walls = config[item.uid]
	if not walls then
		return true
	end

	if item.itemid ~= 1945 then
		return false
	end

	item:transform(1946)
	addEvent(revertLever, 8 * 1000, toPosition)

	local wallItem
	for i = 1, #walls do
		wallItem = Tile(walls[i].pos):getItemById(walls[i].id)
		if wallItem then
			wallItem:remove()
			addEvent(Game.createItem, 7 * 1000, walls[i].id, 1 , walls[i].pos)
		end
	end
	return true
end

walls:uid(2246, 2247, 2248, 2249)
walls:register()

local carrot = MoveEvent()

function carrot.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.uid == 2241 then
		if player:getItemCount(2684) > 0 then
			player:teleportTo(Position(32861, 32235, 9))
			player:removeItem(2684, 1)
		else
			player:teleportTo(fromPosition)
			doAreaCombatHealth(player, COMBAT_FIREDAMAGE, fromPosition, 0, -10, -20, CONST_ME_HITBYFIRE)
		end
	elseif item.uid == 2242 then
		player:teleportTo(Position(32861, 32240, 9))
	end

	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

carrot:type("stepin")
carrot:uid(2241, 2242)
carrot:register()

local fireBugTeleport = MoveEvent()

function fireBugTeleport.onStepIn(creature, item, position, fromPosition)

	return true
end

fireBugTeleport:type("stepin")
fireBugTeleport:uid(2243)
fireBugTeleport:register()

local riddle = MoveEvent()

function riddle.onStepIn(creature, item, position, fromPosition)
	item:transform(425)

	local index = item.actionid == 2245 and 'x' or 'y'
	local new_position = Position(position.x, position.y, position.z)
	for i = 1, 6 do
		new_position[index] = position[index] + 2 + i - 1
		local tile = Tile(new_position)
		local itemCount = tile:getDownItemCount()
		if itemCount > 0 then
			new_position[index] = position[index] + 2 + i % 6
			tile:getThing(tile:getTopItemCount() + tile:getCreatureCount() + itemCount):moveTo(new_position)
		end
	end
	return true
end

riddle:type("stepin")
riddle:aid(2245, 2246)
riddle:register()

local riddle = MoveEvent()

function riddle.onStepOut(creature, item, position, fromPosition)
	item:transform(426)
	return true
end

riddle:type("stepout")
riddle:aid(2245, 2246)
riddle:register()

local stoneTeleport = MoveEvent()

local config = {
	{position = Position(32873, 32263, 14), itemId = 1946, transformId = 1945},
	{position = Position(32874, 32263, 14), itemId = 3733, transformId = 3729},
	{position = Position(32875, 32263, 14), itemId = 3734, transformId = 3730},
	{position = Position(32874, 32264, 14), itemId = 3735, transformId = 3731},
	{position = Position(32875, 32264, 14), itemId = 3736, transformId = 3732}
}

local sacrifices = {
	{position = Position(32878, 32270, 14), itemId = 2016},
	{position = Position(32881, 32267, 14), itemId = 2168},
	{position = Position(32881, 32273, 14), itemId = 6300},
	{position = Position(32884, 32270, 14), itemId = 1487}
}

function stoneTeleport.onAddItem(moveitem, tileitem, position)
	local sacrificeItems, sacrificeItem = true
	for i = 1, #sacrifices do
		sacrificeItem = Tile(sacrifices[i].position):getItemById(sacrifices[i].itemId)
		if not sacrificeItem then
			sacrificeItems = false
			break
		end
	end

	if not sacrificeItems then
		return true
	end

	local stonePosition = Position(32881, 32270, 14)
	local stoneItem = Tile(stonePosition):getItemById(1355)
	if stoneItem then
		stoneItem:remove()
	end

	local teleportExists = Tile(stonePosition):getItemById(1387)
	if not teleportExists then
		local newItem = Game.createItem(1387, 1, stonePosition)
		if newItem then
			newItem:setActionId(9031)
			stonePosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
	end
	return true
end

stoneTeleport:type("additem")
stoneTeleport:aid(8034)
stoneTeleport:register()

local stoneTeleport = MoveEvent()

function stoneTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local sacrificeItems, sacrificeItem = true
	for i = 1, #sacrifices do
		sacrificeItem = Tile(sacrifices[i].position):getItemById(sacrifices[i].itemId)
		if not sacrificeItem then
			sacrificeItems = false
			break
		end
	end

	if not sacrificeItems then
		player:teleportTo(fromPosition)
		fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	for i = 1, #sacrifices do
		sacrificeItem = Tile(sacrifices[i].position):getItemById(sacrifices[i].itemId)
		if sacrificeItem then
			sacrificeItem:remove()
		end
	end

	player:teleportTo(Position(32920, 32296, 13))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	item:transform(1355)

	local thing
	for i = 1, #config do
		thing = Tile(config[i].position):getItemById(config[i].itemId)
		if thing then
			thing:transform(config[i].transformId)
		end
	end
	return true
end

stoneTeleport:type("stepin")
stoneTeleport:aid(9031)
stoneTeleport:register()

local teleports = MoveEvent()

local positions = {
	[2250] = Position(32915, 32263, 14),
	[2251] = Position(32946, 32270, 13),
	[2252] = Position(32976, 32270, 14),
	[2253] = Position(32933, 32282, 13),
	[2254] = Position(32753, 32344, 14),
	[2255] = Position(32753, 32344, 14)
}

function teleports.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:teleportTo(positions[item.uid])
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

teleports:type("stepin")
teleports:uid(2250, 2251, 2252, 2253, 2254, 2255)
teleports:register()

local ticTeleport = MoveEvent()

local config = {
	{position = Position(32836, 32288, 14), itemId = 1387, transformId = 6299},
	{position = Position(32836, 32278, 14), itemId = 1946, transformId = 1945},
	{position = Position(32834, 32285, 14), itemId = 1946, transformId = 1945}
}

local tokens = {
	{position = Position(32845, 32264, 14), itemId = 2639},
	{position = Position(32843, 32266, 14), itemId = 2639},
	{position = Position(32843, 32268, 14), itemId = 2639},
	{position = Position(32845, 32268, 14), itemId = 2639},
	{position = Position(32844, 32267, 14), itemId = 2639},
	{position = Position(32840, 32269, 14), itemId = 2639},
	{position = Position(32841, 32269, 14), itemId = 2638},
	{position = Position(32840, 32268, 14), itemId = 2638},
	{position = Position(32842, 32267, 14), itemId = 2638}
}

function ticTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local thing
	for i = 1, #config do
		thing = Tile(config[i].position):getItemById(config[i].itemId)
		if thing then
			thing:transform(config[i].transformId)
		end
	end

	local token
	for i = 1, #tokens do
		token = Tile(tokens[i].position):getItemById(tokens[i].itemId)
		if token then
			token:remove()
		end
	end

	player:teleportTo(Position(32874, 32275, 14))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

ticTeleport:type("stepin")
ticTeleport:aid(9032)
ticTeleport:register()

local tower = MoveEvent()

local config = {
	[3048] = {storageValue = 1, toPosition = Position(32360, 31782, 7)}, -- Carlin
	[3049] = {storageValue = 1, toPosition = Position(32369, 32241, 7)}, -- Thais
	[3050] = {storageValue = 1, toPosition = Position(32750, 32344, 14)}, -- Dream Realm
	[3051] = {storageValue = 2, toPosition = Position(32649, 31925, 11)}, -- Kazo
	[3052] = {storageValue = 2, toPosition = Position(32732, 31634, 7)}, -- Ab
	[3053] = {storageValue = 2, toPosition = Position(32181, 32436, 7)}, -- Fibula
	[3054] = {storageValue = 4, toPosition = Position(33213, 32454, 1)}, -- Darashia
	[3055] = {storageValue = 4, toPosition = Position(33194, 32853, 8)}, -- Ankrahmun
	[3056] = {storageValue = 4, toPosition = Position(32417, 32139, 15)} -- Mintwalin
}

function tower.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetTeleport = config[item.uid]
	if not targetTeleport then
		return true
	end

	if (player:getStorageValue(PlayerStorageKeys.OutfitQuest.NightmareOutfit) >= targetTeleport.storageValue or player:getStorageValue(PlayerStorageKeys.OutfitQuest.BrotherhoodOutfit) >= targetTeleport.storageValue) and player:removeItem(5022, 1) then
		player:teleportTo(targetTeleport.toPosition)
	else
		player:teleportTo(fromPosition)
	end

	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

tower:type("stepin")
tower:uid(3048, 3049, 3050, 3051, 3052, 3053, 3054, 3055, 3056)
tower:register()

local wallsTeleport = MoveEvent()

local walls = {
	Position(32760, 32288, 14),
	Position(32761, 32288, 14),
	Position(32762, 32288, 14),
	Position(32763, 32288, 14),
	Position(32764, 32288, 14),
	Position(32764, 32289, 14),
	Position(32764, 32290, 14),
	Position(32764, 32291, 14),
	Position(32764, 32292, 14),
	Position(32763, 32292, 14),
	Position(32762, 32292, 14),
	Position(32761, 32292, 14),
	Position(32760, 32292, 14),
	Position(32760, 32291, 14),
	Position(32760, 32290, 14),
	Position(32760, 32289, 14)
}

function wallsTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for i = 1, #walls do
		if Tile(walls[i]):hasFlag(TILESTATE_IMMOVABLEBLOCKSOLID) then
			player:teleportTo(Position(32762, 32305, 14))
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end

	player:teleportTo(Position(32852, 32287, 14))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

wallsTeleport:type("stepin")
wallsTeleport:uid(9030)
wallsTeleport:register()

local deathRing = MoveEvent()

local trees = {
	Position(32857, 32231, 11),
	Position(32857, 32232, 11),
	Position(32857, 32233, 11)
}

function deathRing.onAddItem(moveitem, tileitem, position)
	if moveitem.itemid ~= 6300 then
		return true
	end

	moveitem:remove()
	for i = 1, #trees do
		local treeItem = Tile(trees[i]):getItemById(2722)
		if treeItem then
			treeItem:remove()
			trees[i]:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
	end
	return true
end

deathRing:type("additem")
deathRing:uid(2244)
deathRing:register()

local clockTile = MoveEvent()

local words = {
	'YOU ARE DREAMING !',
	'WAKE UP !',
	'TIC TAC',
	'TAC',
	'TIC'
}

function clockTile.onAddItem(moveitem, tileitem, position)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	position.x = position.x + math.random(-3, 3)
	position.y = position.y + math.random(-3, 3)
	player:say(words[math.random(#words)], TALKTYPE_MONSTER_SAY, false, 0, position)
	return true
end

clockTile:type("additem")
clockTile:aid(9049)
clockTile:register()

local deathRingTeleport = MoveEvent()

local trees = {
	Position(32857, 32231, 11),
	Position(32857, 32232, 11),
	Position(32857, 32233, 11)
}

function deathRingTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	player:teleportTo(Position(32819, 32347, 9))
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	for i = 1, #trees do
		if not Tile(trees[i]):getItemById(2722) then
			Game.createItem(2722, 1, trees[i])
			trees[i]:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		end
	end
	return true
end

deathRingTeleport:type("stepin")
deathRingTeleport:uid(9234)
deathRingTeleport:register()

local riddleTeleport = MoveEvent()

local destination = Position(32766, 32275, 14)
local topLeftPosition = Position(32817, 32333, 9)
local pillowPositions = {
	{itemid = 1686, center = topLeftPosition + Position(2, 2, 0)},
	{itemid = 1687, center = topLeftPosition + Position(2, 5, 0)},
	{itemid = 1688, center = topLeftPosition + Position(5, 2, 0)},
	{itemid = 1689, center = topLeftPosition + Position(5, 5, 0)}
}

function riddleTeleport.onStepIn(creature, item, position, fromPosition)
	if not player:getPlayer() then
		return true
	end

	local pillows = {}
	for i = 1, #pillowPositions do
		local pillowPos = pillowPositions[i]
		for x = -1, 1 do
			for y = -1, 1 do
				local item = Tile(pillowPos.center + Position(x, y, 0)):getThing(1)
				if not item or item.itemid ~= pillowPos.itemid then
					player:teleportTo(fromPosition, true)
					fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
					return true
				end

				pillows[#pillows + 1] = item
			end
		end
	end

	player:teleportTo(destination)
	destination:sendMagicEffect(CONST_ME_TELEPORT)

	for x = 1, 6 do
		for y = 1, 6 do
			local index = math.random(#pillows)
			pillows[index]:moveTo(topLeftPosition + Position(x, y, 0))
			table.remove(pillows, index)
		end
	end
	return true
end

riddleTeleport:type("stepin")
riddleTeleport:uid(50147)
riddleTeleport:register()
