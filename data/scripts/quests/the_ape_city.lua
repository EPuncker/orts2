local theDeepestCatacombsLever = Action()

local config = {
	leverTime = 15 * 60,
	leverPositions = {
		Position(32891, 32590, 11),
		Position(32843, 32649, 11),
		Position(32808, 32613, 11),
		Position(32775, 32583, 11),
		Position(32756, 32494, 11),
		Position(32799, 32556, 11)
	},

	gateLevers = {
		{position = Position(32862, 32557, 11), duration = 15 * 60},
		{position = Position(32862, 32555, 11), duration = 60, ignoreLevers = true}
	},

	walls = {
		{position = Position(32864, 32556, 11), itemId = 3474}
	}
}

local function revertLever(position)
	local leverItem = Tile(position):getItemById(1946)
	if leverItem then
		leverItem:transform(1945)
	end
end

local function revertWalls(leverPosition)
	revertLever(leverPosition)

	for i = 1, #config.walls do
		Game.createItem(config.walls[i].itemId, 1, config.walls[i].position)
	end
end

function theDeepestCatacombsLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 1945 then
		player:sendTextMessage(MESSAGE_INFO_DESCR, 'It doesn\'t move.')
		return true
	end

	if table.contains(config.leverPositions, toPosition) then
		item:transform(1946)
		addEvent(revertLever, config.leverTime * 1000, toPosition)
		return true
	end

	local gateLever
	for i = 1, #config.gateLevers do
		if toPosition == config.gateLevers[i].position then
			gateLever = config.gateLevers[i]
			break
		end
	end

	if not gateLever then
		return true
	end

	if not gateLever.ignoreLevers then
		for i = 1, #config.leverPositions do
			-- if lever not pushed, do not continue
			local leverItem = Tile(config.leverPositions[i]):getItemById(1946)
			if not leverItem then
				return false
			end
		end
	end

	-- open gate when all levers used
	for i = 1, #config.walls do
		local wallItem = Tile(config.walls[i].position):getItemById(config.walls[i].itemId)
		if not wallItem then
			player:say('The lever won\'t budge', TALKTYPE_MONSTER_SAY, false, nil, toPosition)
			return true
		end

		wallItem:remove()
		config.walls[i].position:sendMagicEffect(CONST_ME_MAGIC_RED)
	end

	addEvent(revertWalls, gateLever.duration * 1000, toPosition)
	item:transform(1946)
	return true
end

theDeepestCatacombsLever:aid(12129)
theDeepestCatacombsLever:uid(12131)
theDeepestCatacombsLever:register()

local theDeepestCatacombsSnakeDestroyer = Action()

function theDeepestCatacombsSnakeDestroyer.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 4861 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.TheApeCity.Questline) ~= 17 or player:getStorageValue(PlayerStorageKeys.TheApeCity.SnakeDestroyer) == 1 then
		return false
	end

	player:setStorageValue(PlayerStorageKeys.TheApeCity.SnakeDestroyer, 1)
	item:remove()
	target:transform(4862)
	target:decay()
	toPosition:sendMagicEffect(CONST_ME_FIREAREA)
	return true
end

theDeepestCatacombsSnakeDestroyer:id(4846)
theDeepestCatacombsSnakeDestroyer:register()

local parchmentDecyphering = MoveEvent()

function parchmentDecyphering.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.TheApeCity.Questline) == 7
			and player:getStorageValue(PlayerStorageKeys.TheApeCity.ParchmentDecyphering) ~= 1 then
		player:setStorageValue(PlayerStorageKeys.TheApeCity.ParchmentDecyphering, 1)
	end

	player:say("!-! -O- I_I (/( --I Morgathla", TALKTYPE_MONSTER_SAY)
	return true
end

parchmentDecyphering:type("stepin")
parchmentDecyphering:aid(12124)
parchmentDecyphering:register()

local theDeepestCatacombsFirstTeleport = MoveEvent()

function theDeepestCatacombsFirstTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.TheApeCity.Questline) >= 17 then
		player:teleportTo(Position(32749, 32536, 10))
	else
		player:teleportTo(fromPosition)
		player:sendTextMessage(MESSAGE_STATUS_SMALL, 'You don\'t have access to this area.')
	end

	position:sendMagicEffect(CONST_ME_TELEPORT)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

theDeepestCatacombsFirstTeleport:type("stepin")
theDeepestCatacombsFirstTeleport:uid(12129)
theDeepestCatacombsFirstTeleport:register()

local theDeepestCatacombsSecondTeleport = MoveEvent()

local amphoraPositions = {
	Position(32792, 32527, 10),
	Position(32823, 32525, 10),
	Position(32876, 32584, 10),
	Position(32744, 32586, 10)
}

function theDeepestCatacombsSecondTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	for i = 1, #amphoraPositions do
		local amphoraItem = Tile(amphoraPositions[i]):getItemById(4997)
		if not amphoraItem then
			player:teleportTo(Position(32852, 32544, 10))
			position:sendMagicEffect(CONST_ME_TELEPORT)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:sendTextMessage(MESSAGE_STATUS_SMALL, "There are 4 large amphoras that must be broken in order to open the teleporter.")
			return true
		end
	end

	player:teleportTo(Position(32885, 32632, 11))
	position:sendMagicEffect(CONST_ME_TELEPORT)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

theDeepestCatacombsSecondTeleport:type("stepin")
theDeepestCatacombsSecondTeleport:uid(12130)
theDeepestCatacombsSecondTeleport:register()
