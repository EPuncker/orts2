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
