local amforas = Action()

function amforas.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission05) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission06) ~= 1 then
		local chances = math.random(30)
		if chances == 13 then
			player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission06,1)
			player:say("You've got an amazing heart!", TALKTYPE_MONSTER_SAY)
			player:getPosition():sendMagicEffect(CONST_ME_HEARTS)
			player:addItem(21394,1)
		else
			player:say("Keep it trying!", TALKTYPE_MONSTER_SAY)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
		end
	else
		player:say("You've already got your heart", TALKTYPE_MONSTER_SAY)
	end
	return true
end

amforas:aid(4630)
amforas:register()

local brain = Action()

function brain.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local rightbrain = Tile(Position(33025, 32332, 10))
	local leftbrain = Tile(Position(33020, 32332, 10))
	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission08) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission09) < 1 then
		if leftbrain:getItemById(10576) and rightbrain:getItemById(10576) then
			player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission09, 1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<brzzl> <frzzp> <fsssh>')
			leftbrain:getItemById(10576):remove()
			rightbrain:getItemById(10576):remove()
			Game.createItem(21395, 1, Position(33022, 32332, 10))
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'No brains')
		end
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have already got your brain')
	end
	return true
end

brain:aid(4631)
brain:register()

local bones = Action()

function bones.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4633 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission17) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission19) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission19, 1)
		player:addItem(21406, 1)
		item:remove()
	end
	return true
end

bones:id(21407)
bones:register()

local tincture = Action()

function tincture.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4635 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission23) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission24) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission24,1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You crash the vial and spill the blood tincture. This altar is anointed.')
		item:remove()
	end
	return true
end

tincture:id(21245)
tincture:register()

local statue = Action()

function statue.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4636 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission24) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission25) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission25,1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<BOOOOOOOONGGGGGG> A slow throbbing, like blood pulsing, runs through the floor.')
		player:getPosition():sendMagicEffect(CONST_ME_SOUND_GREEN)
	end
	return true
end

statue:aid(4636)
statue:register()

local chalk = Action()

function chalk.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4637 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission27) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission28) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission28, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The flame wavers as it engulfs the chalk. Strange ashes appear beside it.')
		Game.createItem(21446, 1, Position(32983, 32376, 11))
		item:remove(1)
	end
	return true
end

chalk:id(21247)
chalk:register()

local firstKey = Action()

function firstKey.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4639 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission31) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<swoosh> <oomph> <cough, cough>')
		item:remove(1)
		Tile(Position(33071, 32442, 11)):getItemById(9624):transform(9625)
	end
	return true
end

firstKey:id(21482)
firstKey:register()

local candles = Action()

function candles.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4640 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission31) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission32) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission32, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Reading the parchment, you identify three human tallow candles and pocket them.')
		player:addItem(21248, 3)
		item:remove(1)
	end
	return true
end

candles:id(21448)
candles:register()

local monks = Action()

local config = {
	[4641] = {storageKey = {PlayerStorageKeys.GravediggerOfDrefia.Mission32, PlayerStorageKeys.GravediggerOfDrefia.Mission32a}, message = 'Shadows rise and engulf the candle. The statue flickers in an unearthly light.'},
	[4642] = {storageKey = {PlayerStorageKeys.GravediggerOfDrefia.Mission32a, PlayerStorageKeys.GravediggerOfDrefia.Mission32b}, message = 'The shadows of the statue swallow the candle hungrily.'},
	[4643] = {storageKey = {PlayerStorageKeys.GravediggerOfDrefia.Mission32b, PlayerStorageKeys.GravediggerOfDrefia.Mission33}, message = 'A shade emerges and snatches the candle from your hands.'}
}

function monks.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItem = config[target.actionid]
	if not targetItem then
		return true
	end

	local cStorages = targetItem.storageKey
	if player:getStorageValue(cStorages[1]) == 1 and player:getStorageValue(cStorages[2]) < 1 then
		player:setStorageValue(cStorages[2], 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetItem.message)
		item:remove(1)
	end
	return true
end

monks:id(21248)
monks:register()

local blood = Action()

local config = {
	[4644] = {storageKey = {PlayerStorageKeys.GravediggerOfDrefia.Mission36, PlayerStorageKeys.GravediggerOfDrefia.Mission36a}, message = 'The blood in the vial is of a deep, ruby red.', itemId = 21418},
	[4645] = {storageKey = {PlayerStorageKeys.GravediggerOfDrefia.Mission36a, PlayerStorageKeys.GravediggerOfDrefia.Mission37}, message = 'The blood in the vial is of a strange colour, as if tainted.', itemId = 21419}
}

function blood.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItem = config[target.actionid]
	if not targetItem then
		return true
	end

	local cStorages = targetItem.storageKey
	if player:getStorageValue(cStorages[1]) == 1 and player:getStorageValue(cStorages[2]) < 1 then
		player:setStorageValue(cStorages[2], 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, targetItem.message)
		player:addItem(targetItem.itemId, 1)
		item:remove(1)
	end
	return true
end

blood:id(21417)
blood:register()

local firstPyramids = Action()

local config = {
	[4646] = {PlayerStorageKeys.GravediggerOfDrefia.Mission38, PlayerStorageKeys.GravediggerOfDrefia.Mission38a},
	[4647] = {PlayerStorageKeys.GravediggerOfDrefia.Mission38a, PlayerStorageKeys.GravediggerOfDrefia.Mission38b},
	[4648] = {PlayerStorageKeys.GravediggerOfDrefia.Mission38b, PlayerStorageKeys.GravediggerOfDrefia.Mission38c},
	[4649] = {PlayerStorageKeys.GravediggerOfDrefia.Mission38c, PlayerStorageKeys.GravediggerOfDrefia.Mission39}
}

function firstPyramids.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local cStorages = config[target.actionid]
	if not cStorages then
		return true
	end

	if player:getStorageValue(cStorages[1]) == 1 and player:getStorageValue(cStorages[2]) < 1 then
		player:setStorageValue(cStorages[2], 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<sizzle> <fizz>')
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	end
	return true
end

firstPyramids:id(21449)
firstPyramids:register()

local palanca = Action()

function palanca.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission39) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission40) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission40, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<sizzle> <fizz>')
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	end
	return true
end

palanca:aid(4650)
palanca:register()

local secondKey = Action()

function secondKey.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4661 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission52) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission53) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission53, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "An invisible hand pulls you inside.")
		player:teleportTo(Position(33011, 32392, 10))
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	elseif player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission54) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission55) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission55, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Get out of my room!")
		player:teleportTo(Position(33008, 32392, 10))
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

secondKey:id(21489)
secondKey:register()

local cape = Action()

function cape.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission59) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission60) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission60, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You now look like a Necromancer.')
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:removeItem(21464, 1)
	end
	return true
end

cape:id(21464)
cape:register()

local scroll = Action()

function scroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission53) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission54) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission54, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Somebody left a card. It says: Looking for the scroll? Come find me. Take the stairs next to the students. Dorm.')
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

scroll:aid(4662)
scroll:register()

local secondPyramids = Action()

function secondPyramids.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not table.contains({4663, 4664, 4665, 4666, 4667}, target.actionid) then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission61) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission62) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission62, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<screeeech> <squeak> <squeaaaaal>')
	elseif player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission62) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission63) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission63, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<screeeech> <squeak> <squeaaaaal>')
	elseif player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission63) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission64) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission64, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<screeeech> <squeak> <squeaaaaal>')
	elseif player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission64) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission65) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission65, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<screeeech> <squeak> <squeaaaaal>')
	elseif player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission65) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission66) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission66, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, '<screeeech> <squeak> <squeaaaaal>')
	end
	return true
end

secondPyramids:aid(4663, 4664, 4665, 4666, 4667)
secondPyramids:register()

local bookcase = Action()

function bookcase.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission69) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission70) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission70, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found a crumpled paper.')
		player:addItem(21474, 1)
	end
	return true
end

bookcase:aid(4669)
bookcase:register()

local crate = Action()

function crate.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission63) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission64) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission64, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found an incantation fragment.')
		player:addItem(21250, 1)
	end
	return true
end

crate:uid(4663)
crate:register()

local sacrifice = Action()

function sacrifice.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission72) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission73) < 1 then
		local skullItem = Tile(Position(33071, 32442, 11)):getItemById(21476)
		if skullItem then
			skullItem:remove()
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The scroll burns to dust. The magic stutters. Omrabas\' soul flees to his old hideaway.')
			player:removeItem(21251, 1)
			player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission73, 1)
			Game.createMonster("Chicken", Position(33015, 32418, 11))
		end
	end
	return true
end

sacrifice:aid(21251)
sacrifice:register()

local inscriptions = Action()

function inscriptions.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission45) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission46) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission46, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The words seem to breathe, stangely. One word stays in your mind: bronze')
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	elseif player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission46) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission47) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission47, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The words seem to glow slightly. A name fixes in your mind: Takesha Antishu')
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	elseif player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission47) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission48) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission48, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The words seem to flutter. One word stays in your mind: floating')
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
	end
	return true
end

inscriptions:aid(4651, 4652, 4653)
inscriptions:register()

local ashes = Action()

function ashes.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4638 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission28) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission29) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission29, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The ashes swirl with a life of their own, mixing with the sparks of the altar.')
		item:remove(1)
	end
	return true
end

ashes:id(21446)
ashes:register()

local hallowed = Action()

function hallowed.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4634 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission19) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission20) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission20, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The flames roar and eat the bone hungrily. The Dark Lord is satisfied with your gift')
		item:remove()
	end
	return true
end

hallowed:id(21406)
hallowed:register()

local tears = Action()

function tears.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4632 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission14) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission15) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission15, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The dragon tears glow and disappear. The old powers are appeased.')
		item:remove(3)
	end
	return true
end

tears:id(21401)
tears:register()

local flask = Action()

function flask.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.itemid ~= 2817 then
		return false
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission11) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission12) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission12, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Done! Report back to Omrabas.')
		player:addItem(21403, 1)
		item:remove()
	end
	return true
end

flask:id(21402)
flask:register()

local amfora = MoveEvent()

function amfora.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 4530 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission05) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission06) < 1 then
		player:teleportTo(Position(32987, 32401, 9))
	else
		player:teleportTo(Position(32988, 32397, 9))
	end

	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	return true
end

amfora:type("stepin")
amfora:aid(4530, 4531)
amfora:register()

local brain = MoveEvent()

function brain.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 4532 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission08) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission09) < 1 then
		player:teleportTo(Position(33022, 32338, 10))
	else
		player:teleportTo(Position(33022, 32334, 10))
	end

	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	return true
end

brain:type("stepin")
brain:aid(4532, 4533)
brain:register()

local dormitori = MoveEvent()

function dormitori.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 4534 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission55) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission56) < 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission56,1)
		player:teleportTo(Position(33015, 32440, 10))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You should hurry, try not to dwell here any longer than a few minutes.')
	else
		player:teleportTo(Position(33018, 32437, 10))
	end

	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	return true
end

dormitori:type("stepin")
dormitori:aid(4534, 4535)
dormitori:register()

local sacrificeTeleport = MoveEvent()

function sacrificeTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 4541 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission72) == 1 then
		player:teleportTo(Position(33021, 32419, 11))
	else
		player:teleportTo(Position(33015, 32422, 11))
	end

	player:getPosition():sendMagicEffect(CONST_ME_POFF)
	return true
end

sacrificeTeleport:type("stepin")
sacrificeTeleport:aid(4541, 4542)
sacrificeTeleport:register()

local necromancerServant = MoveEvent()

function necromancerServant.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission56) == 1 and player:getStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission57) ~= 1 then
		player:setStorageValue(PlayerStorageKeys.GravediggerOfDrefia.Mission57, 1)
		Game.createMonster('Necromancer Servant', Position(33011, 32437, 11))
	end
	return true
end

necromancerServant:type("stepin")
necromancerServant:aid(4536)
necromancerServant:register()
