local anthill = Action()

function anthill.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local mast = Position(32360, 31365, 7)
	if target.itemid == 3323 and item.itemid == 7243 then
		if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Questline) == 6 then
			toPosition:sendMagicEffect(CONST_ME_GROUNDSHAKER)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission03, 2) -- Questlog The Ice Islands Quest, Nibelor 2: Ecological Terrorism
			player:say("You fill the jug with ants.", TALKTYPE_MONSTER_SAY)
			item:transform(7244)
		end
	elseif target.itemid == 4942 and item.itemid == 7244 and toPosition.x == mast.x and toPosition.y == mast.y and toPosition.z == mast.z then
		if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Questline) == 6 then
			toPosition:sendMagicEffect(CONST_ME_GROUNDSHAKER)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Questline, 7)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission03, 3) -- Questlog The Ice Islands Quest, Nibelor 2: Ecological Terrorism
			player:say("You released ants on the hill.", TALKTYPE_MONSTER_SAY)
			item:transform(7243)
		end
	end
	return true
end

anthill:id(7243, 7244)
anthill:register()

local charm = Action()

function charm.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 1354 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Questline) ~= 39 then
		return true
	end

	local obelisk1 = Position(32138, 31113, 14)
	local obelisk2 = Position(32119, 30992, 14)
	local obelisk3 = Position(32180, 31069, 14)
	local obelisk4 = Position(32210, 31027, 14)

	if toPosition.x == obelisk1.x and toPosition.y == obelisk1.y and toPosition.z == obelisk1.z then
		if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk01) < 5 then
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk01, 5)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission12, player:getStorageValue(PlayerStorageKeys.TheIceIslands.Mission12) + 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			player:say("You mark an obelisk with the frost charm.", TALKTYPE_MONSTER_SAY)
		end
	elseif toPosition.x == obelisk2.x and toPosition.y == obelisk2.y and toPosition.z == obelisk2.z then
		if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk02) < 5 then
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk02, 5)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission12, player:getStorageValue(PlayerStorageKeys.TheIceIslands.Mission12) + 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			player:say("You mark an obelisk with the frost charm.", TALKTYPE_MONSTER_SAY)
		end
	elseif toPosition.x == obelisk3.x and toPosition.y == obelisk3.y and toPosition.z == obelisk3.z then
		if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk03) < 5 then
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk03, 5)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission12, player:getStorageValue(PlayerStorageKeys.TheIceIslands.Mission12) + 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			player:say("You mark an obelisk with the frost charm.", TALKTYPE_MONSTER_SAY)
		end
	elseif toPosition.x == obelisk4.x and toPosition.y == obelisk4.y and toPosition.z == obelisk4.z then
		if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk04) < 5 then
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Obelisk04, 5)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission12, player:getStorageValue(PlayerStorageKeys.TheIceIslands.Mission12) + 1) -- Questlog The Ice Islands Quest, Formorgar Mines 4: Retaliation
			toPosition:sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			player:say("You mark an obelisk with the frost charm.", TALKTYPE_MONSTER_SAY)
		end
	end
	return true
end

charm:id(7289)
charm:register()

local cure = Action()

function cure.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 7106 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Questline) >= 21 then
		toPosition:sendMagicEffect(CONST_ME_MAGIC_BLUE)
		player:say('You take some hot water from the geyser.', TALKTYPE_MONSTER_SAY)
		item:transform(7246)
	end
	return true
end

cure:id(7286)
cure:register()

local paint = Action()

local function transformBack(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
		position:sendMagicEffect(CONST_ME_MAGIC_GREEN)
	end
end

function paint.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 7178 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Questline) == 8 then
		toPosition:sendMagicEffect(CONST_ME_MAGIC_GREEN)
		player:setStorageValue(PlayerStorageKeys.TheIceIslands.PaintSeal, player:getStorageValue(PlayerStorageKeys.TheIceIslands.PaintSeal) + 1)
		if player:getStorageValue(PlayerStorageKeys.TheIceIslands.PaintSeal) == 2 then
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Questline, 9)
			player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission04, 2) -- Questlog The Ice Islands Quest, Nibelor 3: Artful Sabotage
		end

		player:say('You painted a baby seal.', TALKTYPE_MONSTER_SAY)
		target:transform(7252)
		addEvent(transformBack, 30 * 1000, toPosition, 7252, 7178)
	end
	return true
end

paint:id(7253)
paint:register()

local yakchal = Action()

local creatureName = {
	[1] = 'ice golem',
	[2] = 'ice witch',
	[3] = 'crystal spider',
	[4] = 'frost dragon'
}

local function summonMonster(name, position)
	Game.createMonster(name, position)
	position:sendMagicEffect(CONST_ME_TELEPORT)
end

function yakchal.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local sarcophagus = Position(32205, 31002, 14)
	if toPosition.x == sarcophagus.x and toPosition.y == sarcophagus.y and toPosition.z == sarcophagus.z and target.itemid == 7362 and item.itemid == 2361 then
		if Game.getStorageValue(GlobalStorageKeys.Yakchal) < os.time() then
			Game.setStorageValue(GlobalStorageKeys.Yakchal, os.time() + 24 * 60 * 60)
			if math.random(2) == 2 then
				player:say("You have awoken the icewitch Yakchal from her slumber! She seems not amused...", TALKTYPE_MONSTER_SAY)
			else
				player:say("The frozen starlight shattered, but you have awoken the icewitch Yakchal from her slumber! She seems not amused...", TALKTYPE_MONSTER_SAY)
				item:remove(1)
			end

			Game.createMonster("Yakchal", toPosition)
			toPosition:sendMagicEffect(CONST_ME_TELEPORT)

			local creature, pos
			for i = 1, 4 do
				creature = creatureName[i]
				for k = 1, 70 do
					pos = Position(math.random(32193, 32215), math.random(30985, 31014), 14)
					if math.random(i + 1) == 1 then
						addEvent(summonMonster, (i - 1) * 10 * 1000, creature, pos)
					end
				end
			end
		else
			player:say("Yakchal has already been awakened today. You should try again tomorrow.", TALKTYPE_MONSTER_SAY)
		end
	end
	return true
end

yakchal:id(2361)
yakchal:register()

local helheim = MoveEvent()

function helheim.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.TheIceIslands.Questline) ~= 30 then
		return true
	end

	player:setStorageValue(PlayerStorageKeys.TheIceIslands.Mission07, 3) -- Questlog The Ice Islands Quest, The Secret of Helheim
	player:setStorageValue(PlayerStorageKeys.TheIceIslands.Questline, 31)
	player:say('You discovered the necromantic altar and should report about it.', TALKTYPE_MONSTER_SAY)
	position:sendMagicEffect(CONST_ME_MAGIC_RED)

	for x = -1, 1 do
		for y = -1, 1 do
			if y ~= 0 or x ~= 0 then
				Position(position.x + x, position.y + y, position.z):sendMagicEffect(CONST_ME_MORTAREA)
			end
		end
	end

	Position(position.x, position.y - 1, position.z):sendMagicEffect(CONST_ME_YALAHARIGHOST)
	return true
end

helheim:type("stepin")
helheim:uid(12031)
helheim:register()

local nibelorDogSled = MoveEvent()

local config = {
	[12025] = {destination = Position(32407, 31067, 7), storage = PlayerStorageKeys.TheIceIslands.Mission06, value = 8},
	[12026] = {destination = Position(32365, 31059, 7), storage = PlayerStorageKeys.TheIceIslands.Mission06, value = 8},
	[12027] = {destination = Position(32329, 31045, 7), storage = PlayerStorageKeys.TheIceIslands.Mission03, value = 3},
	[12028] = {destination = Position(32301, 31080, 7), storage = PlayerStorageKeys.TheIceIslands.Mission03, value = 3}
}

function nibelorDogSled.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local sled = config[item.uid]
	if not sled then
		return true
	end

	if player:getStorageValue(sled.storage) == sled.value and player:removeItem(2671, 1) then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:teleportTo(sled.destination)
		sled.destination:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

nibelorDogSled:type("stepin")
nibelorDogSled:aid(12025, 12026, 12027, 12028)
nibelorDogSled:register()
